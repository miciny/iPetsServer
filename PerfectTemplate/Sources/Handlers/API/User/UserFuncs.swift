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
    class func checkUserNickNameIsExsit(_ nikcname: String) -> Bool{
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
    
    //注册  nil已存在, false注册失败, true注册成功
    class func registeUser(nickname: String, username: String, pw: String) -> Bool?{
        
        let iPetsConnector = iPetsDBConnector(dbName: iPetsDBConnectConstans.schema)
        //方法执行完后，需要调用
        defer {iPetsConnector.closeConnect()}
        
        //检查是否已存在
        if UserFuncs.checkUserNickNameIsExsit(nickname){
            logger("注册失败: 用户已存在")
            return nil
        }
        
        //插入数据
        let name = username
        let statement = "INSERT INTO \(UserInfoConstans.userTable) SET username=\"\(username)\", nickname=\"\(nickname)\", name=\"\(name)\", pw=\"\(pw)\", regist_time=NOW()"
        
        guard iPetsConnector.excuse(query: statement) else {
            return false
        }
        
        logger("注册成功: 用户\(nickname)注册成功")
        return true
    }

}




//链接数据库，插入数据
//if let s = UserFuncs.registeUser(nickname: username, username: username, pw: pw!) {
//    if s{
//        response.redirect(path: "/web/auth")
//    }else{
//        response.render(template: "register", context: ["flash": "database error"])
//    }
//    
//}else{
//    response.render(template: "register", context: ["flash": "username already exsit"])
//}
