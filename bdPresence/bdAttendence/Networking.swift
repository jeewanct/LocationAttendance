//
//  File.swift
//  bdPresence
//
//  Created by Jeevan Tiwari on 31/07/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import Foundation
import Alamofire

class Networking{
    
    
    
    class func fetchGenericData<T: Decodable>(_ strURL: String,header:[String: String], success:@escaping (T) -> Void, failure:@escaping (Error) -> Void) {
        print(strURL)
        print(header)
        Alamofire.request(strURL,headers: header as? HTTPHeaders).responseJSON { (responseObject) -> Void in
            
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
