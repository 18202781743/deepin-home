// SPDX-FileCopyrightText: 2022 UnionTech Software Technology Co., Ltd.

// SPDX-License-Identifier: LGPL-3.0-or-later

import QtQuick 2.11
import QtQuick.Controls 2.4
import org.deepin.dtk 1.0
import "../api"
import "../widgets"

Item {
    id: root
    ListModel {
        id: list_model
    }
    Component.onCompleted: {
        API.getQuestionnaire((result)=>{
            for(let item of result){
                list_model.append({
                    "uuid": item.uuid,
                    "title": item.title,
                    "summary": item.summary,
                    "end_at": new Date(item.end_at).toLocaleString(locale, Locale.ShortFormat),
                    "url": item.url,
                })
            }
            if(list_model.count == 0){
                container.sourceComponent = not_found
            } else {
                container.sourceComponent = list_view
            }
        })
    }
    // 加载动画
    Component {
        id: loading
        Loading {}
    }
    // 空数据
    Component {
        id: not_found
        NotFound {
            title: qsTr("无问卷信息")
            subtitle: qsTr("当前无问卷信息，感谢您的关注！")
        }
    }
    // 列表
    Component {
        id: list_view
        ListView {
            model: list_model
            delegate: Rectangle {
                width: sidebar.width - 20
                height: 66
                radius: 8
                color: index%2==0 ? Qt.rgba(0,0,0,0.05) : 'transparent';
                function read() {
                    API.markRead("p","q",uuid)
                    mark_dot.color = "#b1b1b1"
                    Qt.openUrlExternally(url)
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        parent.color=index%2==0 ? Qt.rgba(0,0,0,0.2) : Qt.rgba(0,0,0,0.1)
                    }
                    onExited: {
                        parent.color=index%2==0 ? Qt.rgba(0,0,0,0.05) : 'transparent'
                    }
                    onPressed: {
                        parent.color=Qt.rgba(0,0,0,0.3)
                    }
                    onReleased: {
                        parent.color=index%2==0 ? Qt.rgba(0,0,0,0.2) : 'transparent'
                    }
                    onClicked: {
                        read()
                    }
                }
                Rectangle {
                    color: "transparent"
                    x: 10
                    y: 12
                    width: parent.width-x*2
                    height: parent.height-y*2

                    Text {
                        id: title_text
                        x: 20
                        text: title
                        font.pixelSize: 14
                        font.bold: true
                    }
                    Rectangle {
                        id: mark_dot
                        width: 8
                        height: 8
                        radius: 4
                        color: "red"
                        anchors.right: title_text.left
                        anchors.rightMargin: 6
                        anchors.verticalCenter: title_text.verticalCenter
                    }
                    Text {
                        text: summary
                        anchors.top: title_text.bottom
                        anchors.left: title_text.left
                        color: Qt.rgba(0,0,0,0.7);
                        width: parent.width
                        elide: Text.ElideRight
                    }
                    Text {
                        text: "有效期至：" + end_at
                        anchors.right: parent.right
                        color: Qt.rgba(0,0,0,0.6);
                    }
                    RecommandButton {
                        text: qsTr("填写")
                        width: 60
                        height: 26
                        anchors.right: parent.right
                        anchors.top: title_text.bottom
                        onClicked: () => {
                            read()
                        }
                    }
                }

                Component.onCompleted: {
                    API.isRead("p", "q", uuid, (read) => {
                        if(read) {
                            mark_dot.color = "#b1b1b1"
                        }
                    })
                }
            }
        }
    }

    Loader {
        id: container
        anchors.fill: parent
        sourceComponent: loading
    }
}