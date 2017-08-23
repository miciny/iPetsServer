//
//  TurnstileAuth.swift
//  PerfectTemplate
//
//  Created by maocaiyuan on 2017/8/23.
//
//

import PerfectLib
import PerfectHTTP

import PerfectMustache

import TurnstilePerfect
import Turnstile
import TurnstileCrypto
import TurnstileWeb

public class TurnstileAuthHandlers {
    
    open static func indexHandler(request: HTTPRequest, _ response: HTTPResponse) {
        
        let context: [String : Any] = ["account": (request.user.authDetails?.account as? UserAccount)?.dict ?? "no account",
                                       "baseURL": request.baseURL,
                                       "authenticated": request.user.authenticated]
        
        response.render(template: "index", context: context)
        
        response.completed()
    }
    
    
    /* =================================================================================================================
     login get
     ================================================================================================================= */
    open static func loginHandlerGet(request: HTTPRequest, _ response: HTTPResponse) {
        response.render(template: "login")
        response.completed()
        
    }
    
    
    /* =================================================================================================================
     login post
     ================================================================================================================= */
    open static func loginHandlerPost(request: HTTPRequest, _ response: HTTPResponse) {
        guard let username = request.param(name: "username"),
            let password = request.param(name: "password") else {
                response.render(template: "login", context:  ["flash": "Missing username or password"])
                return
        }
        let credentials = UsernamePassword(username: username, password: password)
        
        do {
            try request.user.login(credentials: credentials, persist: true)
            response.redirect(path: "/")
        } catch {
            response.render(template: "login", context: ["flash": "Invalid Username or Password"])
        }
        
        response.completed()
        
    }
    
    /* =================================================================================================================
     register get
     ================================================================================================================= */
    open static func registerGet(request: HTTPRequest, _ response: HTTPResponse) {
        response.render(template: "register")
        response.completed()
        
    }
    
    /* =================================================================================================================
     register post
     ================================================================================================================= */
    open static func registerPost(request: HTTPRequest, _ response: HTTPResponse) {
        guard let username = request.param(name: "username"),
            let password = request.param(name: "password") else {
                response.render(template: "register", context: ["flash": "Missing username or password"])
                return
        }
        let credentials = UsernamePassword(username: username, password: password)
        
        do {
            try request.user.register(credentials: credentials)
            try request.user.login(credentials: credentials, persist: true)
            response.redirect(path: "/web/auth")
        } catch let e as TurnstileError {
            response.render(template: "register", context: ["flash": e.description])
        } catch {
            response.render(template: "register", context: ["flash": "An unknown error occurred."])
        }
        
        response.completed()
    }
    
    
    
    
    /* =================================================================================================================
     api
     ================================================================================================================= */
    open static func getMyInfo(request: HTTPRequest, _ response: HTTPResponse){
        guard let account = request.user.authDetails?.account as? UserAccount else {
            response.status = .unauthorized
            response.appendBody(string: "401 Unauthorized")
            response.completed()
            return
        }
        response.appendBody(string: account.json)
    }
    
    
    open static func logout(request: HTTPRequest, _ response: HTTPResponse){
        request.user.logout()
        
        response.redirect(path: "/web/auth")
    }
    
    
}
