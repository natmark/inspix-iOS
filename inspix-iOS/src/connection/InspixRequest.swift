//
//  InspixRequest.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/14.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation
import APIKit
protocol InspixRequest: Request {
    
}

extension InspixRequest {
    var baseURL: URL {
        return URL(string: "https://theoldmoon0602.tk/inspix")!
    }
    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        guard (200..<300).contains(urlResponse.statusCode) else {
            throw InspixError(object: object)
        }
        return object
    }
}

// 話を単純にするために422の`errors`は省略。
struct InspixError: Error {
    let message: String
    
    init(object: Any) {
        let dictionary = object as? [String: Any]
        message = (dictionary?["error"] as? Array)?.first ?? "Unknown error occurred"
    }
}
