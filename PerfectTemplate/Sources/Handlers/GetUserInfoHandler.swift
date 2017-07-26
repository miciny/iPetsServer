//
//  iPetsDB.swift
//  PerfectTemplate
//
//  Created by maocaiyuan on 2017/7/5.
//
//

import Foundation
import PerfectHTTP
import MySQL
import PerfectLib  //Log


class GetUserInfoHandler{
    
    class func getUserInfo(_ request: HTTPRequest, response: HTTPResponse){
        
        var dict = NSMutableDictionary()
        
        defer {
            let tee = Funcs.dicToJsonStr(dict)
            response.appendBody(string: tee)
        }
        
        //检查参数
        dict = Funcs.checkParas(request, response: response, acceptPara: ["uid"])
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
            let statement = "select * from \(UserInfoConstans.userTale) where " + Funcs.getQuery(request)
            Log.info(message: "\(Date()): 执行请求 "+statement)
            
            guard mysql.query(statement: statement) else {
                Log.info(message: "Failure: \(mysql.errorCode()) \(mysql.errorMessage())")
                Funcs.setDBErrorResponse(response, dict: dict)
                return
            }
            
            // 获取返回的数据
            let results = mysql.storeResults()!
            
            //如果没有
            if results.numRows() == 0{
                Log.info(message: "查询失败: 用户不存在")
                dict = UserFuncs.setUserExsitError(UserErrorType.userNotExsit, response: response)
                return
            }
            
            //有数据
            let resultArray = self.progressData(results)
            Funcs.setOKResponse(response, dict: dict, resultArray: resultArray)
            
        }else{
            Funcs.setDBErrorResponse(response, dict: dict)
        }
    }
    
    
    private class func progressData(_ results: MySQL.Results) -> NSMutableArray{
        
        //setup an array to store results
        let resultArray = NSMutableArray()
        
        results.forEachRow { row in
            
            let dataDic = NSMutableDictionary()
            dataDic.setValue(row[0], forKey: "uid")
            dataDic.setValue(row[1], forKey: "nickname")
            dataDic.setValue(row[2], forKey: "name")
            
            resultArray.add(dataDic)
        }
        return resultArray
    }
}
