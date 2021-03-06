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
import PerfectSession


class GetUserInfoHandler{
    
    class func getUserInfo(_ request: HTTPRequest, response: HTTPResponse){
        
        response.addJsonAndUTF8Header()
        var dict = NSMutableDictionary()
        defer {
            let tee = Funcs.dicToJsonStr(dict)
            response.appendBody(string: tee)
        }
        
        //检查参数
        dict = CheckParameter.checkParas(request, response: response, acceptPara: ["uid"])
        guard dict.count == 0 else {
            return
        }
        
        //检查之后
        let iPetsConnector = iPetsDBConnector(dbName: iPetsDBConnectConstans.schema)
        defer {iPetsConnector.closeConnect()}                           //方法执行完后，需要调用
        
        //数据库连接成功
        if iPetsConnector.success{    // 确保执行的语句正确
            
            let statement = "select uid, username, nickname, name from \(UserInfoConstans.userTable) where " + QueryManager.getQuery_And(request)
            
            guard iPetsConnector.excuse(query: statement) else {
                SetResponseDic.setDBErrorResponse(response, dict: dict)
                return
            }
            
            // 获取返回的数据
            let results = iPetsConnector.mysql.storeResults()!
            
            //如果没有
            if results.numRows() == 0{
                logger("查询失败: 用户不存在")
                dict = UserFuncs.setUserExsitError(UserErrorType.userNotExsit, response: response)
                return
            }

            //有数据
            let resultArray = self.progressData(results)
            SetResponseDic.setOKResponse(response, dict: dict, resultArray: resultArray)
            
        }else{
            SetResponseDic.setDBErrorResponse(response, dict: dict)
        }
    }
    
    
    private class func progressData(_ results: MySQL.Results) -> NSMutableArray{
        
        //setup an array to store results
        let resultArray = NSMutableArray()
        
        results.forEachRow { row in
            
            let dataDic = NSMutableDictionary()
            dataDic.setValue(row[0], forKey: "uid")
            dataDic.setValue(row[1], forKey: "username")
            dataDic.setValue(row[2], forKey: "nickname")
            dataDic.setValue(row[3], forKey: "name")
            
            resultArray.add(dataDic)
        }
        return resultArray
    }
}
