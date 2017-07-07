//
//  UserFuncs.swift
//  PerfectTemplate
//
//  Created by maocaiyuan on 2017/7/7.
//
//

import Foundation
import PerfectHTTP

class UserFuncs{
    //用户存不存在
    class func setUserExsitError(_ error: UserErrorType, response: HTTPResponse) -> NSMutableDictionary{
        let dict = NSMutableDictionary()
        
        dict.setValue("false", forKey: "success")
        dict.setValue("\(error.rawValue)", forKey: "code")
        dict.setValue(error.description, forKey: "message")
        
        response.status = HTTPResponseStatus.badRequest
        return dict
    }
}
