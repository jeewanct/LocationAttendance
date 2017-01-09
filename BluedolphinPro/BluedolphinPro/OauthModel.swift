//
//  OauthModel.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 26/10/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation
import RealmSwift


class OauthModel :Meta{
    
    internal static func url() -> String {
        return   APIURL + ModuleUrl.Oauth.rawValue
    }
    
    
    func getToken(userObject:[String:Any],completion: @escaping (_ result: String) -> Void){
        
        
        let headers = [
            "Content-Type":"application/json",
            "Accept-Encoding":"application/json",
            "Accept":"application/json"
        ]
        
        let realm = try! Realm()

                NetworkModel.submitData(OauthModel.url(), method: .post, params: userObject as [String : AnyObject]?, headers: headers, success: { (dataValue) in
                    
                    guard let status = dataValue["statusCode"] as? Int else {
                        return
                    }
                        switch status {
                        case 200:
                            
                            
                            if let data = dataValue["data"] as? NSDictionary {
                            
//                                let oauth = realm.objects(Oauth.self){
//                                    realm.delete(self)
//                                }
                                if let accessToken = data["accessToken"] as? NSArray{
                                    for val in accessToken{
                                        try! realm.write {
                                      realm.create(AccessTokenObject.self, value: val, update: true)
                                        }
                                        let data = val as! NSDictionary
                                        if let organizationId = data["organizationId"] as? String{
                                            UserDefaults.standard.set(organizationId, forKey: UserDefaultsKeys.organizationId.rawValue)
                                        }
                                    }
                                    completion(APIResult.Success.rawValue)
                                    
                                }
                                if let refreshToken = data["refreshToken"] as? NSArray{
                                    for val in refreshToken{
                                        try! realm.write {
                                       realm.create(RefreshTokenObject.self, value: val, update: true)
                                        }
                                    }
                                    
                                }
                                
                                
                            }
                            
                            completion(APIResult.Success.rawValue)
                            case 401:
                                completion(APIResult.InvalidCredentials.rawValue)
                            case 409:
                                completion(APIResult.InvalidData.rawValue)
                            case 500...502:
                                completion(APIResult.InternalServer.rawValue)
                           
                            
                        default:break
                        }
                        
                  
            
            
        }) { (error) in
            completion(APIResult.Fail.rawValue)
            print(error)
        }
        
    }
    
    
    func updateToken(){
         let realm = try! Realm()
        var today : Bool?
        if let todayDate = UserDefaults.standard.value(forKey: UserDefaultsKeys.startDate.rawValue) as? Date {
            today = Calendar.current.isDateInToday(todayDate)
        }
        else {
            today = false
        }
        if today == false {
        var refreshToken = String()
        let refreshTokenData = realm.objects(RefreshTokenObject.self).first
             print(refreshTokenData)
            if let token = refreshTokenData?["token"] as? String {
                refreshToken = token
            }
        
        
        let param = [
            "grantType":"refreshToken",
            "selfRequest":true,
            "refreshToken": refreshToken,
            "userId" :Singleton.sharedInstance.userId
        ] as [String : Any]
        
        let headers = [
            "Content-Type":"application/json",
            "Accept-Encoding":"application/json",
            "Accept":"application/json"
        ]
        
       
        
        NetworkModel.submitData(OauthModel.url(), method: .post, params: param as [String : AnyObject]?, headers: headers, success: { (dataValue) in
            
            let status = dataValue["statusCode"] as! Int
            switch status {
            case 200:
                
                
                if let data = dataValue["data"] as? NSDictionary {
                    UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.startDate.rawValue)
                    try! realm.write {
                        
                        if let accessToken = data["accessToken"] as? NSArray{
                            for val in accessToken{
                                realm.create(AccessTokenObject.self, value: val, update: true)
                            }
                            
                        }
                        if let refreshToken = data["refreshToken"] as? NSArray{
                            for val in refreshToken{
                                realm.create(RefreshTokenObject.self, value: val, update: true)
                            }
                            
                        }
                        
                        
                    }
                    getUserData()
                }
            case 400...449:
                break;
            case 500...502:
                break
                
                
            default:break
            }
            
            
            
            
        }) { (error) in
            print(error)

        
    }
        }
}
}
