//
//  HTTPRequest+PerfectAuth.swift
//  PerfectTemplate
//
//  Created by maocaiyuan on 2017/8/23.
//
//

import PerfectHTTP
import PerfectNet

extension HTTPRequest {
    var scheme: String {
        if let scheme = header(.xForwardedProto) {
            return scheme
        }
        if let netssl = self.connection as? NetTCPSSL, netssl.usingSSL {
            return "https"
        }
        return "http"
    }
    var host: String {
        return self.header(.host) ?? self.serverAddress.host
    }
    var baseURL: String {
        return "\(scheme)://\(self.host)"
    }
}
