//
//  main.swift
//  PerfectTemplate
//
//  Created by Kyle Jessup on 2015-11-05.
//	Copyright (C) 2015 PerfectlySoft, Inc.
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

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectSession
import PerfectSessionMySQL
import TurnstilePerfect

let server = HTTPServer()


//================================================   session 过滤器
SessionConfig.name = "Token"
SessionConfig.idle = 60  //时效期限：整数，单位是秒

// Optional
SessionConfig.cookieDomain = "localhost"
SessionConfig.IPAddressLock = true
SessionConfig.userAgentLock = true
SessionConfig.CSRF.checkState = true

SessionConfig.CORS.enabled = true
SessionConfig.CORS.acceptableHostnames.append("http://www.test-cors.org")
//SessionConfig.CORS.acceptableHostnames.append("*.test-cors.org")
SessionConfig.CORS.maxAge = 60

MySQLSessionConnector.host = iPetsDBConnectConstans.host
MySQLSessionConnector.port = Int(iPetsDBConnectConstans.port)!
MySQLSessionConnector.username = iPetsDBConnectConstans.user
MySQLSessionConnector.password = iPetsDBConnectConstans.password
MySQLSessionConnector.database = iPetsDBConnectConstans.schema
MySQLSessionConnector.table = "session"

//let sessionDriver = SessionMySQLDriver()
//server.setRequestFilters([sessionDriver.requestFilter])
//server.setResponseFilters([sessionDriver.responseFilter])


//================================================   日志记录器
let myLogger = RequestLogger()
// 首先增加高优先级的过滤器
server.setRequestFilters([(myLogger, .high)])
// 最后增加低优先级的过滤器
server.setResponseFilters([(myLogger, .low)])

//================================================   turnstile 过滤器
let accountStore = UserAccountStore()
let turnstile = TurnstilePerfect(sessionManager: ExampleSessionManager(accountStore: accountStore), realm: ExampleRealm(accountStore: accountStore))
var webroot: String
webroot = "/" + #file.characters.split(separator: "/").map(String.init).dropLast(3).joined(separator: "/")
webroot += "/WebRootSources"
server.documentRoot = webroot

server.setRequestFilters([turnstile.requestFilter])
server.setResponseFilters([turnstile.responseFilter])

//================================================   route
let apiRoute = iPetsRoutes.makeAPIRoutes()
let webRoute = iPetsRoutes.makeWebRoutes()
server.addRoutes(apiRoute)
server.addRoutes(webRoute)
server.serverPort = 8181

do {
    try  server.start()
} catch {
    fatalError("\(error)") // fatal error launching one of the servers
}


