//
//  UserDeviceModel.swift
//  BluedolphinCloudSdk
//
//  Created by Raghvendra on 31/08/17.
//  Copyright © 2017 raremediacompany. All rights reserved.
//

import Foundation


open class UserDeviceModel:NSObject, Meta{
    internal static func url() -> String {
        return  APIURL + ModuleUrl.Organisation.rawValue + SDKSingleton.sharedInstance.organizationId +  "/" + ModuleUrl.User.rawValue
    }
    
    class func getHeader()->[String:String]{
        let headers = [
            "Content-Type":"application/json",
            "Accept-Encoding":"application/gzip",
            "Accept":"application/json",
            "Authorization":"Bearer " + SDKSingleton.sharedInstance.accessToken,
            "userId":SDKSingleton.sharedInstance.userId
        ]
        return headers
    }
    
     public class  func getDeviceStatus(completion: @escaping (_ result: String,_ imeid:String) -> Void){
            let url = UserDeviceModel.url() + SDKSingleton.sharedInstance.userId + "?device=\(true)"
            NetworkModel.fetchData(url, header: getHeader() as NSDictionary, success: { (response) in
                guard let status = response["statusCode"] as? Int else {
                    return
                }
                switch status {
                case 200:
                    if let data = response["data"] as? NSArray {
                        for valueData  in data{
                            let valueDatadict = valueData as! NSDictionary
                            if let documents = valueDatadict["documents"] as? NSArray {
                                
                                for document in documents{
                                    let documentDict = document as! NSDictionary
                                    if let imeid = documentDict["imeiId"] as? String{
                                        completion(APIResult.Success.rawValue,imeid)
                                    }else{
                                        completion(APIResult.Success.rawValue,"")
                                    }
                                }
                                
                            }
                        }
                    }
                case 401:
                    
                    completion(APIResult.InvalidCredentials.rawValue,"")
                case 403:
                    completion(APIResult.UserInteractionRequired.rawValue,"")
                    
                case 409:
                    completion(APIResult.InvalidData.rawValue,"")
                case 500...502:
                    completion(APIResult.InternalServer.rawValue,"")
                    
                default:break
                }
                
                
                
                
            }) { (error) in
                print(error)
            }
        }

}
