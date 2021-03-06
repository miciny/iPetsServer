//
//  WebHanddlers.swift
//  PerfectTemplate
//
//  Created by maocaiyuan on 2017/8/18.
//
//

import PerfectLib
import PerfectHTTP
import PerfectSession
import TurnstileCrypto

public class CORSWebHandlers {
    /* =================================================================================================================
     Index
     需要客户端传token 加入到 header
     (request.session?._state ?? "no token")  //通过状态判断是不是新对话，new的话就说吗对话过期，resume表示没过期
     ================================================================================================================= */
    
    open static func indexHandlerGet(request: HTTPRequest, _ response: HTTPResponse) {
        
        let rand = URandom()
        
        request.session?.data[rand.secureToken] = rand.secureToken
        //		print(request.session.data)
        var dump = ""
        do {
            dump = try request.session!.data.jsonEncodedString()
        } catch {
            dump = "\(error)"
        }
        var body = "<p>Your Session ID is: <code>\(request.session?.token ?? "no token")</code></p><p>Session data: <code>\(dump)</code></p>"
        body += "<p><a href=\"withcsrf\">CSRF Test Form</a></p>"
        body += "<p><a href=\"nocsrf\">No CSRF Test Form</a></p>"
        
        response.setBody(string: header+body+footer)
        response.completed()
        
        
    }
    
    
    /* =================================================================================================================
     CORS
     ================================================================================================================= */
    open static func CORSHandlerGet(request: HTTPRequest, _ response: HTTPResponse) {
        
        response.addHeader(.contentType, value: "application/json")
        let _ = try? response.setBody(json: ["Success":"CORS Request"])
        response.completed()
        
    }
    
    
    
    /* =================================================================================================================
     formNoCSRF
     ================================================================================================================= */
    open static func formNoCSRF(request: HTTPRequest, _ response: HTTPResponse) {
        
        var body = "<p>Your Session ID is: <code>\(request.session?.token ?? "no token")</code></p><form method=\"POST\" action=\"?\" enctype=\"multipart/form-data\">"
        body += "<p>No CSRF Form</p>"
        body += "<p>NOTE: You should get a failed request because there is no CSRF</p>"
        body += "<p><input type=\"text\" name=\"testing\" value=\"testing123\"></p>"
        body += "<p><input type=\"submit\" name=\"submit\" value=\"submit\"></p>"
        body += "</form>"
        response.setBody(string: header+body+footer)
        response.completed()
        
    }
    
    /* =================================================================================================================
     formWithCSRF
     ================================================================================================================= */
    open static func formWithCSRF(request: HTTPRequest, _ response: HTTPResponse) {
        //print(request.session?._state ?? "no token")  //通过状态判断是不是新对话，new的话就说吗对话过期，resume表示没过期
        
        let t = request.session?.data["csrf"] as? String ?? ""
        let ip = request.session?.ipaddress
        let uid = request.session?.userid
        
        let created = "\(request.session?.created ?? -1)"
        let updated = "\(request.session?.updated ?? -1)"
        let idle = "\(request.session?.idle ?? -1)"
        let useragent = request.session?.useragent
        
        var body = "<p>Your Session ID is: <code>\(request.session?.token ?? "no token")</code></p><form method=\"POST\" action=\"?\" enctype=\"multipart/form-data\">"
        body += "<p>CSRF Form</p>"
        body += "<p><input type=\"text\" name=\"testing\" value=\"testing123\"></p>"
        body += "<p><input type=\"text\" name=\"_csrf\" value=\"\(t)\"></p>"
        body += "<p><input type=\"text\" name=\"ipAddress\" value=\""+ip!+"\"></p>"
        body += "<p><input type=\"text\" name=\"uid\" value=\""+uid!+"\"></p>"
        body += "<p><input type=\"text\" name=\"created\" value=\""+created+"\"></p>"
        body += "<p><input type=\"text\" name=\"updated\" value=\""+updated+"\"></p>"
        body += "<p><input type=\"text\" name=\"idle\" value=\""+idle+"\"></p>"
        body += "<p><input type=\"text\" name=\"useragent\" value=\""+useragent!+"\"></p>"
        body += "<p><input type=\"submit\" name=\"submit\" value=\"submit\"></p>"
        body += "</form>"
        response.setBody(string: header+body+footer)
        response.completed()
        
    }
    
    /* =================================================================================================================
     formReceive
     ================================================================================================================= */
    open static func formReceive(request: HTTPRequest, _ response: HTTPResponse) {
        //		print("in formReceive")
        var body = "<p>Your Session ID is: <code>\(request.session?.token ?? "no token")</code></p>"
        body += "<p>CSRF Test response</p>"
        body += "<p>Params: \(request.postParams)</p>"
        response.setBody(string: header+body+footer)
        response.completed()
        
    }
    
    
    

    static var header = "<html><head><link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css\" integrity=\"sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u\" crossorigin=\"anonymous\"><title>Perfect Sessions Demo</title><style>.header,body{padding-bottom:20px}.header,.jumbotron{border-bottom:1px solid #e5e5e5}body{padding-top:20px}.footer,.header,.marketing{padding-right:15px;padding-left:15px}.header h3{margin-top:0;margin-bottom:0;line-height:40px}.footer{padding-top:19px;color:#777;border-top:1px solid #e5e5e5}@media (min-width:768px){.container{max-width:730px}}.container-narrow>hr{margin:30px 0}.jumbotron{text-align:center}.jumbotron .btn{padding:14px 24px;font-size:21px}.marketing{margin:40px 0}.marketing p+h4{margin-top:28px}@media screen and (min-width:768px){.footer,.header,.marketing{padding-right:0;padding-left:0}.header{margin-bottom:30px}.jumbotron{border-bottom:0}}</style></head><body><div class=\"container\"><div class=\"header clearfix\"><h3 class=\"text-muted\"><a href=\"/\">Perfect Sessions Demo</a></h3></div>"
    
    static var footer = "</div></body></html>"
}
