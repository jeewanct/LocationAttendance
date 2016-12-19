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
            completion(APIResult.Success.rawValue)
        }) { (error) in
            print(error)
        }
        
        
    }
    
    
}
