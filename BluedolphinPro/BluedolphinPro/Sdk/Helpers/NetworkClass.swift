//
//  NetworkClass.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 24/10/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation
import Alamofire


open class NetworkModel: NSObject {
    class func fetchData(_ strURL: String,header:NSDictionary, success:@escaping (NSDictionary) -> Void, failure:@escaping (Error) -> Void) {
        Alamofire.request(strURL,headers: header as? HTTPHeaders).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            
            if responseObject.result.isSuccess {
             let resJson = responseObject.result.value
                success(resJson  as! NSDictionary)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    
    class func submitData(_ strURL : String,method:HTTPMethod, params : [String : AnyObject]?, headers : [String : String]?, success:@escaping (NSDictionary) -> Void, failure:@escaping (Error) -> Void){
        
        Alamofire.request(strURL, method: method, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            
            if responseObject.result.isSuccess {
                let resJson = responseObject.result.value
                success(resJson as! NSDictionary)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    
    
    
    
}





