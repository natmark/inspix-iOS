//
//  APIResponse.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/16.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation
import Decodable

struct APIResponse<T: Decodable> {
    let data: T?
    let error : [String]
}

extension APIResponse: Decodable{
    public static func decode(_ json: Any) throws -> APIResponse<T> {
        return try APIResponse(
            data: try? json => "data",
            error: json => "error"
        )
    }
}
