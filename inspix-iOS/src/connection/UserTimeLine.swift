//
//  GetUserTimeLine.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/16.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation
import APIKit


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
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let dictionary = object as? [String: AnyObject],
            let inspirations = TimeLineResponse(dictionary: dictionary) else {
                throw ResponseError.unexpectedObject(object)
        }
        
        return inspirations
    }
}
struct TimeLineResponse {
    let id: Int
    
    init?(dictionary: [String: AnyObject]) {
        guard let id = dictionary["data"]?["id"] as? Int else {
            return nil
        }
        
        self.id = id
    }
}
