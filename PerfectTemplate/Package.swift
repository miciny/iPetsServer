//
//  Package.swift
//  PerfectTemplate
//
//  Created by Kyle Jessup on 4/20/16.
//	Copyright (C) 2016 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PackageDescription

let package = Package(
	name: "PerfectTemplate",
	targets: [],
	dependencies: [
		.Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2),
		
		.Package(url: "https://github.com/Swift-AI/NeuralNet.git", majorVersion: 0, minor: 3),
		
        .Package(url: "https://github.com/PerfectlySoft/Perfect-MySQL.git", majorVersion: 2, minor: 0),
        
        .Package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", versions: Version(1,0,0)..<Version(3, .max, .max)),
        
        .Package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", majorVersion: 0),
        
        .Package(url: "https://github.com/PerfectlySoft/Perfect-Session.git", majorVersion: 1),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-Session-MySQL.git", majorVersion: 1),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-Mustache.git", majorVersion:2),
        .Package(url: "https://github.com/stormpath/Turnstile.git", majorVersion: 1),
        .Package(url: "https://github.com/stormpath/Turnstile-Perfect.git", majorVersion: 1),
        
        .Package(url: "https://github.com/PerfectlySoft/Perfect-Logger.git", majorVersion: 1),
        .Package(url: "https://github.com/iamjono/SwiftRandom.git", majorVersion: 0)
    ]
)


//.Package(url: "https://github.com/PerfectlySoft/Perfect-RequestLogger.git", majorVersion: 0) 有问题，手动添加




