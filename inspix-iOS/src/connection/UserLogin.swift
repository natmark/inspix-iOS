//
//  UserLogin.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/14.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation
import APIKit
import Decodable

struct PostUserLoginRequest : InspixRequest {
    let userId : Int
    let password : String
    
    typealias Response = LoginResponse
    
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
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> LoginResponse {
        return try LoginResponse.decode(object)
    }
}
struct LoginResponse: Decodable {
    let result: Bool
    static func decode(_ json: Any) throws -> LoginResponse {
        return try LoginResponse(
            result: json => "data" => "result"
        )
    }
}
