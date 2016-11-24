//
//  GlobalFunction.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 04/11/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation
import RealmSwift




public func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    Swift.print(items[0], separator:separator, terminator: terminator)
}



public func toDictionary(text: String) -> [String:AnyObject]? {
    if let data = text.data(using: String.Encoding.utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
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



public func getOrganization(){
    
}

public func getUserData(){
    let realm = try! Realm()
    let storage = UserDefaults.standard
    if let organizationId = storage.value(forKey: UserDefaultsKeys.organizationId.rawValue) as? String{
        CoreSingleton.sharedInstance.organizationId = organizationId
    }
    
    if let tokenData = realm.objects(AccessTokenObject.self).filter("organizationId = %@",CoreSingleton.sharedInstance.organizationId).first {
        CoreSingleton.sharedInstance.userId = tokenData.userId!
        CoreSingleton.sharedInstance.accessToken = tokenData.token!
    }
    
}


