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

public class MNISTTrain{
    
    // ADD CUSTOM PATHS HERE ---------------------------------------------------
    
    /// Path to MNIST dataset directory.
    static let mnistDataDir = "/Users/miciny/ToGitHub/iPetsServer/PerfectTemplate/MNIST"
    
    /// Full filepath for trained network output file.
    static let outputFilepath = "/Users/miciny/ToGitHub/iPetsServer/PerfectTemplate/MNIST/neuralnet-mnist-trained"
    
    // -------------------------------------------------------------------------
    
    
    class func startTraining(){
        
        do {
            // 读取MNIST
            Log.info(message: "读取数据...")
            let manager = try MNISTManager(directory: mnistDataDir,
                                           pixelRange: (min: 0, max: 1), // White pixels 0, black pixels 1
                batchSize: 100)
            
            // 设置训练的dataset
            let dataset = try NeuralNet.Dataset(trainInputs: manager.trainImages, trainLabels: manager.trainLabels,
                                                validationInputs: manager.validationImages, validationLabels: manager.validationLabels)
            
            // 定义人工神经网络的层级数量
            Log.info(message: "创建神经网络...")
            let structure = try NeuralNet.Structure(nodes: [784, 500, 10],
                                                    hiddenActivation: .rectifiedLinear, outputActivation: .softmax,
                                                    batchSize: 100, learningRate: 0.8, momentum: 0.9)
            let nn = try NeuralNet(structure: structure)
          
            Log.info(message: "----------------- 开始训练 -----------------")
            let (_, error) = try nn.train(dataset, maxEpochs: 50, errorThreshold: 0.02, errorFunction: .percentage) { (epoch, err) -> Bool in
                
                // 记录过程
                let percCorrect = (1 - err) * 100
                let percError = err * 100
                Log.info(message: "第几代:\t\t\(epoch)")
                Log.info(message: "准确度:\t\t\(percCorrect)%")
                Log.info(message: "错误率:\t\t\(percError)%")
                
                // 衰减学习的速率和动量
                nn.learningRate *= 0.97
                nn.momentumFactor *= 0.97
                
                //允许继续训练
                return true
            }
            
            // 结束
            try nn.save(to: URL(fileURLWithPath: outputFilepath))
            Log.info(message: "--------------------------- 结束 ---------------------------")
            Log.info(message: "准确度: \((1 - error) * 100)%")
            Log.info(message: "训练结果保存在: \(outputFilepath)")
            
        } catch {
            print(error)
        }
        

    }
    
}
