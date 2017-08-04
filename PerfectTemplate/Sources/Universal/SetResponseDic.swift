//
//  SetResponseDic.swift
//  PerfectTemplate
//
//  Created by maocaiyuan on 2017/8/4.
//
//

import Foundation
import PerfectHTTP
import PerfectLib


enum ReceiveDataResultType {
    case ok //成功
    case noData  //没有上传数据
    case postFailed //上传失败
}


class SetResponseDic: NSObject{
    
    //正常
    class func setOKResponse(_ response: HTTPResponse, dict: NSMutableDictionary, resultArray: NSMutableArray? = nil){
        
        response.status = HTTPResponseStatus.ok
        dict.setValue("true", forKey: "success")
        dict.setValue(HTTPResponseStatus.ok.description, forKey: "code")
        if let resultArray = resultArray{
            dict.setValue(resultArray, forKey: "data")
        }else{
            dict.setValue("[]", forKey: "data")
        }
    }
    
    
    //正常
    class func setOKMessage(_ response: HTTPResponse, dict: NSMutableDictionary, message: String = ""){
        
        response.status = HTTPResponseStatus.ok
        dict.setValue("true", forKey: "success")
        dict.setValue(HTTPResponseStatus.ok.description, forKey: "code")
        dict.setValue(message, forKey: "message")
    }
    
    
    //失败
    class func setFailMessage(_ response: HTTPResponse, dict: NSMutableDictionary, message: String = ""){
        
        response.status = HTTPResponseStatus.ok
        dict.setValue("false", forKey: "success")
        dict.setValue(HTTPResponseStatus.badRequest.description, forKey: "code")
        dict.setValue(message, forKey: "message")
    }
    
    
    //数据库连接出错，设置
    class func setDBErrorResponse(_ response: HTTPResponse, dict: NSMutableDictionary){
        
        response.status = HTTPResponseStatus.serviceUnavailable
        dict.setValue("false", forKey: "success")
        dict.setValue(HTTPResponseStatus.serviceUnavailable.description, forKey: "code")
        dict.setValue("连接数据库出错", forKey: "message")
    }
    
    
    //根据状态 返回状态数据
    class func getStatus(_ resultStatus: ReceiveDataResultType, response: HTTPResponse) -> NSMutableDictionary{
        let dict = NSMutableDictionary()
        switch resultStatus {
        case .ok:
            SetResponseDic.setFailMessage(response, dict: dict, message: "ok")
            
        case .noData:
            SetResponseDic.setFailMessage(response, dict: dict, message: "没有上传数据")
            
        case .postFailed:
            SetResponseDic.setFailMessage(response, dict: dict, message: "上传失败")
        }
        return dict
    }
    
}
