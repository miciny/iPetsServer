//
//  Funcs.swift
//  PerfectTemplate
//
//  Created by maocaiyuan on 2017/7/6.
//
//

import Foundation
import PerfectLib  //Log

func logger(_ str: String){
    Log.info(message: "\(NSDate()): "+str)
}


class Funcs: NSObject {
    
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
    
    //字符串转成json
    class func strToJson(_ str: String) -> AnyObject?{
        
        let data = str.data(using: String.Encoding.utf8)
        var json : AnyObject = "" as AnyObject
        
        do {
            let deserialized = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            json = deserialized as AnyObject
            
        }catch let e as NSError{
            print("str数据转为json数据失败！")
            print(e)
            return nil
        }
        
        return json
    }
    
    
    //字符串转为时间
    class func stringToDate(_ string: String, format: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        // String to Date
        return dateFormatter.date(from: string)!
    }

}
