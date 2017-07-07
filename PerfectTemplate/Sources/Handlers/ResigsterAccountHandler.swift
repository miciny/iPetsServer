
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
    
    class func resigsterAccount(_ request: HTTPRequest, response: HTTPResponse){
        
        var dict = NSMutableDictionary()
        
        defer {
            let tee = Funcs.dicToJsonStr(dict)
            response.appendBody(string: tee)
        }
        
        //检查参数
        dict = Funcs.checkParas(request, response: response, acceptPara: ["name", "nickname", "pw"])
        guard dict.count == 0 else {
            return
        }
        
        //检查之后
        let iPetsConnector = iPetsDBConnector(dbName: iPetsDBConnectConstans.schema)
        //方法执行完后，需要调用
        defer {
            iPetsConnector.closeConnect()
        }
        
        //数据库连接成功
        if iPetsConnector.success{    // 确保执行的语句正确
            let mysql = iPetsConnector.mysql!
            
            //检查是否已存在
            let nickname = request.params(named: "nickname")[0]
            if self.checkUserNickNameIsExsit(mysql: mysql, nikcname: nickname, response: response){
                Log.info(message: "注册失败: 用户已存在")
                dict = UserFuncs.setUserExsitError(UserErrorType.userIsExsit, response: response)
                return
            }
            
            //插入数据
            let name = request.params(named: "name")[0]
            let pw = request.params(named: "pw")[0]
            let statement = "INSERT INTO \(UserInfoConstans.userTale) SET nickname=\"\(nickname)\", name=\"\(name)\", pw=\"\(pw)\", regist_time=NOW()"
            Log.info(message: "\(Date()): 执行请求 "+statement)
            guard mysql.query(statement: statement) else {
                Log.info(message: "Failure: \(mysql.errorCode()) \(mysql.errorMessage())")
                Funcs.setDBErrorResponse(response, dict: dict)
                return
            }
            
            Log.info(message: "注册成功: 用户\(nickname)注册成功")
            Funcs.setOKMessage(response, dict: dict, str: "注册成功")
            
        }else{
            Funcs.setDBErrorResponse(response, dict: dict)
        }
    }

    
    //检查是否已存在
    private class func checkUserNickNameIsExsit(mysql: MySQL, nikcname: String, response: HTTPResponse) -> Bool{
        var exist = false
        let statement = "select * from UserInfo where nickname='" + nikcname + "'"
        Log.info(message: "\(Date()): 执行请求 " + statement)
        
        //执行操作，可能失败
        guard mysql.query(statement: statement) else {
            Log.info(message: "Failure: \(mysql.errorCode()) \(mysql.errorMessage())")
            return exist
        }
        
        // 获取返回的数据
        let results = mysql.storeResults()!
        
        if results.numRows() >= 1 {
            exist = true
        }
        return exist
    }
}
