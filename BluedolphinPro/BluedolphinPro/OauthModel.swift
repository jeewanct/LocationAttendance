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
    
    
    func getToken(userObject:[String:String],completion: @escaping (_ result: String) -> Void){
        
        
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
                            
                        case 400...449:
                            completion(APIResult.Fail.rawValue)
                            break;
                        case 500...502:
                            completion(APIResult.Fail.rawValue)
                            break
                            
                            
                        default:break
                        }
                        
                  
            
            
        }) { (error) in
            completion(APIResult.Fail.rawValue)
            print(error)
        }
        
    }
    
    
    func updateToken(){
         let realm = try! Realm()
        var refreshToken = String()
        let refreshTokenData = realm.objects(RefreshTokenObject.self)
        for data in refreshTokenData{
            if let token = data["refreshToken"] as? String {
                refreshToken = token
            }
        }
        
        let param = [
            "grantType":"refreshToken",
            "selfRequest":"true",
            "refreshToken": refreshToken,
            "userId" :Singleton.sharedInstance.userId
        ]
        
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
                    try! realm.write {
                        //                                let oauth = realm.objects(Oauth.self){
                        //                                    realm.delete(self)
                        //                                }
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
