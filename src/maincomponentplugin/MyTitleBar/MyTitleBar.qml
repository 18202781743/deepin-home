// SPDX-FileCopyrightText: 2022 UnionTech Software Technology Co., Ltd.

// SPDX-License-Identifier: LGPL-3.0-or-later

import QtQuick 2.11
import QtQuick.Layouts 1.7
import org.deepin.dtk 1.0
import "../api"

TitleBar {
    id: root
    signal notifyClicked()
    leftContent: Image {
        source: "/images/deepin-home.svg"
        sourceSize.width: 40
        sourceSize.height: 40
        x: 12
        anchors.verticalCenter: parent.verticalCenter
    }
    content: RowLayout {
        anchors.fill: parent
        // 填充空白
        Item {
            Layout.fillWidth: true
        }
        // 账户相关
        Rectangle {
            id: account_item
            Layout.preferredWidth: 110
            Layout.preferredHeight: parent.height
            // 头像
            Image {
                id: avatar_image
                source: API.isLogin ? API.avatar : "/images/avatar.svg"
                sourceSize.width: 26
                sourceSize.height: 26
                anchors.verticalCenter: parent.verticalCenter
            }
            // 昵称
            Text {
                text: API.isLogin ? API.nickname : qsTr("No login")
                id: nickname_text
                width: 60
                elide: Text.ElideRight
                anchors.left: avatar_image.right
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            // 下拉箭头
            DciIcon {
                name: "arrow_ordinary_down"
                sourceSize.width: 12
                sourceSize.height: 12
                theme: DTK.themeType
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
            }
            // 鼠标点击
            MouseArea {
                anchors.fill: parent
                onClicked:{
                    var pos = Qt.point(avatar_image.x, 30)
                    if(API.isLogin) {
                        accountMenu.popup(avatar_image, pos)
                    } else {
                        loginMenu.popup(avatar_image, pos)
                    }
                }
            }
            // 未登录菜单
            Menu {
                id: loginMenu
                width: account_item.width
                maxVisibleItems: 10
                MenuItem { 
                    text: qsTr("Login") 
                    onTriggered: {
                        worker.login()
                    }
                }
            }
            // 已登录菜单
            Menu {
                id: accountMenu
                width: account_item.width
                maxVisibleItems: 10
                MenuItem {
                    text: qsTr("Logout") 
                    onTriggered: {
                        worker.logout()
                    }
                }
            }
        }
        // 通知图标
        WindowButton {
            property bool hover
            Image {
                id: notify_icon
                source: "/images/msg.svg"
                sourceSize.width: 18
                sourceSize.height: 14
                visible: false
            }
            ColorOverlay {
                id: button_icon
                source: notify_icon
                width: 18
                height: 14
                anchors.centerIn: parent
                color: parent.hover ? "#0081FF" : "black";
                transform: rotation
                antialiasing: true
            }
            Rectangle {
                color: "red"
                visible: API.msgCount > 0
                anchors.left: button_icon.right
                anchors.leftMargin: -6
                anchors.bottom: button_icon.top
                anchors.bottomMargin: -6
                width: count_text.width + 6
                height: count_text.height
                radius: 5
                Text {
                    id: count_text
                    text: API.msgCount
                    color: "#fff"
                    anchors.centerIn: parent
                }
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    parent.hover = true
                }
                onExited: {
                    parent.hover = false
                }
                onClicked: {
                    root.notifyClicked()
                }
            }
        }
    }
    embedMode: false
}