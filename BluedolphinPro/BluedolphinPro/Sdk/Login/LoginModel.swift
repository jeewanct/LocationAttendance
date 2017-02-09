//
//  LoginModel.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 16/12/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation


class OTPModel: Meta {
internal static func url() -> String {
    return  APIURL + ModuleUrl.GetOtp.rawValue
}
    func getOtp(mobile:String,completion: @escaping (_ result: String) -> Void){
        let headers = [
            "Content-Type":"application/json",
            "Accept-Encoding":"application/json",
            "Accept":"application/json"
        ]
        NetworkModel.fetchData(OTPModel.url() + mobile, header: headers as NSDictionary, success: { (response) in
            print(response)
            guard let status = response["statusCode"] as? Int else {
                return
            }
            switch status {
            case 200:
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
            print(error)
        }
        
        
    }
    
    
}
