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
        guard swich == true else{
            return
        }
        
        defer {
            let tee = Funcs.dicToJsonStr(dict)
            response.appendBody(string: tee)
        }
        
        do {
            // 读取MNIST
            Log.info(message: "读取数据...")
            let manager = try MNISTManager(directory: mnistDataDir,
                                           pixelRange: (min: 0, max: 1), // White pixels 0, black pixels 1
                batchSize: 100)
            
            self.setToDB(manager: manager, request: request, response: response)
            
        } catch {
            print(error)
        }
    }
    
    
    static func setToDB(manager: MNISTManager, request: HTTPRequest, response: HTTPResponse){
        let iPetsConnector = iPetsDBConnector(dbName: iPetsDBConnectConstans.schema)
        //方法执行完后，需要调用
        defer {
            iPetsConnector.closeConnect()
        }
        
        //数据库连接成功
        Log.info(message: "导入数据...")
        if iPetsConnector.success{    // 确保执行的语句正确
            for j in 0 ..< manager.trainLabels.count{
                for i in 0 ..< manager.trainLabels[j].count {
                    
                    var train_imagesQuery = "train_images=NULL"
                    let train_images = (j<manager.trainImages.count&&i<manager.trainImages[j].count) ? manager.trainImages[j][i] : []
                    if train_images.count > 0{
                        let train_imagesStr = train_images.description.components(separatedBy: "[")[1].components(separatedBy: "]")[0]
                        train_imagesQuery = "train_images=\"\(train_imagesStr)\""
                    }
                    
                    
                    var train_labelsQuery = "train_labels=NULL"
                    let train_labels = (j<manager.trainLabels.count&&i<manager.trainLabels[j].count) ? manager.trainLabels[j][i] : []
                    if train_labels.count > 0{
                        let train_labelsStr = train_labels.description.components(separatedBy: "[")[1].components(separatedBy: "]")[0]
                        train_labelsQuery = "train_labels=\"\(train_labelsStr)\""
                    }
                    

                    
                    var validation_imagesQuery = "validation_images=NULL"
                    let validation_images = (j<manager.validationImages.count&&i<manager.validationImages[j].count) ? manager.validationImages[j][i] : []
                    if validation_images.count > 0{
                        let validation_imagesStr = validation_images.description.components(separatedBy: "[")[1].components(separatedBy: "]")[0]
                        validation_imagesQuery = "validation_images=\"\(validation_imagesStr)\""
                    }
                    
                    
                    var validation_labelsQuery = "validation_labels=NULL"
                    let validation_labels = (j<manager.validationLabels.count&&i<manager.validationLabels[j].count) ? manager.validationLabels[j][i] : []
                    if validation_labels.count > 0{
                        let validation_labelsStr = validation_labels.description.components(separatedBy: "[")[1].components(separatedBy: "]")[0]
                        validation_labelsQuery = "validation_labels=\"\(validation_labelsStr)\""
                    }
                    
                   
                    
                    let statement = "INSERT INTO \(MNISTConstans.mnistDataTable) SET \(train_imagesQuery), \(train_labelsQuery), \(validation_imagesQuery), \(validation_labelsQuery)"
                    
                    guard iPetsConnector.excuse(query: statement) else {
                        Funcs.setDBErrorResponse(response, dict: dict)
                        return
                    }
                    
                }
            }
        }
        
        Funcs.setOKResponse(response, dict: dict, resultArray: nil)
    }
    

}
