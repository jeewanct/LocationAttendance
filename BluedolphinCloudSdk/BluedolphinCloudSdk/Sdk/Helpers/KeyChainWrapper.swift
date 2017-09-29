//
//  KeyChainWrapper.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 17/11/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//


import Foundation
import Security

 open class KeychainService: NSObject {
    
    var service = "Service"
    var keychainQuery :[NSString: AnyObject]! = nil
    
   public func save(name: NSString, value: NSString) -> OSStatus? {
        let statusAdd :OSStatus?
        
        guard let dataFromString: Data = value.data(using: String.Encoding.utf8.rawValue) else {
            return nil
        }
        
        keychainQuery = [
            kSecClass       : kSecClassGenericPassword,
            kSecAttrService : service as AnyObject,
            kSecAttrAccount : name,
            kSecValueData   : dataFromString as AnyObject]
        if keychainQuery == nil {
            return nil
        }
        
        SecItemDelete(keychainQuery as CFDictionary)
        
        statusAdd = SecItemAdd(keychainQuery! as CFDictionary, nil)
        
        return statusAdd;
    }
    
   public func load(name: NSString) -> String? {
        var contentsOfKeychain :String?
        
        keychainQuery = [
            kSecClass       : kSecClassGenericPassword,
            kSecAttrService : service as AnyObject,
            kSecAttrAccount : name,
            kSecReturnData  : kCFBooleanTrue,
            kSecMatchLimit  : kSecMatchLimitOne]
        if keychainQuery == nil {
            return nil
        }
        
        var dataTypeRef: AnyObject?
        let status: OSStatus = SecItemCopyMatching(keychainQuery as CFDictionary, &dataTypeRef)
        
        if (status == errSecSuccess) {
            let retrievedData: Data? = dataTypeRef as? Data
            if let result = NSString(data: retrievedData!, encoding: String.Encoding.utf8.rawValue) {
                contentsOfKeychain = result as String
            }
        }
        else {
            print("Nothing was retrieved from the keychain. Status code \(status)")
        }
        
        return contentsOfKeychain
    } 
}
