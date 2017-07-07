//
//  iPetsDBConstans.swift
//  PerfectTemplate
//
//  Created by maocaiyuan on 2017/7/6.
//
//

import Foundation
import PerfectHTTP
import MySQL
import PerfectLib  //Log

//==================================常量=========================
class iPetsDBConnectConstans{
    
    class var host: String {
        get {
            return "127.0.0.1"
        }
    }
    
    class var port: String {
        get {
            return "3306"
        }
    }
    
    class var user: String {
        get {
            return "root"
        }
    }
    
    class var password: String {
        get {
            return "Miciny!@#$%^&*()123"
        }
    }
    
    class var schema: String{
        get {
            return "iPetsDB"
        }
    }
}


//==================================操作=========================
//
//如果连接成功了，返回mysql！ 如果失败了，返回nil
//

class iPetsDBConnector{
    
    var mysql: MySQL!
    var success: Bool!
    
    init(dbName: String) {
        if self.connectToDB(){
            if self.selectDataBase(named: dbName){
                success = true
            }else{
                success = false
            }
        }else{
            success = false
        }
    }
    
    //连接数据库
    private func connectToDB() -> Bool{
        if mysql == nil{
            mysql = MySQL()
        }
        
        //确保链接上数据库了
        let connected = mysql.connect(host: iPetsDBConnectConstans.host, user: iPetsDBConnectConstans.user, password: iPetsDBConnectConstans.password)
        
        guard connected else {
            Log.info(message: "Failure: \(mysql.errorCode()) \(mysql.errorMessage())")
            return false
        }
        
        Log.info(message: "Success: 数据库连接成功！")
        return true
    }
    
    //选择数据库
    private func selectDataBase(named: String) -> Bool{

        guard mysql.selectDatabase(named: named) else {
            Log.info(message: "Failure: \(mysql.errorCode()) \(mysql.errorMessage())")
            return false
        }
        
        guard mysql.query(statement: "set names utf8") else { //设置连接的编码，非常重要！！！！
            return false
        }
        
        Log.info(message: "Success: 数据库\(named)连接成功！")
        return true
    }
}


