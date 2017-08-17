//
//  GetMD5Handler.swift
//  PerfectTemplate
//
//  Created by maocaiyuan on 2017/8/17.
//
//

import Foundation
import CryptoSwift
import PerfectHTTP

class GetMD5Handler{
    
    class func getMD5(_ request: HTTPRequest, response: HTTPResponse){
        
        response.addJsonAndUTF8Header()
        //检查参数
        var dict = NSMutableDictionary()  //返回的数据
        
        defer {
            let tee = Funcs.dicToJsonStr(dict)
            response.appendBody(string: tee)
        }
        
        dict = CheckParameter.checkParas(request, response: response, acceptPara: ["username", "pw"])
        guard dict.count == 0 else {
            return
        }
        
        let username = request.params(named: "username")[0]
        let pw = request.params(named: "pw")[0]
        
        let str = username+"_"+pw
        let md5 = str.md5()
    
        SetResponseDic.setOKMessage(response, dict: dict, message: md5)
    }
    
}
