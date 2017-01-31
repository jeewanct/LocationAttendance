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



class RMCUser :Object ,Mappable{
    

    dynamic var mobile:String?
    dynamic var otpToken:String?
    dynamic var firstName:String?
    dynamic var lastName:String?
    dynamic var imeiId:String?
    dynamic var deviceType:String?
    dynamic var deviceToken :String?
    dynamic var loginType:String?
    //dynamic var appId:String?
    
    
    //Impl. of Mappable protocol
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        mobile    <- map["mobile"]
        otpToken <- map["otpToken"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        imeiId    <- map["imeiId"]
        deviceType <- map["deviceType"]
        deviceToken <- map["deviceToken"]
        loginType <- map["loginType"]
        
        
    }
    override static func primaryKey() -> String? {
        return "mobile"
    }
    

    
}

class UserDataModel :Meta{
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
    
    
    func userSignUp(mobile:String){
        let realm = try! Realm()
        let user = realm.objects(RMCUser.self).filter("mobile=%@",mobile).first
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
    
    
    func createUserData(userObject:[String:String]){
        let user = RMCUser()
        user.mobile = userObject["mobile"]
        user.firstName = userObject["firstName"]
        user.lastName = userObject["lastName"]
        user.deviceToken = userObject["deviceToken"]
        user.deviceType = userObject["deviceType"]
        user.otpToken = userObject["otpToken"]
        user.imeiId = userObject["imeiId"]
        user.loginType = userObject["loginType"]
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(user,update:true)
        }
        
        
    }
    
    
}



