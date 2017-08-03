//
//  Funcs.swift
//  PerfectTemplate
//
//  Created by maocaiyuan on 2017/7/6.
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



class Funcs: NSObject {
    
    
//===================================功能=======================
    //获取路径
    class func getDeskPath() -> AnyObject{
        let deskPaths = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true)
        let deskPath = deskPaths[0]
        return deskPath as AnyObject
    }
    
    
    
//===================================功能=======================
    //字典转为json格式的字符串
    class func dicToJsonStr(_ dic: NSMutableDictionary) -> String{
        let dataArray = dic
        var str = String()
        
        do {
            let dataFinal = try JSONSerialization.data(withJSONObject: dataArray, options:JSONSerialization.WritingOptions(rawValue:0))
            let string = NSString(data: dataFinal, encoding: String.Encoding.utf8.rawValue)
            str = string! as String
            
        }catch {
            
        }
        return str
    }
    
    class func jsonToDic(jsonStr: String) -> NSDictionary?{
        let jsonData = jsonStr.data(using: String.Encoding.utf8)
        do {
            let dic = try JSONSerialization.jsonObject(with: jsonData!, options: .mutableContainers)
            return dic as? NSDictionary
            
        }catch{
            print("json数据转为字典数据失败！")
            print(error)
            return nil
        }
    }
    
    //字符串转成json
    class func strToJson(_ str: String) -> AnyObject{
        
        let data = str.data(using: String.Encoding.utf8)
        var json : AnyObject = "" as AnyObject
        
        do {
            let deserialized = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            json = deserialized as AnyObject
            
        }catch let e as NSError{
            print(e)
        }
        
        return json
    }
    
    //返回一个查询语句的where
    class func getQuery_And(_ request: HTTPRequest) -> String{
        
        let paras = request.params()
        let parasCount = paras.count
        var str = ""
        for i in 0 ..< parasCount{
            if i > 0{
                str += " AND " + paras[i].0 + "=" + "\"\(paras[i].1)\""
            }else{
                str += paras[i].0 + "=" + "\"\(paras[i].1)\""
            }
        }
        return str
    }
    
    
    class func getQuery_Or(data: NSMutableArray, fieldName: String) -> String{
        var str = ""
        
        for i in 0 ..< data.count{
            let d = data[i] as! String
            str += fieldName + "=" + d
            
            if i != data.count-1{
                str += " or "
            }
        }
        
        return str
    }
    
    //字符串转为时间
    class func stringToDate(_ string: String, format: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        // String to Date
        return dateFormatter.date(from: string)!
    }
    

//===================================成功的数据 或者是提示=======================
    //正常
    class func setOKResponse(_ response: HTTPResponse, dict: NSMutableDictionary, resultArray: NSMutableArray?){
        
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
    class func setOKMessage(_ response: HTTPResponse, dict: NSMutableDictionary, str: String){
        
        response.status = HTTPResponseStatus.ok
        dict.setValue("true", forKey: "success")
        dict.setValue(HTTPResponseStatus.ok.description, forKey: "code")
        dict.setValue(str, forKey: "message")
    }
    
    //失败
    class func setFailMessage(_ response: HTTPResponse, dict: NSMutableDictionary, str: String){
        
        response.status = HTTPResponseStatus.ok
        dict.setValue("false", forKey: "success")
        dict.setValue(HTTPResponseStatus.badRequest.description, forKey: "code")
        dict.setValue(str, forKey: "message")
    }
    
    
    
//===================================错误=======================
    //数据库连接出错，设置
    class func setDBErrorResponse(_ response: HTTPResponse, dict: NSMutableDictionary){
        
        response.status = HTTPResponseStatus.serviceUnavailable
        dict.setValue("false", forKey: "success")
        dict.setValue(HTTPResponseStatus.serviceUnavailable.description, forKey: "code")
        dict.setValue("连接数据库出错", forKey: "message")
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
    
//===================================检查=======================
    
    //检查参数
    class func checkParas(_ request: HTTPRequest, response: HTTPResponse, acceptPara: [String]) -> NSMutableDictionary{
        var dataArray = NSMutableDictionary()
        
        let pCount = request.params().count
        
        
        defer {
            if dataArray.count != 0{
                Log.info(message: "Failure : 参数错误: " + String(dataArray.value(forKey: "code") as! Int))
                Log.info(message: "Failure : \(request.queryParams)")
            }
        }
        
        //如果参数数量错误
        if pCount != acceptPara.count{
            dataArray = Funcs.setParaErrorData(ParaErrorType.lessPara, response: response)
            return dataArray
        }
        
        for para in request.params(){
            //如果参数有错误 返回
            if !acceptPara.contains(para.0){
                dataArray = Funcs.setParaErrorData(ParaErrorType.unacceptablePara, response: response)
                return dataArray
            }
            
            //参数为空，返回
            if para.1 == ""{
                dataArray = Funcs.setParaErrorData(ParaErrorType.badPara, response: response)
                return dataArray
            }
        }
        
        return dataArray
    }
}
