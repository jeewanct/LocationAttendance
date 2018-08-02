//
//  GoogleHelping.swift
//  bdPresence
//
//  Created by Jeevan Tiwari on 31/07/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import Foundation
import Alamofire

class GoogleDistanceCoveredTimeModel: Decodable{
    
    var rows : [GoogleRowModel]?
}

class GoogleRowModel: Decodable{
    
    var elements: [GoogleElementsModel]?
}

class GoogleElementsModel: Decodable{
    
    var duration: GoogleDurationModel?
}


class GoogleDurationModel: Decodable{
    
    var  text : String?
    var value : Int?
}



class GoogleUtils{
    
    class func findApproxTimeToTravel(firstLat: String, firstLong: String, secondLat: String, secondLong: String,completion:  @escaping([GoogleRowModel]?) -> Void){
        
    
        let url  =  AppConstants.GoogleConstants.GoogleDistanceMatrixApi +  "/json?origins=\(firstLat),\(firstLong)&destinations=\(secondLat),\(secondLong)&key=\(AppConstants.GoogleConstants.GoogleApiKey)&departure_time=\(LogicHelper.shared.getTime(date: Date()))&traffic_model=optimistic"
        
        Networking.fetchGenericData(url, header: [:], success: { (timeRequired: GoogleDistanceCoveredTimeModel) in
            
            completion(timeRequired.rows)
            
            
        }) { (error) in
            
        }
        
        
        
    }
}
