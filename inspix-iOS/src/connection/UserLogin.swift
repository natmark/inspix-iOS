//
//  UserLogin.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/14.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation
import APIKit

struct PostUserLoginRequest : InspixRequest {
    let userId : Int
    let password : String
    
    typealias Response = Login
    
    var method: HTTPMethod {
        return .post
    }
    var parameters: Any?{
        return [
            "id": userId,
            "password": password
        ]
        
    }
    var path: String {
        return "/login"
    }
    
    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        guard (200..<300).contains(urlResponse.statusCode) else {
            throw InspixError(object: object)
        }
        
        let storage = HTTPCookieStorage.shared
        // Cookieリセット
        for cookie in storage.cookies! {
            storage.deleteCookie(cookie)
        }
        let cookies = HTTPCookie.cookies(withResponseHeaderFields: urlResponse.allHeaderFields as! [String : String], for: urlResponse.url!)
        HTTPCookieStorage.shared.setCookies(cookies, for: urlResponse.url, mainDocumentURL: nil)
        
        print(cookies)
        
        return object
    }
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        print(urlResponse.allHeaderFields)
        print(object)
        guard let dictionary = object as? [String: AnyObject],
            let login = Login(dictionary: dictionary) else {
                throw ResponseError.unexpectedObject(object)
        }
        return login
    }
}
struct Login {
    let result: Bool
    init?(dictionary: [String: AnyObject]) {
        guard let result = (dictionary["data"]?["result"] as? NSNumber) else {
            self.result = false
            return nil
        }
        self.result = result.boolValue
    }
}
