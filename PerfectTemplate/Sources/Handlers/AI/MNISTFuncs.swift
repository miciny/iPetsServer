//
//  MNISTConstant.swift
//  PerfectTemplate
//
//  Created by maocaiyuan on 2017/8/2.
//
//

import Foundation
import PerfectLib
import PerfectHTTP

public enum MNISTErrorType: Int{
    
    case serviceUnavailable = 400
    case serviceError = 401
    case serviceInProgress = 402
    
    public var description: String {
        switch self {
        case .serviceUnavailable	: return "服务不可用，开关关闭"
        case .serviceError          : return "服务错误，读取数据失败"
        case .serviceInProgress     : return "服务繁忙"
        }
    }
    
}

public class MNISTConstans{
    
    class var mnistDataTable: String{
        get {
            return "MNISTDB"
        }
    }
    
    
    class func setMNISTError(_ response: HTTPResponse, error: MNISTErrorType) -> NSMutableDictionary{
        let dict = NSMutableDictionary()
        
        response.status = HTTPResponseStatus.serviceUnavailable
        dict.setValue("false", forKey: "success")
        dict.setValue(error.rawValue, forKey: "code")
        dict.setValue(error.description, forKey: "message")
        
        return dict
    }
    
    
    class func getSingleQuery(i: Int, j: Int, data: [[[Float]]], label: String) -> String{
        var query = label+"=NULL"
        
        let labels = (j<data.count&&i<data[j].count) ? data[j][i] : []
        if labels.count > 0{
            let labelsStr = labels.description.components(separatedBy: "[")[1].components(separatedBy: "]")[0]
            query = label+"=\"\(labelsStr)\""
        }
        
        return query
    }
}
