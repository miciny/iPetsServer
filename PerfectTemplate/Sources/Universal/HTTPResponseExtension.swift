//
//  HTTPResponseExtension.swift
//  PerfectTemplate
//
//  Created by maocaiyuan on 2017/8/16.
//
//

import Foundation
import PerfectHTTP


extension HTTPResponse{
    
    func addJsonAndUTF8Header(){
        self.addHeader(.contentType, value: "application/json")
        self.addHeader(.contentType, value: "text/html; charset=utf-8")
    }
    
    func addHtmlHeader(){
        self.setHeader(.contentType, value: "text/html")
    }
}
