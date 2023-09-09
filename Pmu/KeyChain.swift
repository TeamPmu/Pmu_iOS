//
//  KeyChain.swift
//  Pmu
//
//  Created by seohuibaek on 2023/08/28.
//

import Foundation
import Security

class KeyChain {
    
    static let serviceIdentifier: String = Bundle.main.bundleIdentifier!

    class func saveToken(_ token: String, forKey key: String) -> Bool {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrService as String : serviceIdentifier,
            kSecAttrAccount as String : key,
            kSecValueData as String   : token.data(using: String.Encoding.utf8)!
            ] as [String : Any]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    class func loadToken(forKey key: String) -> String? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrService as String : serviceIdentifier,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue as Any,
            kSecMatchLimit as String  : kSecMatchLimitOne
            ] as [String : Any]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? Data {
                return String(data: retrievedData, encoding: String.Encoding.utf8)
            }
        }
        
        return nil
    }
    
    class func deleteToken(forKey key: String) -> Bool {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrService as String : serviceIdentifier,
            kSecAttrAccount as String : key
        ] as [String : Any]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
    
    /*static func saveToken(_ token: String, forKey key: String) {
            if let data = token.data(using: .utf8) {
                let query: [String: Any] = [
                    kSecClass as String: kSecClassGenericPassword as String,
                    kSecAttrAccount as String: key,
                    kSecValueData as String: data
                ]
                
                SecItemDelete(query as CFDictionary)
                SecItemAdd(query as CFDictionary, nil)
            }
        }
        
        static func loadToken(forKey key: String) -> String? {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword as String,
                kSecAttrAccount as String: key,
                kSecMatchLimit as String: kSecMatchLimitOne,
                kSecReturnData as String: kCFBooleanTrue as CFBoolean
            ]
            
            var dataTypeRef: AnyObject?
            let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
            
            if status == errSecSuccess, let retrievedData = dataTypeRef as? Data, let token = String(data: retrievedData, encoding: .utf8) {
                return token
            } else {
                return nil
            }
        }
        
        static func deleteToken(forKey key: String) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword as String,
                kSecAttrAccount as String: key
            ]
            
            SecItemDelete(query as CFDictionary)
        }*/
}


