//
//  PathManager.swift
//  PerfectTemplate
//
//  Created by maocaiyuan on 2017/8/4.
//
//

import Foundation

class SavePathManager: NSObject {
    
    //获取桌面路径
    class func getDeskPath() -> AnyObject{
        let deskPaths = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true)
        let deskPath = deskPaths[0]
        return deskPath as AnyObject
    }
}
