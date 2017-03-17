//
//  NokkariRequest.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/17.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation
import APIKit

import APIKit
import Decodable
struct PostNokkariRequest : InspixRequest {
    
    let baseImageUrl : String
    let compositedImageUrl : String
    let caption : String
    let nokkariFromId : Int
    
    typealias Response = NokkariResponse
    
    var method: HTTPMethod {
        return .post
    }
    var parameters: Any?{
        return [
            "base_image_url": baseImageUrl,
            "composited_image_url": compositedImageUrl,
            "caption" : caption,
            "nokkari_from_id" : nokkariFromId
        ]
        
    }
    var path: String {
        return "/nokkari"
    }
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> NokkariResponse {
        return try NokkariResponse.decode(object)
    }
}
struct NokkariResponse: Decodable {
    static func decode(_ json: Any) throws -> NokkariResponse {
        return NokkariResponse(
        )
    }
}
