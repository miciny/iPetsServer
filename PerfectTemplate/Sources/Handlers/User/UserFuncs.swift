//
//  UserFuncs.swift
//  PerfectTemplate
//
//  Created by maocaiyuan on 2017/7/7.
//
//

import Foundation
import PerfectHTTP

public enum UserErrorType: Int{
    case userNotExsit = 305
    case userIsExsit = 306
    
    public var description: String {
        switch self {
        case .userNotExsit	: return "用户不存在"
        case .userIsExsit   : return "用户已存在"
        }
    }
}

public class UserInfoConstans{
    class var userTable: String{
        get {
            return "UserInfo"
        }
    }
}

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
