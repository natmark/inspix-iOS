//
//  String.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/14.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation
import CryptoSwift
import UIKit

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
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = from16.samePosition(in: self),
            let to = to16.samePosition(in: self)
            else { return nil }
        return from ..< to
    }
    func substring(with range: NSRange) -> String {
        return substring(with: self.range(from: range)!)
    }
    static func tagAttributedStr(from simpleText:String) -> NSAttributedString {
        let attrStr = NSMutableAttributedString(string: simpleText)
        //全体のフォントサイズ指定
        attrStr.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 20)], range: NSMakeRange(0, attrStr.length))
        do {
            let regexp = try NSRegularExpression(pattern: "(#[a-zA-Z0-9ぁ-んァ-ヶ一-龠]+?\\s)", options:NSRegularExpression.Options(rawValue: 0))
            let arr:[NSTextCheckingResult] = regexp.matches(in: attrStr.string, options:NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, attrStr.length))
            
            for match in arr {
                var range = match.rangeAt(1)
                //末尾の空白文字の一致を削除
                range.length = range.length - 1
                // let str = attrStr.string.substring(with: range)
                //一致する範囲の色設定
                attrStr.addAttributes([NSForegroundColorAttributeName:UIColor.selectedTintColor()], range: range)
            }
        } catch {
            
        }
        return attrStr
    }
}
