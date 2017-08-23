//
//  Handler.swift
//  PerfectTemplate
//
//  Created by maocaiyuan on 2017/7/5.
//
//

import PerfectHTTP

public class iPetsRoutes{
    
    // api
    
    class func makeAPIRoutes() -> Routes {
        var routes = Routes(baseUri: "api/v1")
        
        do{
            //获取用户信息
            try routes.add(method: .get, uri: "/userinfo", handler: iPetsHandlersAPI.getUserInfoHandler())
            //注册
            try routes.add(method: .get, uri: "/register", handler: iPetsHandlersAPI.registerUserHandler())
            //md5
            try routes.add(method: .get, uri: "/login/token", handler: iPetsHandlersAPI.userLoginTokenHandler())
            
            
            
            //朋友圈
            try routes.add(method: .get, uri: "/friends/circle", handler: iPetsHandlersAPI.getUserFriendsCircleHandler())
            //好友列表
            try routes.add(method: .get, uri: "/friends/list", handler: iPetsHandlersAPI.getUserFriendsListHandler())
            
            
            
            //人工智能 开始训练
            try routes.add(method: .get, uris: ["/mcyAI/startTraining", "/mcyAI/startTrain"], handler: iPetsHandlersAPI.startTrainingHandler())
            //人工智能 设置数据
            try routes.add(method: .get, uri: "/mcyAI/setData", handler: iPetsHandlersAPI.startSetDataHandler())
            //人工智能 上传数据
            try routes.add(method: .post, uri: "/mcyAI/uploadData", handler: iPetsHandlersAPI.receiveTrainDataHandler())
            
            
        }catch {
            print(error)
        }
        
        return routes
    }
    
    
    
    
    // web
    
    class func makeWebRoutes() -> Routes {
        
        var routes = Routes(baseUri: "/web")
        do {
            //默认
            try routes.add(method: .get, uri: "/", handler: iPetsHandlersWeb.indexHandler())
            try routes.add(method: .get, uri: "/index", handler: iPetsHandlersWeb.indexHandler())
            
        }catch {
            print(error)
        }
        
        //web  for CORS
        routes.add(method: .get, uri: "/sessionIndex", handler: CORSWebHandlers.indexHandlerGet)
        routes.add(method: .get, uri: "/nocsrf", handler: CORSWebHandlers.formNoCSRF)
        routes.add(method: .get, uri: "/withcsrf", handler: CORSWebHandlers.formWithCSRF)
        routes.add(method: .post, uris: ["/nocsrf", "/withcsrf"], handler: CORSWebHandlers.formReceive)
        routes.add(method: .get, uri: "/cors", handler: CORSWebHandlers.CORSHandlerGet)
        
        
        
        //login
        routes.add(method: .get, uri: "/auth", handler: TurnstileAuthHandlers.indexHandler)
        routes.add(method: .get, uri: "/login", handler: TurnstileAuthHandlers.loginHandlerGet)
        routes.add(method: .post, uri: "/login", handler: TurnstileAuthHandlers.loginHandlerPost)
        routes.add(method: .get, uri: "/register", handler: TurnstileAuthHandlers.registerGet)
        routes.add(method: .post, uri: "/register", handler: TurnstileAuthHandlers.registerPost)
        routes.add(method: .get, uri: "/me", handler: TurnstileAuthHandlers.getMyInfo)
        routes.add(method: .post, uri: "/logout", handler: TurnstileAuthHandlers.logout)
        
        return routes
    }
}

