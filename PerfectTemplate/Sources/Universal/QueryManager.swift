//
//  QueryManager.swift
//  PerfectTemplate
//
//  Created by maocaiyuan on 2017/8/4.
//
//

import Foundation
import PerfectHTTP
import PerfectLib

class QueryManager{
    
    //返回一个查询语句的where
    //根据请求中参数自动添加
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
    
    
    //or查询语句，自己拼接
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
}
