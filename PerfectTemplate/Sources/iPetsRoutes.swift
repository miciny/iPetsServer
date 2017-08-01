//
//  Handler.swift
//  PerfectTemplate
//
//  Created by maocaiyuan on 2017/7/5.
//
//

import PerfectHTTP

public class iPetsRoutes{
    
    class func makeRoutes() -> Routes {
        var routes = Routes()
        
        do{
            
            //默认
            try routes.add(method: .get, uri: "/", handler: iPetsHandlers.indexHandler())
            try routes.add(method: .get, uri: "/index", handler: iPetsHandlers.indexHandler())
            
            
            //获取用户信息
            try routes.add(method: .get, uri: "/userinfo", handler: iPetsHandlers.getUserInfoHandler())
            //注册
            try routes.add(method: .get, uri: "/register", handler: iPetsHandlers.registerUserHandler())
            
            //朋友圈
            try routes.add(method: .get, uri: "/friends/circle", handler: iPetsHandlers.getUserFriendsCircleHandler())
            //好友列表
            try routes.add(method: .get, uri: "/friends/list", handler: iPetsHandlers.getUserFriendsListHandler())
            
            
            
            
            
            //人工智能 开始训练
            try routes.add(method: .get, uri: "/mcyAI/startTraining", handler: iPetsHandlers.startTrainingHandler())
            
            
        }catch {
            print(error)
        }
        
        return routes
    } 
}

