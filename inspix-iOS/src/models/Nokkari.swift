//
//  Nokkari.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/16.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation
import Decodable

struct Nokkari:Decodable {
    let id: Int
    let author: User
    let kininaruCount: Int
    let kininaruUsers: [User]
    let kininatteru : Bool
    let compositedImageUrl : String?
    let comment : String?
    
    static func decode(_ json: Any) throws -> Nokkari {
        return try Nokkari(
            id: json => "id",
            author: json => "author",
            kininaruCount: json => "kininaru_count",
            kininaruUsers: json => "kininaru_users",
            kininatteru: json => "kininatteru",
            compositedImageUrl: json =>? "composited_image_url",
            comment: json =>? "comment"
        )
    }
}
