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
}
