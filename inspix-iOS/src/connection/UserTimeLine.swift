//
//  GetUserTimeLine.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/16.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation
import APIKit
import Decodable

struct GetUserTimeLineRequest : InspixRequest {
    let userId : String
    let pager : Int
    
    typealias Response = TimeLineResponse
    
    var method: HTTPMethod {
        return .get
    }
    var parameters: Any?{
        return [
            "user_id": userId,
            "page": pager
        ]
        
    }
    var path: String {
        return "/userTimeline"
    }
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> UserResponse {
        return try UserResponse.decode(object)
    }
}
struct TimeLineResponse: Decodable {
    let inspirations : [Inspiration]
    
    public static func decode(_ json: Any) throws -> TimeLineResponse {
        return try TimeLineResponse(
            inspirations: json => "data" => "Inspirations"
        )
    }
}

