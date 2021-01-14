//
//  Security.swift
//  myHSC
//
//  Created by Devansh Kaloti on 2019-10-10.
//  Copyright © 2019 Devansh Kaloti. All rights reserved.
//

import Foundation
import RNCryptor
import SwiftKeychainWrapper

class Security {

    static func encryptMessage(message: String, encryptionKey: String) throws -> String {
        let messageData = message.data(using: .utf8)!
        let cipherData = RNCryptor.encrypt(data: messageData, withPassword: encryptionKey)
        return cipherData.base64EncodedString()
    }
    
    static func decryptMessage(encryptedMessage: String, encryptionKey: String) throws -> String {
        
        let encryptedData = Data.init(base64Encoded: encryptedMessage)!
        let decryptedData = try RNCryptor.decrypt(data: encryptedData, withPassword: encryptionKey)
        let decryptedString = String(data: decryptedData, encoding: .utf8)!
        
        return decryptedString
    }
    
    static func generateEncryptionKey(withPassword password:String) throws -> String {
        let randomData = RNCryptor.randomData(ofLength: 32)
        let cipherData = RNCryptor.encrypt(data: randomData, withPassword: password)
        return cipherData.base64EncodedString()
    }
    
    static func saveInKeychain(key: String) -> Bool{
       return   KeychainWrapper.standard.set(key, forKey: "encryptionKey")
    }
    static func getFromKeychain() -> String? {
     
        return     KeychainWrapper.standard.string(forKey: "encryptionKey")
    }
    
    static func removeFromKeychain() -> Bool {
    
        return KeychainWrapper.standard.removeObject(forKey: "encryptionKey")
    }
    
    
    static func getPassword() -> String{
        if let key = Security.getFromKeychain() {
          return try! Security.decryptMessage(encryptedMessage: Setting.init(setting: "password").value, encryptionKey: key)
        } else {
            return ""
        }
    
    }
    
    
    
}
