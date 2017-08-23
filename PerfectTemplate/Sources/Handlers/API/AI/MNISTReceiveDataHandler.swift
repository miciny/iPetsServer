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
import SwiftyJSON


class MNISTReceiveDataHandler{
    
    
    fileprivate static let labelEncodings: [[Float]] = [
        [1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 1, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 1, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 1, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 1, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 1, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 1, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
    ]
    
    class func receiveData(_ request: HTTPRequest, response: HTTPResponse){
        
        response.addJsonAndUTF8Header()
        
        var dict = NSMutableDictionary()
        
        defer {
            let tee = Funcs.dicToJsonStr(dict)
            response.appendBody(string: tee)
        }
        
        guard let jsonStr = request.postBodyString else{
            dict = SetResponseDic.getStatus(.noData, response: response)
            return
        }
        
        if let dicStr = Funcs.strToJson(jsonStr){
            let json = JSON(dicStr)
            let data = json["data"]
            if let train_images = data["train_images"].string{
                if let train_labels = data["train_labels"].int{
                    if self.setDataToDB(train_images, train_labels: train_labels, response: response, dict: dict){
                        
                        //插入数据
                        dict = SetResponseDic.getStatus(.ok, response: response)
                        
                        
                    }else{
                        dict = SetResponseDic.getStatus(.postFailed, response: response)
                    }
                }else{
                    dict = SetResponseDic.getStatus(.postFailed, response: response)
                }
            }else{
                dict = SetResponseDic.getStatus(.postFailed, response: response)
            }
            
        }else{
            dict = SetResponseDic.getStatus(.postFailed, response: response)
        }
    }
    
    
    class func setDataToDB(_ train_images: String, train_labels: Int, response: HTTPResponse, dict: NSMutableDictionary) -> Bool{
        
        let iPetsConnector = iPetsDBConnector(dbName: iPetsDBConnectConstans.schema)
        //方法执行完后，需要调用
        defer {
            iPetsConnector.closeConnect()
        }
        
        let train_label = labelEncodings[train_labels]
        //数据库连接成功
        logger("导入数据...")
        if iPetsConnector.success{    // 确保执行的语句正确
            
            let train_imagesStr = train_images.components(separatedBy: "[")[1].components(separatedBy: "]")[0]
            let train_imagesQuery = "train_images=\"\(train_imagesStr)\""
            let train_labelsStr = train_label.description.components(separatedBy: "[")[1].components(separatedBy: "]")[0]
            let train_labelsQuery = "train_labels=\"\(train_labelsStr)\""
            
            let validation_imagesQuery = "validation_images=NULL"
            let validation_labelsQuery = "validation_labels=NULL"
            
            
            let statement = "INSERT INTO \(MNISTConstans.mnistDataTable) SET \(train_imagesQuery), \(train_labelsQuery), \(validation_imagesQuery), \(validation_labelsQuery)"
            
            guard iPetsConnector.excuse(query: statement) else {
                SetResponseDic.setDBErrorResponse(response, dict: dict)
                return false
            }
        }
        
        return true
    }

}
