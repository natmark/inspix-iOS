//
//  FollowTimeLine.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/17.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation
import Foundation
import APIKit
import Decodable

struct GetPickupTimeLineRequest : InspixRequest {
    let pager : Int
    
    typealias Response = TimeLineResponse
    
    var method: HTTPMethod {
        return .get
    }
    var parameters: Any?{
        return [
            "page": pager
        ]
        
    }
    var path: String {
        return "/pickupTimeline"
    }
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> TimeLineResponse {
        return try TimeLineResponse.decode(object)
    }
}


