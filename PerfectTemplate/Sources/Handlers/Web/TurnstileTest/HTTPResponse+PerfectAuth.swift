//
//  HTTPResponse+PerfectAuth.swift
//  PerfectTemplate
//
//  Created by maocaiyuan on 2017/8/23.
//
//

import PerfectHTTP
import PerfectMustache

extension HTTPResponse {
    func render(template: String, context: [String: Any] = [String: Any]()) {
        mustacheRequest(request: self.request, response: self, handler: MustacheHandler(context: context), templatePath: request.documentRoot + "/views/\(template).mustache")
    }
    
    func redirect(path: String) {
        self.status = .found
        self.addHeader(.location, value: path)
        self.completed()
    }
}
