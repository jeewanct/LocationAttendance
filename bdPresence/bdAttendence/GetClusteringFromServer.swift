//
//  GetClusteringFromServer.swift
//  bdPresence
//
//  Created by Jeevan Tiwari on 20/09/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import Foundation
import BluedolphinCloudSdk

class GetClusteringFromServer{
    
   
    
    class func getDataOf(date: Date){
        
        let convertedDate = date.toString(dateFormat: "YYYYMMdd")
        let query = "{\"docId\":{\"$in\":[\"\(SDKSingleton.sharedInstance.organizationId)|\(SDKSingleton.sharedInstance.userId)|\(convertedDate)\"]}}"
        
        
        if let getQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed){
            GetCheckinsData.getClusterData(query: getQuery, date: date)
        }
        
    }

    
}


extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
