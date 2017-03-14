//
//  UserConfigManager.swift
//  inspix-iOS
//
//  Created by AtsuyaSato on 2017/03/14.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation
class UserConfigManager {
    static let KEY_BYTE = [UInt8]("HE929MPYRDHCEMMI4T7HEUU3PUZ2FV5E".utf8)

    static let sharedManager = UserConfigManager()
    
    let userDefaults = UserDefaults.standard
    static let USER_ID_KEY = "user_id"
    static let USER_PASS_KEY = "password"
    
    func saveUserId(_ userId: Int) {
        self.userDefaults.set(userId, forKey: UserConfigManager.USER_ID_KEY)
    }
    func saveUserPassword(_ userPassword: String) {
        let encUserPassword = try! userPassword.aesEncrypt(key: UserConfigManager.KEY_BYTE)
        self.userDefaults.set(encUserPassword, forKey: UserConfigManager.USER_PASS_KEY)
    }
    func getUserAuth() -> (userId: Int?, userPassword: String?) {
        guard let _ = userDefaults.object(forKey: UserConfigManager.USER_ID_KEY) else {
            return (nil,nil)
        }
        
        let userId = userDefaults.integer(forKey: UserConfigManager.USER_ID_KEY)
        let encUserPassword = userDefaults.string(forKey: UserConfigManager.USER_PASS_KEY)
        var userPassword: String? = nil
        if let encUserPassword = encUserPassword {
            do {
                userPassword = try encUserPassword.aesDecrypt(key: UserConfigManager.KEY_BYTE)
            } catch {
                print("decrypt error!")
                userPassword = nil
            }
        }
        return (userId, userPassword)
    }

}
