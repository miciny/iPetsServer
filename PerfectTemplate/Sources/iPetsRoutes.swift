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
            try routes.add(method: .get, uri: "/", handler: iPetsHandlers.indexHandler())
            try routes.add(method: .get, uri: "/index", handler: iPetsHandlers.indexHandler())
            try routes.add(method: .get, uri: "/userinfo", handler: iPetsHandlers.userInfoHandler())
        }catch {
            print(error)
        }
        
        return routes
    } 
}

