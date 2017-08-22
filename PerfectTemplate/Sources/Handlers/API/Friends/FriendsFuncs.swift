//
//  FriendsFuncs.swift
//  PerfectTemplate
//
//  Created by maocaiyuan on 2017/7/29.
//
//

import Foundation
import MySQL

public class FriendsConstans{
    
    class var friendsRelationshipTable: String{
        get {
            return "FriendsRelationship"
        }
    }
    
    class var friendsCircleTable: String{
        get {
            return "FriendsCircle"
        }
    }
    
    class var friendsLikeTable: String{
        get {
            return "FriendsLike"
        }
    }
    
    
    //好友列表
    class func progressFriendRelationshipData(_ results: MySQL.Results) -> NSMutableArray{
        
        //setup an array to store results
        let resultArray = NSMutableArray()
        
        results.forEachRow { row in
            resultArray.add(String(Int(row[0]!)!))
        }
        return resultArray
    }
}

