//
//  Inspirations.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/16.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation
import Decodable

struct Inspiration:Decodable {
    let id : Int
    let baseImageUrl: String
    let backgroundImageUrl: String
    let compositedImageUrl: String
    let weather: String?
    let temperature: Double?
    let capturedTime: Int
    let kininaruCount: Int
    let kininaruUsers: [User]
    let longitude : Double
    let latitude : Double
    let caption : String
    let author : User
    let kininatteru : Bool
    let nokkarare: [Nokkari]
    let title: String
    
    static func decode(_ json: Any) throws -> Inspiration {
        return try Inspiration(
            id: json => "id",
            baseImageUrl: json => "base_image_url",
            backgroundImageUrl: json => "background_image_url",
            compositedImageUrl: json => "composited_image_url",
            weather: json =>? "weather",
            temperature: json =>? "temperature",
            capturedTime: json => "captured_time",
            kininaruCount: json => "kininaru_count",
            kininaruUsers: json => "kininaru_users",
            longitude: json => "longitude",
            latitude: json => "latitude",
            caption: json => "caption",
            author: json => "author",
            kininatteru: json => "kininatteru",
            nokkarare: json => "nokkarare",
            title: json => "title"
        )
    }
}
