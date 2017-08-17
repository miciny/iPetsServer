//
//  Handler.swift
//  PerfectTemplate
//
//  Created by maocaiyuan on 2017/7/5.
//
//

import Foundation
import PerfectHTTP
import PerfectLib

public class iPetsHandlers{

    //默认
    open static func indexHandler() throws -> RequestHandler {
        return {
            request, response in
            response.setHeader(.contentType, value: "text/html")
            response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
            // Ensure that response.completed() is called when your processing is done.
            response.completed()
        }
    }
    
    
//===================================USER==================================================
    //获取用户信息
    open static func getUserInfoHandler() throws -> RequestHandler {
        return {
            request, response in
            logger("用户信息请求开始")
            let time1 = NSDate()
            GetUserInfoHandler.getUserInfo(request, response: response)
            response.completed()
            let time2 = NSDate()
            let time = time2.timeIntervalSince(time1 as Date)
            logger("\(time)")
            logger("用户信息请求结束")
        }
    }
    
    
    //注册用户
    open static func registerUserHandler() throws -> RequestHandler {
        return {
            request, response in
            logger("注册用户请求开始")
            let time1 = NSDate()
            ResigsterAccountHandler.resigsterAccount(request, response: response)
            response.completed()
            let time2 = NSDate()
            let time = time2.timeIntervalSince(time1 as Date)
            logger("\(time)")
            logger("注册用户请求结束")
        }
    }
    
    
    
    
    
    
//===================================FRIENDS==================================================
    //朋友圈
    open static func getUserFriendsCircleHandler() throws -> RequestHandler {
        return {
            request, response in
            logger("朋友圈请求开始")
            let time1 = NSDate()
            GetUserFriendsCircleHandler.getFriendsCircle(request, response: response)
            response.completed()
            let time2 = NSDate()
            let time = time2.timeIntervalSince(time1 as Date)
            logger("\(time)")
            logger("朋友圈请求结束")
        }
    }
    
    //获取用户好友列表
    open static func getUserFriendsListHandler() throws -> RequestHandler {
        return {
            request, response in
            logger("用户好友列表请求开始")
            let time1 = NSDate()
            GetUserFriendsListHandler.getUserFriendsList(request, response: response)
            response.completed()
            let time2 = NSDate()
            let time = time2.timeIntervalSince(time1 as Date)
            logger("\(time)")
            logger("用户好友列表请求结束")
        }
    }
    
    
    
    
    
//===================================AI==================================================
    
    //人工智能训练
    open static func startTrainingHandler() throws -> RequestHandler {
        return {
            request, response in
            logger("人工智能训练请求开始")
            let time1 = NSDate()
            MNISTTrainHandler.startTraining(request, response: response)
            response.completed()
            let time2 = NSDate()
            let time = time2.timeIntervalSince(time1 as Date)
            logger("\(time)")
            logger("人工智能训练请求结束")
        }
    }
    //人工智能设置数据
    open static func startSetDataHandler() throws -> RequestHandler {
        return {
            request, response in
            logger("人工智能设置数据请求开始")
            let time1 = NSDate()
            MNISTSetDataToDBHandler.startSetData(request, response: response)
            response.completed()
            let time2 = NSDate()
            let time = time2.timeIntervalSince(time1 as Date)
            logger("\(time)")
            logger("人工智能设置数据请求结束")
        }
    }
    //人工智能上传训练数据
    open static func receiveTrainDataHandler() throws -> RequestHandler {
        return {
            request, response in
            logger("人工智能上传训练数据请求开始")
            let time1 = NSDate()
            MNISTReceiveDataHandler.receiveData(request, response: response)
            response.completed()
            let time2 = NSDate()
            let time = time2.timeIntervalSince(time1 as Date)
            logger("\(time)")
            logger("人工智能上传训练数据请求结束")
        }
    }
    
}
