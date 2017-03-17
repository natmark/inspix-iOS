//
//  User.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/16.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation
import Decodable

struct User:Decodable {
    let id: Int
    let name: String
    let follow: Int?
    let follower: Int?
    let following: Bool?
    let thumbnailImage : String
    
    static func decode(_ json: Any) throws -> User {
        return try User(
            id: json => "id",
            name: json => "name",
            follow: json =>? "follow",
            follower: json =>? "follower",
            following: json =>? "following",
            thumbnailImage: json => "thumbnail_image"
        )
    }
}
