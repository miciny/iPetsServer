
//
//  ResigstAcountHandler.swift
//  PerfectTemplate
//
//  Created by maocaiyuan on 2017/7/7.
//
//


import Foundation
import PerfectHTTP
import MySQL
import PerfectLib  //Log


class ResigsterAccountHandler{
    
    static var iPetsConnector: iPetsDBConnector?  //数据库操作
    
    class func resigsterAccount(_ request: HTTPRequest, response: HTTPResponse){
        
        response.addHeader(.contentType, value: "application/json")
        response.addHeader(.contentType, value: "text/html; charset=utf-8")
        
        var dict = NSMutableDictionary()  //返回的数据
        
        defer {
            let tee = Funcs.dicToJsonStr(dict)
            response.appendBody(string: tee)
        }
        
        //检查参数
        dict = CheckParameter.checkParas(request, response: response, acceptPara: ["name", "nickname", "pw"])
        guard dict.count == 0 else {
            return
        }
        
        //检查之后
        iPetsConnector = iPetsDBConnector(dbName: iPetsDBConnectConstans.schema)
        //方法执行完后，需要调用
        defer {
            iPetsConnector!.closeConnect()
        }
        
        //数据库连接成功
        if iPetsConnector!.success{    // 确保执行的语句正确
            
            //检查是否已存在
            let nickname = request.params(named: "nickname")[0]
            if self.checkUserNickNameIsExsit(nikcname: nickname, response: response){
                logger("注册失败: 用户已存在")
                dict = UserFuncs.setUserExsitError(UserErrorType.userIsExsit, response: response)
                return
            }
            
            //插入数据
            let name = request.params(named: "name")[0]
            let pw = request.params(named: "pw")[0]
            let statement = "INSERT INTO \(UserInfoConstans.userTable) SET nickname=\"\(nickname)\", name=\"\(name)\", pw=\"\(pw)\", regist_time=NOW()"
            
            guard iPetsConnector!.excuse(query: statement) else {
                SetResponseDic.setDBErrorResponse(response, dict: dict)
                return
            }
            
            logger("注册成功: 用户\(nickname)注册成功")
            SetResponseDic.setOKMessage(response, dict: dict, message: "注册成功")
            
        }else{
            SetResponseDic.setDBErrorResponse(response, dict: dict)
        }
    }

    
    //检查是否已存在
    private class func checkUserNickNameIsExsit(nikcname: String, response: HTTPResponse) -> Bool{
        var exist = false
        let statement = "select * from UserInfo where nickname='" + nikcname + "'"
        
        //执行操作，可能失败
        guard iPetsConnector!.excuse(query: statement) else {
            return exist
        }
        
        // 获取返回的数据
        let results = iPetsConnector!.mysql.storeResults()!
        
        if results.numRows() >= 1 {
            exist = true
        }
        return exist
    }
}
