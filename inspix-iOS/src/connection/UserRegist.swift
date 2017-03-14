//
//  UserRegist.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/14.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation
import APIKit

struct PostUserRegistRequest : InspixRequest {
    let userName : String
    let password : String
    
    typealias Response = User
    
    var method: HTTPMethod {
        return .post
    }
    var parameters: Any?{
        return [
            "name": userName,
            "password": password
        ]
 
    }
    var path: String {
        return "/register"
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let dictionary = object as? [String: AnyObject],
            let user = User(dictionary: dictionary) else {
                throw ResponseError.unexpectedObject(object)
        }
        
        return user
    }
}
struct User {
    let id: Int
    
    init?(dictionary: [String: AnyObject]) {
        guard let id = dictionary["data"]?["id"] as? Int else {
            return nil
        }
        
        self.id = id
    }
}
