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
        
        Log.info(message: "\(Date()): 用户信息请求开始")
        
        var dict = NSMutableDictionary()
        
        defer {
            let tee = Funcs.dicToJsonStr(dict)
            response.appendBody(string: tee)
            Log.info(message: "\(Date()): 用户信息请求结束")
        }
        
        //检查参数
        dict = Funcs.checkParas(request, response: response, acceptPara: ["uid"])
        guard dict.count == 0 else {
            Log.info(message: "Failure : 参数错误: " + String(dict.value(forKey: "code") as! Int))
            Log.info(message: "Failure : \(request.queryParams)")
            return
        }
        
        //检查之后
        let statement = "select * from UserInfo where " + Funcs.getQuery(request)
        let iPetsConnector = iPetsDBConnector(dbName: iPetsDBConnectConstans.schema)
        
        //方法执行完后，需要调用
        defer {
            Log.info(message: "\(Date()): 数据库连接关闭")
            iPetsConnector.mysql.close()
        }
        
        //数据库连接成功
        if iPetsConnector.success{    // 确保执行的语句正确
            let mysql = iPetsConnector.mysql!
            Log.info(message: "\(Date()): 执行请求 "+statement)
            
            //执行操作，可能失败
            guard mysql.query(statement: statement) else {
                Log.info(message: "Failure: \(mysql.errorCode()) \(mysql.errorMessage())")
                Funcs.setDBErrorResponse(response, dict: dict)
                return
            }
            
            // 获取返回的数据
            let results = mysql.storeResults()!
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
