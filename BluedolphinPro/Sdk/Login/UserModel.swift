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
    required convenience public init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        mobile    <- map["mobile"]
        otpToken <- map["otpToken"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        imeiId    <- map["imeiId"]
        deviceType <- map["deviceType"]
        deviceToken <- map["deviceToken"]
        loginType <- map["loginType"]
        
        
    }
    override open static func primaryKey() -> String? {
        return "mobile"
    }
    

    
}

open class UserDataModel :NSObject, Meta{
    internal static func url() -> String {
        return  APIURL + ModuleUrl.User.rawValue
    }
    class func getHeader()->[String:String]{
        let headers = [
            "Content-Type":"application/json",
            "Accept-Encoding":"application/gzip",
            "Accept":"application/json"
        ]
        
        return headers
    }
    
    
    public class func userSignUp(param:[String:AnyObject],completion: @escaping (_ result: String) -> Void){
//        let realm = try! Realm()
//        let user = realm.objects(RMCUser.self).filter("mobile=%@",mobile).first
//        let param = user?.toDictionary()
//        print(param!)
    
    print(UserDataModel.url)
                NetworkModel.submitData(UserDataModel.url(), method: .put, params: param as? [String : AnyObject], headers: self.getHeader(), success: { (responseData) in
                    
                    guard let status = responseData["statusCode"] as? Int else {
                        return
                    }
                    switch status {
                    case 200:
                        completion(APIResult.Success.rawValue)
                    case 401:
                    
                        completion(APIResult.InvalidCredentials.rawValue)
                    case 403:
                        completion(APIResult.UserInteractionRequired.rawValue)
                
                    case 409:
                        completion(APIResult.InvalidData.rawValue)
                    case 500...502:
                        completion(APIResult.InternalServer.rawValue)
                        
                    default:break
                    }
                    
                    
                    
                    
                }) { (error) in
                    print(error)
        }
        
    }
    
    
   public class func  createUserData(userObject:[String:String]){
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



