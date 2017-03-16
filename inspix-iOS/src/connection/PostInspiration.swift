//
//  PostInspiration.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/16.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation
import APIKit

struct PostInspirationRequest : InspixRequest {
    typealias Response = PostInspirationResponse

    let baseImageUrl : String
    let backgroundImageUrl : String
    let compositedImageUrl : String
    let capturedTime : Int
    let longitude : Float
    let latitude : Float
    let caption : String
    let title : String
    
    var method: HTTPMethod {
        return .post
    }
    var parameters: Any?{
        return [
            "base_image_url": baseImageUrl,
            "background_image_url": backgroundImageUrl,
            "composited_image_url": compositedImageUrl,
            "captured_time" : capturedTime,
            "longitude" : longitude,
            "latitude" : latitude,
            "caption" : caption,
            "title" : title
        ]
        
    }
    var path: String {
        return "/postInspiration"
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let dictionary = object as? [String: AnyObject],
            let response = PostInspirationResponse(dictionary: dictionary) else {
                throw ResponseError.unexpectedObject(object)
        }
        return response
    }
}
struct PostInspirationResponse{
    init?(dictionary: [String: AnyObject]) {
    }
}
