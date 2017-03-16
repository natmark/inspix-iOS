//
//  UserRegist.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/14.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation
import APIKit
import Decodable
struct PostUserRegistRequest : InspixRequest {

    let userName : String
    let password : String
    
    typealias Response = UserResponse

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
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> UserResponse {
        return try UserResponse.decode(object)
    }
}
struct UserResponse: Decodable {
    let id: Int
    static func decode(_ json: Any) throws -> UserResponse {
        return try UserResponse(
            id: json => "data" => "id"
        )
    }
}
