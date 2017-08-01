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
    
    
    //获取用户信息
    open static func getUserInfoHandler() throws -> RequestHandler {
        return {
            request, response in
            Log.info(message: "\(Date()): 用户信息请求开始")
            GetUserInfoHandler.getUserInfo(request, response: response)
            response.completed()
            Log.info(message: "\(Date()): 用户信息请求结束")
        }
    }
    
    //获取用户好友列表
    open static func getUserFriendsListHandler() throws -> RequestHandler {
        return {
            request, response in
            Log.info(message: "\(Date()): 用户好友列表请求开始")
            GetUserFriendsListHandler.getUserFriendsList(request, response: response)
            response.completed()
            Log.info(message: "\(Date()): 用户好友列表请求结束")
        }
    }
    
    
    //注册用户
    open static func registerUserHandler() throws -> RequestHandler {
        return {
            request, response in
            Log.info(message: "\(Date()): 注册用户请求开始")
            ResigsterAccountHandler.resigsterAccount(request, response: response)
            response.completed()
            Log.info(message: "\(Date()): 注册用户请求结束")
        }
    }
    
    
    //朋友圈
    open static func getUserFriendsCircleHandler() throws -> RequestHandler {
        return {
            request, response in
            Log.info(message: "\(Date()): 朋友圈请求开始")
            GetUserFriendsCircleHandler.getFriendsCircle(request, response: response)
            response.completed()
            Log.info(message: "\(Date()): 朋友圈请求结束")
        }
    }
    
    
    
    //人工智能训练
    open static func startTrainingHandler() throws -> RequestHandler {
        return {
            request, response in
            Log.info(message: "\(Date()): 人工智能训练请求开始")
            MNISTTrain.startTraining()
            response.completed()
            Log.info(message: "\(Date()): 人工智能训练请求结束")
        }
    }
    
}
