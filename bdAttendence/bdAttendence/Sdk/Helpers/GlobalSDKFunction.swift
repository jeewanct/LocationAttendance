//
//  GlobalFunction.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 04/11/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation
import RealmSwift
//import TrueTime





//func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
//    Swift.print(items[0], separator:separator, terminator: terminator)
//}

public func getCurrentDate()->Date{
   // return TrueTimeClient.sharedInstance.referenceTime?.time ?? Date()
  return Date()
}



public func toDictionary(text: String) -> AnyObject? {
    if let data = text.data(using: String.Encoding.utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
        } catch let error as NSError {
            print(error)
        }
    }
    return nil
}

public func toJsonString(_ dict:AnyObject)->String{
    
    var tempJson : String = ""
    do {
        let arrJson = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
        let string = NSString(data: arrJson, encoding: String.Encoding.utf8.rawValue)
        tempJson = string! as String
    }catch let error as NSError{
        print(error.description)
    }
    return tempJson
}


public func getUserData(){
    let realm = try! Realm()
    let storage = UserDefaults.standard
    if let organizationId = storage.value(forKey: UserDefaultsKeys.organizationId.rawValue) as? String{
        SDKSingleton.sharedInstance.organizationId = organizationId
        //"af39bc69-1938-4149-b9f7-f101fd9baf73"
        print("organisation id = \(organizationId)")
    }
    if let mobile = storage.value(forKey: UserDefaultsKeys.FeCode.rawValue) as? String{
        SDKSingleton.sharedInstance.mobileNumber = mobile
        print("mobile id = \(mobile)")
    }
    if let tokenData = realm.objects(AccessTokenObject.self).filter("organizationId = %@",SDKSingleton.sharedInstance.organizationId).first {
        print(tokenData)
        SDKSingleton.sharedInstance.userId = tokenData.userId
        print("user id = \(SDKSingleton.sharedInstance.userId)")
        SDKSingleton.sharedInstance.userName = tokenData.userName!
        SDKSingleton.sharedInstance.accessToken = tokenData.token
        print("accessToken id = \(SDKSingleton.sharedInstance.accessToken)")
    }
    
}


