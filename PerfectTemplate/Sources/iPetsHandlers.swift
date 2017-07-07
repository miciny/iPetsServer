//
//  Handler.swift
//  PerfectTemplate
//
//  Created by maocaiyuan on 2017/7/5.
//
//

import Foundation
import PerfectHTTP

public class iPetsHandlers{

    open static func indexHandler() throws -> RequestHandler {
        return {
            request, response in
            
            response.setHeader(.contentType, value: "text/html")
            response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
            // Ensure that response.completed() is called when your processing is done.
            response.completed()
        }
    }
    
    
    
    open static func userInfoHandler() throws -> RequestHandler {
        return {
            request, response in
    
            GetUserInfoHandler.getUserInfo(request, response: response)
            response.completed()
        }
    }
    
}
