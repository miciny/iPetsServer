//
//  CheckParameter.swift
//  PerfectTemplate
//
//  Created by maocaiyuan on 2017/8/4.
//
//

import Foundation
import PerfectHTTP
import PerfectLib

public enum ParaErrorType: Int{
    case unacceptablePara = 302 //参数名错误
    case badPara = 303          //参数值错误，为空
    case lessPara = 304         //参数数量错误
    
    public var description: String {
        switch self {
        case .unacceptablePara	: return "参数错误"
        case .badPara           : return "参数错误"
        case .lessPara          : return "参数错误"
        }
    }
}


class CheckParameter: NSObject{
    
    //检查参数 , 必须完全符合 acceptPara， dataArray不为空就是参数错误
    class func checkParas(_ request: HTTPRequest, response: HTTPResponse, acceptPara: [String]) -> NSMutableDictionary{
        var dataArray = NSMutableDictionary()
        
        let pCount = request.params().count
        
        defer {
            if dataArray.count != 0{
                logger("Failure : 参数错误: " + String(dataArray.value(forKey: "code") as! Int))
                logger("Failure : \(request.queryParams)")
            }
        }
        
        //如果参数数量错误
        if pCount != acceptPara.count{
            dataArray = self.setParaErrorData(ParaErrorType.lessPara, response: response)
            return dataArray
        }
        
        for para in request.params(){
            //如果参数有错误 返回
            if !acceptPara.contains(para.0){
                dataArray = self.setParaErrorData(ParaErrorType.unacceptablePara, response: response)
                return dataArray
            }
            
            //参数为空，返回
            if para.1 == ""{
                dataArray = self.setParaErrorData(ParaErrorType.badPara, response: response)
                return dataArray
            }
        }
        return dataArray
    }
    
    //参数错误
    class func setParaErrorData(_ error: ParaErrorType, response: HTTPResponse) -> NSMutableDictionary{
        
        let dict = NSMutableDictionary()
        
        dict.setValue("false", forKey: "success")
        dict.setValue(error.rawValue, forKey: "code")
        dict.setValue(error.description, forKey: "message")
        
        response.status = HTTPResponseStatus.badRequest
        return dict
    }

}
