//
//  PolylineMap.swift
//  bdPresence
//
//  Created by Jeevan Tiwari on 10/08/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import Foundation
import Polyline
import MapKit

class PolyLineMap{
    
    var delegate: PolylineStringDelegate?
    
     func getPolyline(location: [[LocationDataModel]]){
        
    
        
        let origin = returnLatLongString(location: location.first)
        let destination = returnLatLongString(location: location.last)
        var wayPoints = ""
        
        if location.count == 3{
            
          wayPoints =   returnLatLongString(location: location[1])
            
        }else if location.count > 3{
            wayPoints = returnWayPoints(location: location)
        }
        
        let orginDestinationString = "origin=\(origin)&destination=\(destination)"
        
        GoogleUtils.getPolylineGoogle(originDestination: orginDestinationString, wayPoints: wayPoints) { (polyline) in
            
            let  coordinates: [CLLocationCoordinate2D]? = decodePolyline(polyline)
            
            if let getCoordinates = coordinates{
                
                self.delegate?.drawPolyline(coordinates: getCoordinates)
                //self.drawPath(coordinates: getCoordinates)
            }
            
            
        }
        

        
        
    }
    
    
     func returnLatLongString(location: [LocationDataModel]?) -> String{
    
        var locationString = ""
        
        
        if let  origin = location{
            
            for index in origin{
                
                if let geoTag = index.geoTaggedLocations{
                    
                    if let latitude = geoTag.latitude, let longitude = geoTag.longitude{
                        
                        locationString.append("\(latitude),\(longitude)")
                        break
                    }
                    
                }else{
                    
                    if let latitude = index.latitude, let longitude = index.longitude{
                        locationString.append("\(latitude),\(longitude)")
                         break
                    }
                   
                    
                }
            }
        }
    
        return locationString
        
    }
    
     func returnWayPoints(location: [[LocationDataModel]]) -> String{
        
        let sequence = 1...location.count-2
        
        let array = location[sequence]
        
        var locationString = ""
        
        for index in array{
            
           let locationStr =  returnLatLongString(location: index)
            
           locationString.append(locationStr)
            locationString.append("|")
            
        }
        
        if locationString.last == "|"{
            locationString.removeLast()
        }
        
        return locationString
        
    }
    
    
    
    
    
}
