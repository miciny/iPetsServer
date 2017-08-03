//
//  MNISTReceiveDataHandler.swift
//  PerfectTemplate
//
//  Created by maocaiyuan on 2017/8/3.
//
//

import Foundation
import PerfectLib
import PerfectHTTP
import MySQL

enum ReceiveDataResultType {
    case ok //成功
    case noData  //没有上传数据
    case postFailed //上传失败
}


class MNISTReceiveDataHandler{
    
    class func receiveData(_ request: HTTPRequest, response: HTTPResponse){
        response.addHeader(.contentType, value: "application/json")
        response.addHeader(.contentType, value: "text/html; charset=utf-8")
        
        
        var dict = NSMutableDictionary()
        
        defer {
            let tee = Funcs.dicToJsonStr(dict)
            response.appendBody(string: tee)
        }
        
        guard let jsonStr = request.postBodyString else{
            dict = self.getStatus(.noData, response: response)
            return
        }
        print(jsonStr)
        
        if let dic = Funcs.jsonToDic(jsonStr: jsonStr){
            dict = self.getStatus(.ok, response: response)
            
            print(dic)
        }else{
            dict = self.getStatus(.postFailed, response: response)
        }
    }
    
    
    //根据状态 返回状态数据
    class func getStatus(_ resultStatus: ReceiveDataResultType, response: HTTPResponse) -> NSMutableDictionary{
        let dict = NSMutableDictionary()
        switch resultStatus {
        case .ok:
            Funcs.setFailMessage(response, dict: dict, str: "ok")
            
        case .noData:
            Funcs.setFailMessage(response, dict: dict, str: "没有上传数据")
            
        case .postFailed:
            Funcs.setFailMessage(response, dict: dict, str: "上传失败")
        }
        return dict
    }

}
