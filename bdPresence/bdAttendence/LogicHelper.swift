//
//  LogicHelper.swift
//  bdPresence
//
//  Created by Jeevan Tiwari on 25/07/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import Foundation
import CoreLocation

class LogicHelper{
    
    static let shared = LogicHelper()
    
    func reverseGeoCode(location: CLLocation, completion: @escaping(String) -> Void){
        
        var userAddress = ""
       
        CLGeocoder().reverseGeocodeLocation(location) { (response , error) in
            
            guard let loc = response?.first else {
                return
            }
            
            let addressDict : [NSString:NSObject] = loc.addressDictionary as! [NSString: NSObject]
            let addrList = addressDict["FormattedAddressLines"] as! [String]
            let address = addrList.joined(separator: ", ")
            print("address from SDK = \(address)")
            completion(address)
            userAddress = address
            
            
            
        }
        
       // return userAddress
        
    }
}
