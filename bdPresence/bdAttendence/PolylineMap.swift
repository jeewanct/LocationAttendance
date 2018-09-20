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
    
    // changes for more than 1 polyline
    var allLocations = [[LocationDataModel]]()
    var polylineString = ""
    
    
    func takePolyline(){
        
        if allLocations.count <= 8 {
            
            getPolylineFromGoogle(location: allLocations, isLast: true)
            
        }else{
        
        let locationSequence = 0...7
        
        var tempLocation = [[LocationDataModel]]()
            
        
        for index in allLocations[locationSequence]{
            tempLocation.append(index)
        }
        
            let sequence = 0...6
            self.allLocations.removeSubrange(sequence)
            
            
        getPolylineFromGoogle(location: tempLocation, isLast: false)
            
            
        }
        
    }
    
    
    func getPolylineFromGoogle(location: [[LocationDataModel]], isLast: Bool){
        
        let origin = returnLatLongString(location: location.first)
        let destination = returnLatLongString(location: location.last)
        var wayPoints = ""
        
        if location.count == 3{
            
            wayPoints =   returnLatLongString(location: location[1])
            
        }else if location.count > 3{
            wayPoints = returnWayPoints(location: location)
        }
        
        let orginDestinationString = "origin=\(origin)&destination=\(destination)"
        
        GoogleUtils.getPolylineFromGoogle(originDestination: orginDestinationString, wayPoints: wayPoints, isLast: isLast) { (polyline, value) in
            
            self.polylineString = self.polylineString + polyline
            
            if value == true{
                let  coordinates: [CLLocationCoordinate2D]? = decodePolyline(self.polylineString)
                
                if let getCoordinates = coordinates{
                    
                    
                        self.delegate?.drawPolyline(coordinates: getCoordinates)
                   
                    
                  
                    //self.drawPath(coordinates: getCoordinates)
                }
                
            }else{
                
                  self.takePolyline()
               
               
                
            }
            
            
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
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
                
//                if let geoTag = index.geoTaggedLocations{
//
//                    if let latitude = geoTag.latitude, let longitude = geoTag.longitude{
//
//                        locationString.append("\(latitude),\(longitude)")
//                        break
//                    }
//
//                }else{
                
                    if let latitude = index.latitude, let longitude = index.longitude{
                        locationString.append("\(latitude),\(longitude)")
                         break
                    }
                   
                    
                //}
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




class DrawPolyLineInMap{
    
    var delegate: PolylineStringDelegate?
    
    
    func getPolyline(location: [UserDetailsDataModel]){
        
        
        
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
    
    
    func returnLatLongString(location: UserDetailsDataModel?) -> String{
        
        
        guard let getLocation = location else {
            return ""
        }
        var locationString = ""
        
                
                if let latitude = getLocation.latitude, let longitude = getLocation.longitude{
                    locationString.append("\(latitude),\(longitude)")
                    return locationString
                }
                
                
        
        return locationString
        
    }
    
    func returnWayPoints(location: [UserDetailsDataModel]) -> String{
        
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
