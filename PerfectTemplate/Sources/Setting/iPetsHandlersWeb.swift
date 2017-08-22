//
//  iPetsHandlersWeb.swift
//  PerfectTemplate
//
//  Created by maocaiyuan on 2017/8/22.
//
//

import Foundation
import PerfectHTTP
import PerfectLib


public class iPetsHandlersWeb{

    //默认
    open static func indexHandler() throws -> RequestHandler {
        return {
            request, response in
            response.addHtmlHeader()
            response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
            // Ensure that response.completed() is called when your processing is done.
            response.completed()
        }
    }
}
