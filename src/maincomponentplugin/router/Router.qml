// SPDX-FileCopyrightText: 2022 UnionTech Software Technology Co., Ltd.

// SPDX-License-Identifier: LGPL-3.0-or-later

pragma Singleton
import QtQuick 2.0

// 全局的界面路由管理
// 用于在多个界面之前进行切换和导航，data参数作为属性传递给组件
// 在切换的过程中会记录路由历史，支持返回上一页

Item {
    // 当前路由状态 
    property var routeCurrent: routeIndex
    // 路由历史记录
    property var routeHistory: [routeIndex]
    // 调试
    onRouteCurrentChanged: {
        console.log("current route",routeCurrent.path)
    }
    // 首页
    property var routeIndex: {
        "path": "index",
        "component": "index/Index.qml"
    }
    // 我的反馈
    property var routeMyFeedback: {
        "path": "feedback/my",
        "component": "feedback/List.qml",
        "data": {typeFilter: true, relation: "create"}
    } 
    // 反馈广场
    property var routeAllFeedback: {
        "path": "feedback/all",
        "component": "feedback/List.qml",
        "data": {typeFilter: true}
    }
    // 我的收藏
    property var routeFavoriteFeedback: {
        "path": "feedback/collect",
        "component": "feedback/List.qml",
        "data": {relation: "collect"}
    }
    // 我的关注
    property var routeUrgeFeedback: {
        "path": "feedback/like",
        "component": "feedback/List.qml",
        "data": {relation: "like"}
    }
    // 反馈详情
    property var routeFeedbackDetail: {
        "path": "feedback/detail",
        "component": "feedback/Detail.qml"
    }
    // 网络错误
    property var routeNetworkError: {
        "path": "error/network",
        "component": "offline/Offline.qml"
    }

    // 显示首页
    function showIndex() {
        routeCurrent = routeIndex
        routeHistory.push(routeIndex)
    }
    // 显示反馈广场
    function showAllFeedback(push=true, type="") {
        const r = clone(routeAllFeedback)
        r.data = {typeFilter: true, type: type}
        routeCurrent = r
        if(push){
            routeHistory.push(r)
        }
    }
    // 显示我的反馈
    function showMyFeedback(push=true) {
        routeCurrent = routeMyFeedback
        if(push){
            routeHistory.push(routeMyFeedback)
        }
    }
    // 显示我的收藏
    function showFavoriteFeedback(push=true) {
        routeCurrent = routeFavoriteFeedback
        if(push){
            routeHistory.push(routeFavoriteFeedback)
        }
    }
    // 显示我的催促
    function showUrgeFeedback(push=true) {
        routeCurrent = routeUrgeFeedback
        if(push){
            routeHistory.push(routeUrgeFeedback)
        }
    }
    // 显示网络错误
    function showNetworkError() {
        routeCurrent = routeNetworkError
        routeHistory.push(routeNetworkError)
    }
    // 显示反馈详情
    function showFeedbackDetail(feedback) {
        // 复制对象避免在回退时，拿到相同数据
        const value = clone(routeFeedbackDetail)
        value.data = { feedback: feedback }
        routeCurrent = value
        routeHistory.push(value)
    }
    // 复制对象
    function clone(route) {
        return JSON.parse(JSON.stringify(route))
    }
    // 返回上一页
    function back() {
        routeHistory.pop()
        const r = routeHistory[routeHistory.length-1]
        console.log("back",JSON.stringify(r.data))
        routeCurrent = r
    }
}