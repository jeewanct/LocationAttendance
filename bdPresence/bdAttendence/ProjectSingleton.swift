//
//  ProjectSingleton.swift
//  bdAttendence
//
//  Created by Raghvendra on 29/05/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import Foundation
import Alamofire
 class ProjectSingleton {
    
    public static let sharedInstance: ProjectSingleton = ProjectSingleton()
    var internetAvailable = true
    var bluetoothAvaliable = true
    var locationAvailable = true
    
    
    class func fetchGenericData<T: Decodable>(_ strURL: String,header:NSDictionary, success:@escaping (T) -> Void, failure:@escaping (Error) -> Void) {
        print(strURL)
        print(header)
        
        let headers = [
            "Content-Type":"application/json",
            "Accept-Version":"0.0.1",
            "Accept-Encoding":"application/gzip",
            "Accept":"application/json",
            "Authorization":"Bearer " + "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI5ZTY5MTQ1MC04YjE5LTExZTgtODlkMC04ZDE0NTI1NmIzNTYiLCJzZWxmUmVxdWVzdCI6dHJ1ZSwiaWF0IjoxNTMxOTk1MTY2NDk2LCJvcmdhbml6YXRpb25JZCI6ImFmMzliYzY5LTE5MzgtNDE0OS1iOWY3LWYxMDFmZDliYWY3MyIsIm9yZ2FuaXphdGlvbk5hbWUiOiJCbHVlIERvbHBoaW4iLCJleHAiOjE1MzIwODE1NjY0OTYsInR5cGUiOiJhY2Nlc3NUb2tlbiIsInByaXZlbGVnZSI6IkZpZWxkLUV4ZWN1dGl2ZSJ9.RxAnCKfcYzIU_uK4DXfer_yQUC4Lo7RuYAZeJUjdFrVs8lI2N8AxuBVdKSZZcep9cKaRNGauhue1k0d9PtPcacJgheYI0vSssYpRpGNvn1-tbNQWG46uW817PeCl5mPwRrq9P5uHnYjdE7tPufnI6dtPryZkWlzAde6pN-vJTxf4h7zBRd6zl71SzwKO2Dnt3iX72tE8hduUwQ5yLLhGGRVDU-ag9YBkLpUIwOEP8N1lLqp9RQBnVsfmRUwFdr_jjWaWYhQtbjONFvOPipIWE2guaPmm5CH9rv6dfyPKfywwzk1qn0D1mAeRETr0SIahcJ4m7NZN7gbTVXfHLsvqqg",
            "userId": "9e691450-8b19-11e8-89d0-8d145256b356"
        ]
        
        Alamofire.request("https://ariuyux3uj.execute-api.ap-southeast-1.amazonaws.com/bd/dev/organisation/af39bc69-1938-4149-b9f7-f101fd9baf73/user",headers: headers as? HTTPHeaders).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            
            
            if responseObject.result.isSuccess {
                if let responseData = responseObject.data{
                    
                    do{
                        let jsonData = try JSONDecoder().decode(T.self, from: responseData)
                        success(jsonData)
                    }catch let jsonError{
                        failure(jsonError)
                    }
                }
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
            
            
        }
    }
    
    
}
