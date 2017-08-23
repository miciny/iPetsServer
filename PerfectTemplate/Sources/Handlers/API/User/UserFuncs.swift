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
    
    
    //检查是否已存在
    class func checkUserNickNameIsExsit(nikcname: String, response: HTTPResponse) -> Bool{
        var exist = false
        let statement = "select * from \(UserInfoConstans.userTable) where nickname='" + nikcname + "'"
        
        let iPetsConnector = iPetsDBConnector(dbName: iPetsDBConnectConstans.schema)
        //方法执行完后，需要调用
        defer {iPetsConnector.closeConnect()}
        
        //执行操作，可能失败
        guard iPetsConnector.excuse(query: statement) else {
            return exist
        }
        
        // 获取返回的数据
        let results = iPetsConnector.mysql.storeResults()!
        
        if results.numRows() >= 1 {
            exist = true
        }
        return exist
    }
}
