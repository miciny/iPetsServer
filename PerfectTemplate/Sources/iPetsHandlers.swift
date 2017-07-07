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
    
    
    //注册用户
    open static func registerUserHandler() throws -> RequestHandler {
        return {
            request, response in
            Log.info(message: "\(Date()): 注册用户请求开始")
            ResigsterAcountHandler.resigsterAcount(request, response: response)
            response.completed()
            Log.info(message: "\(Date()): 注册用户请求结束")
        }
    }
    
}
