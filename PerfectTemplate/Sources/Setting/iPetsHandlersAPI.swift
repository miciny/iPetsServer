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

public class iPetsHandlersAPI{
    
    
//===================================USER==================================================
    //获取用户信息
    open static func getUserInfoHandler() throws -> RequestHandler {
        return {
            request, response in
            logger("用户信息请求开始")
            GetUserInfoHandler.getUserInfo(request, response: response)
            response.completed()
            logger("用户信息请求结束")
        }
    }
    
    
    //注册用户
    open static func registerUserHandler() throws -> RequestHandler {
        return {
            request, response in
            logger("注册用户请求开始")
            ResigsterAccountHandler.resigsterAccount(request, response: response)
            response.completed()
            logger("注册用户请求结束")
        }
    }
    
    //加密
    open static func userLoginTokenHandler() throws -> RequestHandler {
        return {
            request, response in
            logger("用户token请求开始")
            GetMD5Handler.getMD5(request, response: response)
            response.completed()
            logger("用户token请求结束")
        }
    }
    
    
    
    
    
    
//===================================FRIENDS==================================================
    //朋友圈
    open static func getUserFriendsCircleHandler() throws -> RequestHandler {
        return {
            request, response in
            logger("朋友圈请求开始")
            GetUserFriendsCircleHandler.getFriendsCircle(request, response: response)
            response.completed()
            logger("朋友圈请求结束")
        }
    }
    
    //获取用户好友列表
    open static func getUserFriendsListHandler() throws -> RequestHandler {
        return {
            request, response in
            logger("用户好友列表请求开始")
            GetUserFriendsListHandler.getUserFriendsList(request, response: response)
            response.completed()
            logger("用户好友列表请求结束")
        }
    }
    
    
    
    
    
//===================================AI==================================================
    
    //人工智能训练
    open static func startTrainingHandler() throws -> RequestHandler {
        return {
            request, response in
            logger("人工智能训练请求开始")
            MNISTTrainHandler.startTraining(request, response: response)
            response.completed()
            logger("人工智能训练请求结束")
        }
    }
    //人工智能设置数据
    open static func startSetDataHandler() throws -> RequestHandler {
        return {
            request, response in
            logger("人工智能设置数据请求开始")
            MNISTSetDataToDBHandler.startSetData(request, response: response)
            response.completed()
            logger("人工智能设置数据请求结束")
        }
    }
    //人工智能上传训练数据
    open static func receiveTrainDataHandler() throws -> RequestHandler {
        return {
            request, response in
            logger("人工智能上传训练数据请求开始")
            MNISTReceiveDataHandler.receiveData(request, response: response)
            response.completed()
            logger("人工智能上传训练数据请求结束")
        }
    }
    
}
