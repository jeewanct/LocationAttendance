 //
//  UserModel.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 25/10/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
 protocol Meta {
    static func url()->String
}



 class UserObject :Object ,Mappable{
    

    dynamic var email:String?
    dynamic var password:String?
    dynamic var firstName:String?
    dynamic var lastName:String?
    dynamic var imeiId:String?
    dynamic var deviceType:String?
    dynamic var deviceToken :String?
    dynamic var signUpType:String?
    //dynamic var appId:String?
    
    
    //Impl. of Mappable protocol
    required convenience  init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        email    <- map["email"]
        password <- map["password"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        imeiId    <- map["imeiId"]
        deviceType <- map["deviceType"]
        deviceToken <- map["deviceToken"]
        signUpType <- map["signUpType"]
        
        
    }
    override  static func primaryKey() -> String? {
        return "email"
    }
    

    
}

public class UserDataModel :Meta{
    internal static func url() -> String {
        return  APIURL + ModuleUrl.User.rawValue
    }
    func getHeader()->[String:String]{
        let headers = [
            "Content-Type":"application/json",
            "Accept-Encoding":"application/gzip",
            "Accept":"application/json"
        ]
        
        return headers
    }
    
    
   public func userSignUp(email:String){
        let realm = try! Realm()
        let user = realm.objects(UserObject.self).filter("email=%@",email).first
        let param = user?.toDictionary()
        
        
                NetworkModel.submitData(UserDataModel.url(), method: .put, params: param as? [String : AnyObject], headers: self.getHeader(), success: { (responseData) in
                    
                    guard let status = responseData["statusCode"] as? Int else {
                        return
                    }
                    switch status {
                    case 200:
                        print(responseData)
                        
                        
                        

                    case 400:
                        print(responseData)
                    case 409:
                        
                        
                        print(responseData)
                        break;
                    case 500...502:
                        break
                        
                        
                    default:break
                    }
                    
                    
                    
                    
                }) { (error) in
                    print(error)
        }
        
    }
    
    
   public func createUserData(userObject:[String:String]){
        let user = UserObject()
        user.email = userObject["email"]
        user.firstName = userObject["firstName"]
        user.lastName = userObject["lastName"]
        user.deviceToken = userObject["deviceToken"]
        user.deviceType = userObject["deviceType"]
        user.password = userObject["password"]
        user.imeiId = userObject["imeiId"]
        user.signUpType = userObject["signUpType"]
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(user,update:true)
        }
        
        
    }
    
    
}



