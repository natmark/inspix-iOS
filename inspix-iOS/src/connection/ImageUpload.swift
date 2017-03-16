//
//  imageUpload.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/16.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation
import APIKit

struct PutImageUploadRequest : InspixRequest {
    let bin : String
    let ext : String
    
    typealias Response = ImageUploadResponse
    
    var method: HTTPMethod {
        return .put
    }
    var parameters: Any?{
        return [
            "bin": bin,
            "ext": ext
        ]
        
    }
    var path: String {
        return "/imageUpload"
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let dictionary = object as? [String: AnyObject],
            let response = ImageUploadResponse(dictionary: dictionary) else {
                throw ResponseError.unexpectedObject(object)
        }
        
        return response
    }
}
struct ImageUploadResponse {
    let fileUrl: String
    
    init?(dictionary: [String: AnyObject]) {
        guard let fileUrl = dictionary["data"]?["file_url"] as? String else {
            return nil
        }
        
        self.fileUrl = fileUrl
    }
}
