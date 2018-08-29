//
//  AppConstants.swift
//  bdPresence
//
//  Created by Jeevan Tiwari on 31/07/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import Foundation
import BluedolphinCloudSdk

struct AppConstants{
    
    static let baseUrl = "https://dqxr67yajg.execute-api.ap-southeast-1.amazonaws.com/bd/staging/organisation/"
    
    struct GoogleConstants{
        
        static let GoogleDistanceMatrixApi = "https://maps.googleapis.com/maps/api/distancematrix"
        static let googleDirectionApi = "https://maps.googleapis.com/maps/api/directions/json?"
        static let GoogleApiKey = "AIzaSyAEHGCnCX0R__be18wIL8sZ9UVhPO6bbAo"
    }
    
    
    struct GeotTags{
        static let geoTagCreationPermission = "/user/"
    }
    
}
