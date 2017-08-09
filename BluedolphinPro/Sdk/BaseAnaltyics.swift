//
//  BaseAnaltyics.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 20/03/17.
//  Copyright © 2017 raremediacompany. All rights reserved.
//

import Foundation

class BaseAnalytics{
    func getHeader()->[String:String]{
        let headers = [
            "Content-Type":"application/json",
            "Accept-Encoding":"application/gzip",
            "Accept":"application/json",
            "Authorization":"Bearer " + SDKSingleton.sharedInstance.accessToken,
            "userId":SDKSingleton.sharedInstance.userId
        ]
        
        return headers
    }
    
    func getBaseAnaltics(completion: @escaping (_ data:NSArray) -> Void){
        let url = APIURL + "organisation/\(SDKSingleton.sharedInstance.organizationId)/assignment?userAssignmentAggregation=\(SDKSingleton.sharedInstance.userId)&updatedAfter=\(Date().getDateFromCurrent(val: -7))"
        NetworkModel.fetchData(url, header: self.getHeader() as NSDictionary, success: { (response) in
            guard let status = response["statusCode"] as? Int else {
                return
            }
            switch status {
            case 200:
                guard let responseData = response["data"] as? NSDictionary else {
                    return
                }
                if let documents = responseData["documents"] as? NSArray {
                    completion(documents)
                        
                    }
                
                
                break;
            default:
            completion(NSArray())
            break
            
            }
        }) { (error) in
            print(error)
        }
    }
}
