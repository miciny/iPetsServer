//
//  MNISTSetDataToDB.swift
//  PerfectTemplate
//
//  Created by maocaiyuan on 2017/8/2.
//
//

import Foundation
import NeuralNet
import PerfectLib
import PerfectHTTP

class MNISTSetDataToDBHandler{
    
    static let mnistDataDir = "/Users/miciny/ToGitHub/iPetsServer/PerfectTemplate/MNIST"
    static let swich = false
    static var dict = NSMutableDictionary()
    
    class func startSetData(_ request: HTTPRequest, response: HTTPResponse){
        
        defer {
            let tee = Funcs.dicToJsonStr(dict)
            response.appendBody(string: tee)
        }
        
        //开关关闭
        guard swich == true else{
            dict = MNISTConstans.setMNISTError(response, error: .serviceUnavailable)
            return
        }
        
        
        do {
            // 读取MNIST
            logger("读取数据...")
            let manager = try MNISTManager(directory: mnistDataDir,
                                           pixelRange: (min: 0, max: 1), // White pixels 0, black pixels 1
                batchSize: 100)
            
            self.setToDB(manager, response: response)
            
        } catch {
            dict = MNISTConstans.setMNISTError(response, error: .serviceError)
            print(error)
        }
    }
    
    
    static func setToDB(_ manager: MNISTManager,response: HTTPResponse){
        
        let iPetsConnector = iPetsDBConnector(dbName: iPetsDBConnectConstans.schema)
        //方法执行完后，需要调用
        defer {
            iPetsConnector.closeConnect()
        }
        
        //数据库连接成功
        logger("导入数据...")
        if iPetsConnector.success{    // 确保执行的语句正确
            for j in 0 ..< manager.trainLabels.count{
                for i in 0 ..< manager.trainLabels[j].count {
                    
                    let train_imagesQuery = MNISTConstans.getSingleQuery(i: i, j: j, data: manager.trainImages, label: "train_images")
                    let train_labelsQuery = MNISTConstans.getSingleQuery(i: i, j: j, data: manager.trainLabels, label: "train_labels")
                    let validation_imagesQuery = MNISTConstans.getSingleQuery(i: i, j: j, data: manager.validationImages, label: "validation_images")
                    let validation_labelsQuery = MNISTConstans.getSingleQuery(i: i, j: j, data: manager.validationLabels, label: "validation_labels")
                    
                    let statement = "INSERT INTO \(MNISTConstans.mnistDataTable) SET \(train_imagesQuery), \(train_labelsQuery), \(validation_imagesQuery), \(validation_labelsQuery)"
                    
                    guard iPetsConnector.excuse(query: statement) else {
                        SetResponseDic.setDBErrorResponse(response, dict: dict)
                        return
                    }
                    
                }
            }
        }
        
        SetResponseDic.setOKResponse(response, dict: dict)
    }
}
