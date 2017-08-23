//
//  GetUserFriendsCircle.swift
//  PerfectTemplate
//
//  Created by maocaiyuan on 2017/7/29.
//
//


import Foundation
import PerfectHTTP
import MySQL
import PerfectLib  //Log


class GetUserFriendsCircleHandler{
    
    class func getFriendsCircle(_ request: HTTPRequest, response: HTTPResponse){
        
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
        //方法执行完后，需要调用
        defer {iPetsConnector.closeConnect()}
        
        //数据库连接成功
        if iPetsConnector.success{    // 确保执行的语句正确
            
            let mysql = iPetsConnector.mysql!
            
            
            
            //=======================================查询用户是否存在================================================
            let statement = "select uid from \(UserInfoConstans.userTable) where " + QueryManager.getQuery_And(request)
            
            guard iPetsConnector.excuse(query: statement) else {
                SetResponseDic.setDBErrorResponse(response, dict: dict)
                return
            }
            
            // 获取返回的数据
            let results = mysql.storeResults()!
            
            //如果没有
            if results.numRows() == 0{
                logger("查询成功: 用户不存在")
                dict = UserFuncs.setUserExsitError(UserErrorType.userNotExsit, response: response)
                return
            }
            
            //有数据,用户存在
            results.close()
            logger("查询成功: 用户存在")
            
            
            
            
            //=======================================查询用户的好友列表================================================
            let statementFriendRelationship = "select friendID from \(FriendsConstans.friendsRelationshipTable) where " + QueryManager.getQuery_And(request)
            
            guard iPetsConnector.excuse(query: statementFriendRelationship) else {
                SetResponseDic.setDBErrorResponse(response, dict: dict)
                return
            }
            
            // 获取返回的数据
            let resultsFriendRelationship = mysql.storeResults()!
            let friendRelationshipArray = FriendsConstans.progressFriendRelationshipData(resultsFriendRelationship)
            
            results.close()
            logger("查询成功: 用户好友列表查询成功")
            
            
            
            
            //=======================================查询用户的朋友圈================================================
            let uid = request.params(named: "uid")[0]
            friendRelationshipArray.add(uid)
            
            let statementFriendsCircle = "select  id, uid, nickname, show_name, icon, type, text, images_urls, video_url, video_image_url, update_time from \(FriendsConstans.friendsCircleTable) where " + QueryManager.getQuery_Or(data: friendRelationshipArray, fieldName: "uid")
            
            guard iPetsConnector.excuse(query: statementFriendsCircle) else {
                SetResponseDic.setDBErrorResponse(response, dict: dict)
                return
            }
            
            // 获取返回的数据
            let resultsFriendsCircle = mysql.storeResults()!
            let resultArray = self.progressFriendsCircleData(resultsFriendsCircle)
            SetResponseDic.setOKResponse(response, dict: dict, resultArray: resultArray)
            
        }else{
            SetResponseDic.setDBErrorResponse(response, dict: dict)
        }
    }
    
    
    //=========================点赞=======================
    private class func getLikeDic(mid: Int) -> NSMutableArray?{
        
        let iPetsConnector = iPetsDBConnector(dbName: iPetsDBConnectConstans.schema)
        //方法执行完后，需要调用
        defer {iPetsConnector.closeConnect()}
        
        //查询点赞的uid
        let statement = "select uid from \(FriendsConstans.friendsLikeTable) where mid=\(mid)"
        guard iPetsConnector.excuse(query: statement) else {return nil}
        
        let dic = NSMutableArray()
        
        let likeResult = iPetsConnector.mysql.storeResults()!
        
        likeResult.forEachRow { (row) in
            let uid = row[0]!
            
            //每个uid查名字
            let ustatement = "select name from \(UserInfoConstans.userTable) where uid=\(uid)"
            guard iPetsConnector.excuse(query: ustatement) else {return}
            
            let userNameResult = iPetsConnector.mysql.storeResults()!
            userNameResult.forEachRow(callback: { (urow) in
                
                let dataDic = NSMutableDictionary()
                let name = urow[0]!
                
                dataDic.setValue(uid, forKey: "uid")
                dataDic.setValue(name, forKey: "name")
                
                dic.add(dataDic)
            })
        }
        
        return dic.count==0 ? nil : dic
    }
    
    //图片分解
    private class func getImageUrls(imageUrls: String) -> NSMutableArray{
        let dic = NSMutableArray()
        let array = imageUrls.components(separatedBy: "\n")
        dic.addObjects(from: array)
        return dic
    }
    
    
    //处理数据
    private class func progressFriendsCircleData(_ results: MySQL.Results) -> NSMutableArray{
        
        //setup an array to store results
        let resultArray = NSMutableArray()
        
        results.forEachRow { row in
            let dataDic = NSMutableDictionary()
            dataDic.setValue(row[0], forKey: "mid")
            dataDic.setValue(row[1], forKey: "uid")
            dataDic.setValue(row[2], forKey: "nickname")
            dataDic.setValue(row[3], forKey: "show_name")
            dataDic.setValue(row[4], forKey: "iconUrl")
            dataDic.setValue(row[5], forKey: "type")
            dataDic.setValue(row[6], forKey: "text")
            dataDic.setValue(row[8], forKey: "videoUrl")
            dataDic.setValue(row[9], forKey: "videoImageUrl")
            dataDic.setValue(row[10], forKey: "time")
            
            if let imageUrls = row[7]{
                let images = self.getImageUrls(imageUrls: imageUrls)
                dataDic.setValue(images, forKey: "imageUrls")
            }
            
            if let like = self.getLikeDic(mid: Int(row[0]!)!){
                dataDic.setValue(like, forKey: "likes")
            }
            
            resultArray.add(dataDic)
        }
        
        //按时间排序
        resultArray.sort(comparator: { (r1, r2) -> ComparisonResult in
            let r11 = r1 as! NSMutableDictionary
            let r22 = r2 as! NSMutableDictionary
            let r = Funcs.stringToDate(r11.value(forKey: "time") as! String, format: "yyyy-MM-dd HH:mm:ss")
            let d = Funcs.stringToDate(r22.value(forKey: "time") as! String, format: "yyyy-MM-dd HH:mm:ss")
            
            if r < d{
                return ComparisonResult.orderedAscending
            }else{
                return ComparisonResult.orderedDescending
            }
        })
        
        return resultArray
    }
}
