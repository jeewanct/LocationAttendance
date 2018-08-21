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

class GoogleDirectionRoutesModel: Decodable{
    var routes: [GooglePolylineModel]?
}

class GooglePolylineModel: Decodable{
    var overview_polyline: GooglePointsModel?
}

class GooglePointsModel: Decodable{
    var points: String?
}


class GoogleUtils{
    
    class func findApproxTimeToTravel(firstLat: String, firstLong: String, secondLat: String, secondLong: String,completion:  @escaping([GoogleRowModel]?) -> Void){
        
    
        let url  =  AppConstants.GoogleConstants.GoogleDistanceMatrixApi +  "/json?origins=\(firstLat),\(firstLong)&destinations=\(secondLat),\(secondLong)&key=\(AppConstants.GoogleConstants.GoogleApiKey)&departure_time=\(LogicHelper.shared.getTimeStamp())&traffic_model=optimistic"
        
        Networking.fetchGenericData(url, header: [:], success: { (timeRequired: GoogleDistanceCoveredTimeModel) in
            
            completion(timeRequired.rows)
            
            
        }) { (error) in
            
            print(error)
        }
        
        
    }
    
    class func getPolylineGoogle(originDestination: String,wayPoints: String, completion: @escaping(String) -> Void){
        
        
        guard let escapedString = wayPoints.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        
        let url = AppConstants.GoogleConstants.googleDirectionApi + originDestination + "&optimize=false&travelmode=driving&waypoints=\(escapedString)&key=" + AppConstants.GoogleConstants.GoogleApiKey
        
        
        Networking.fetchGenericData(url, header: [:], success: { (polyline: GoogleDirectionRoutesModel) in
            
            if let getPolyline = polyline.routes{
                
                var polyLineString = ""
                for index in getPolyline{
                    if let getPolyLine = index.overview_polyline?.points{
                        polyLineString.append(getPolyLine)
                    }
                }
                
                completion(polyLineString)
                
            }
            
            print(polyline.routes)
        }) { (error) in
            print(error)
        }
        
        

        
        
    }
    
    
    
}


