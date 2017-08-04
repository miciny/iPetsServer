//
//  MNISTTrain.swift
//  PerfectTemplate
//
//  Created by maocaiyuan on 2017/8/1.
//
//

import Foundation
import NeuralNet
import PerfectLib
import PerfectHTTP

public class MNISTData{
    var trainImages: [[[Float]]]!
    var trainLabels: [[[Float]]]!
    var validationImages: [[[Float]]]!
    var validationLabels: [[[Float]]]!
    
    init() {
        trainImages = [[[Float]]]()
        trainLabels = [[[Float]]]()
        validationImages = [[[Float]]]()
        validationLabels = [[[Float]]]()
    }
}

public class MNISTTrainHandler{
    
    static let mnistDataDir = "/Users/miciny/ToGitHub/iPetsServer/PerfectTemplate/MNIST"
    static let outputFilepath = "/Users/miciny/ToGitHub/iPetsServer/PerfectTemplate/MNIST/neuralnet-mnist-trained"
    
    // -------------------------------------------------------------------------
    static let batchSize: Int = 100
    
    static var training = false
    
    class func startTraining(_ request: HTTPRequest, response: HTTPResponse){
        
        var dict = NSMutableDictionary()
        
        defer {
            let tee = Funcs.dicToJsonStr(dict)
            response.appendBody(string: tee)
            training = false
        }
        
        guard training == false else{
            dict = MNISTConstans.setMNISTError(response, error: .serviceInProgress)
            return
        }
        training = true
        
        if let data = self.getData(response, dict: dict, batchSize: batchSize){
            logger("训练数据： \(data.trainLabels.count)")
            logger("训练数据： \(data.trainLabels[0].count)")
            logger("训练数据： \(data.trainLabels[0][0].count)")
            
            do {
                // 设置训练的dataset
                logger("创建神经网络...")
                let dataset = try NeuralNet.Dataset(trainInputs: data.trainImages, trainLabels: data.trainLabels,
                                                    validationInputs: data.validationImages, validationLabels: data.validationLabels)
                
                // 定义人工神经网络的层级数量
                let structure = try NeuralNet.Structure(nodes: [784, 500, 10],
                                                        hiddenActivation: .rectifiedLinear, outputActivation: .softmax,
                                                        batchSize: batchSize, learningRate: 0.8, momentum: 0.9)
                let nn = try NeuralNet(structure: structure)
                
                logger("----------------- 开始训练 -----------------")
                let (_, error) = try nn.train(dataset, maxEpochs: 50, errorThreshold: 0.02, errorFunction: .percentage) { (epoch, err) -> Bool in
                    
                    // 记录过程
                    let percCorrect = (1 - err) * 100
                    let percError = err * 100
                    logger("第几代:========\(epoch)========")
                    logger("准确度:\t\t\(percCorrect)%")
                    logger("错误率:\t\t\(percError)%")
                    
                    // 衰减学习的速率和动量
                    nn.learningRate *= 0.97
                    nn.momentumFactor *= 0.97
                    
                    //允许继续训练
                    return true
                }
                
                // 结束
                try nn.save(to: URL(fileURLWithPath: outputFilepath))
                logger("--------------------------- 结束 ---------------------------")
                logger("准确度: \((1 - error) * 100)%")
                logger("训练结果保存在: \(outputFilepath)")
                
                SetResponseDic.setOKMessage(response, dict: dict, message: "训练完成")
                
            } catch {
                dict = MNISTConstans.setMNISTError(response, error: .serviceError)
                print(error)
            }
            
        }else{
            dict = MNISTConstans.setMNISTError(response, error: .serviceError)
        }
    }
    
    
    static func getData(_ response: HTTPResponse, dict: NSMutableDictionary, batchSize: Int) -> MNISTData?{
        
        let iPetsConnector = iPetsDBConnector(dbName: iPetsDBConnectConstans.schema)
        //方法执行完后，需要调用
        defer {
            iPetsConnector.closeConnect()
        }
        
        let statement = "SELECT * FROM \(MNISTConstans.mnistDataTable)"
        
        guard iPetsConnector.excuse(query: statement) else {
            SetResponseDic.setDBErrorResponse(response, dict: dict)
            return nil
        }
        
        //获取返回的数据
        logger("开始处理数据...")
        let results = iPetsConnector.mysql.storeResults()!
        let data = MNISTData()
        
        var afa = [[Float]]()
        var afb = [[Float]]()
        var afc = [[Float]]()
        var afd = [[Float]]()
        
        results.forEachRow { (row) in
            
            if let row1 = row[1]{
                afa.append(self.getArrayFromStr(str: row1))
            }
            
            if let row2 = row[2]{
                afb.append(self.getArrayFromStr(str: row2))
            }
            
            if let row3 = row[3]{
                afc.append(self.getArrayFromStr(str: row3))
            }
            
            if let row4 = row[4]{
                afd.append(self.getArrayFromStr(str: row4))
            }
        }
        
        data.trainImages = self.createBatches(afa, size: batchSize)
        afa.removeAll()
        data.trainLabels = self.createBatches(afb, size: batchSize)
        afb.removeAll()
        data.validationImages = self.createBatches(afc, size: batchSize)
        afc.removeAll()
        data.validationLabels = self.createBatches(afd, size: batchSize)
        afd.removeAll()
        
        return data
    }
    
    private static func getArrayFromStr(str: String) -> [Float]{
        let array = str.components(separatedBy: ", ")
        var af = [Float]()
        for a in array{
            af.append(Float(a)!)
        }
        return af
    }
    
    private static func createBatches(_ set: [[Float]], size: Int) -> [[[Float]]] {
        var output = [[[Float]]]()
        let numBatches = set.count / size
        
        for batchIdx in 0..<numBatches {
            var batch = [[Float]]()
            for item in 0..<size {
                let idx = batchIdx * size + item
                batch.append(set[idx])
            }
            output.append(batch)
        }
        return output
    }
    
}
