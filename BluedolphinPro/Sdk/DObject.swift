//
//  DObject.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 08/08/17.
//  Copyright © 2017 raremediacompany. All rights reserved.
//

import Foundation



class DynamicObjectManager {
    internal static func url() -> String {
        return  APIURL + ModuleUrl.Organisation.rawValue + SDKSingleton.sharedInstance.organizationId
    }
    
    
    public class func getHeader()->[String:String]{
        let headers = [
            "Content-Type":"application/json",
            "Accept-Encoding":"application/gzip",
            "Accept":"application/json",
            "Authorization":"Bearer " + SDKSingleton.sharedInstance.accessToken,
            "userId":SDKSingleton.sharedInstance.userId
        ]
        
        return headers
    }
    
    public class func getDObjecct(completion: @escaping (_ result: BeaconScanning) -> Void){
        let url = DynamicObjectManager.url() + ModuleUrl.DObject.rawValue + "/5a6ecc6a-1d71-4400-adc6-2eb3b39cb5d0"
        
        //"?name=shift"
        //?vicinity=\(CurrentLocation.coordinate.latitude),\(CurrentLocation.coordinate.longitude)&maxDistance=2000"
        print(url)
        NetworkModel.fetchData(url, header: getHeader() as NSDictionary, success: { (response) in
            guard let status = response["statusCode"] as? Int else {
                return
            }
            switch status {
            case 200:
                guard let responseData = response["data"] as? NSDictionary else {
                    return
                }
                if let documents = responseData["documents"] as? NSArray {
                    
                    print(documents)
                }
                
                break;
            default:break
            }
        }) { (error) in
            completion(.Failure)
            print(error)
        }
}
}
