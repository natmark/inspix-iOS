//
//  Util.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/14.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation
class Util {
    //[a-zA-Z0-9]の乱数をStringで返す
    func randomStringWithLength(length: Int) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.characters.count))
            let hoge = base.index(base.startIndex, offsetBy: Int(randomValue))
            print(hoge)
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}
