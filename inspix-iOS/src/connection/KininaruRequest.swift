//
//  KininaruRequest.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/17.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation
import APIKit

import APIKit
import Decodable
struct PutKininaruRequest : InspixRequest {
    
    let inspirationId : Int
    
    typealias Response = KininaruResponse
    
    var method: HTTPMethod {
        return .put
    }
    var parameters: Any?{
        return [
            "inspiration_id": inspirationId
        ]
        
    }
    var path: String {
        return "/kininaru"
    }
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> KininaruResponse {
        return try KininaruResponse.decode(object)
    }
}
struct DeleteKininaruRequest : InspixRequest {
    let inspirationId : Int
    
    typealias Response = KininaruResponse
    
    var method: HTTPMethod {
        return .delete
    }
    var parameters: Any?{
        return [
            "inspiration_id": inspirationId
        ]
        
    }
    var path: String {
        return "/kininaru"
    }
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> KininaruResponse {
        return try KininaruResponse.decode(object)
    }

}
struct KininaruResponse: Decodable {
    static func decode(_ json: Any) throws -> KininaruResponse {
        return KininaruResponse(
        )
    }
}
