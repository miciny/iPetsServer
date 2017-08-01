//
//  GetUserListHandler.swift
//  PerfectTemplate
//
//  Created by maocaiyuan on 2017/7/29.
//
//


import Foundation
import PerfectHTTP
import MySQL
import PerfectLib  //Log


class GetUserFriendsListHandler{
    
    class func getUserFriendsList(_ request: HTTPRequest, response: HTTPResponse){
        
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
            
            
            //=======================================查询用户是否存在================================================
            let statement = "select * from \(UserInfoConstans.userTable) where " + Funcs.getQuery_And(request)
            
            guard iPetsConnector.excuse(query: statement) else {
                Funcs.setDBErrorResponse(response, dict: dict)
                return
            }
            
            // 获取返回的数据
            let results = mysql.storeResults()!
            
            //如果没有
            if results.numRows() == 0{
                Log.info(message: "查询成功: 用户不存在")
                dict = UserFuncs.setUserExsitError(UserErrorType.userNotExsit, response: response)
                return
            }
            
            //有数据,用户存在
            results.close()
            Log.info(message: "查询成功: 用户存在")
            
            
            
            
            //=======================================查询用户的好友列表================================================
            let statementFriendRelationship = "select friendID from \(FriendsConstans.friendsRelationshipTable) where " + Funcs.getQuery_And(request)
            
            guard iPetsConnector.excuse(query: statementFriendRelationship) else {
                Funcs.setDBErrorResponse(response, dict: dict)
                return
            }
            
            // 获取返回的数据
            let resultsFriendRelationship = mysql.storeResults()!
            let friendRelationshipArray = self.progressFriendRelationshipData(resultsFriendRelationship)
            
            results.close()
            Log.info(message: "查询成功: 用户好友列表查询成功")
            
            if resultsFriendRelationship.numRows() == 0{
                Log.info(message: "查询成功: 用户无好友")
                Funcs.setOKResponse(response, dict: dict, resultArray: nil)
                return
            }
            
            
            //=======================================查询用户的好友的信息================================================
            
            let statementFriendsList = "select * from \(UserInfoConstans.userTable) where " + Funcs.getQuery_Or(data: friendRelationshipArray, fieldName: "uid")
            
            guard iPetsConnector.excuse(query: statementFriendsList) else {
                Funcs.setDBErrorResponse(response, dict: dict)
                return
            }
            
            // 获取返回的数据
            let resultsFriendsList = mysql.storeResults()!
            let resultArray = self.progressFriendsListData(resultsFriendsList)
            Funcs.setOKResponse(response, dict: dict, resultArray: resultArray)
            
        }else{
            Funcs.setDBErrorResponse(response, dict: dict)
        }
    }
    
    
    
    private class func progressFriendsListData(_ results: MySQL.Results) -> NSMutableArray{
        
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
    
    
    
    private class func progressFriendRelationshipData(_ results: MySQL.Results) -> NSMutableArray{
        
        //setup an array to store results
        let resultArray = NSMutableArray()
        
        results.forEachRow { row in
            resultArray.add(String(Int(row[0]!)!))
        }
        return resultArray
    }
}
