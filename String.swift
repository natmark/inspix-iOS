//
//  String.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/14.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation
import CryptoSwift

extension String {
    static let IV_BYTE:[UInt8] = [26, 105, 188, 243, 182, 29, 141, 15, 184, 195, 33, 44, 150, 171, 164, 118]
    func aesEncrypt(key: Array<UInt8>) throws -> String {
        let plainData = self.data(using: .utf8)
        let encArray = try AES(key: key, iv: String.IV_BYTE, blockMode:.CBC, padding: PKCS7()).encrypt(plainData!.bytes)
        let encData = NSData(bytes: encArray, length: Int(encArray.count))
        let base64String: String = encData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0));
        let result = String(base64String)
        return result!
    }
    
    func aesDecrypt(key: Array<UInt8>) throws -> String {
        let encData = NSData(base64Encoded: self, options: NSData.Base64DecodingOptions(rawValue: 0))
        let dec = try AES(key: key, iv: String.IV_BYTE, blockMode:.CBC, padding: PKCS7()).decrypt([UInt8](encData! as Data))
        let decData = NSData(bytes: dec, length: Int(dec.count))
        let result = NSString(data: decData as Data, encoding: String.Encoding.utf8.rawValue)
        return String(result!)
    }
}
