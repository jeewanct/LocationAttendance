//
//  LocationFilters.swift
//  bdPresence
//
//  Created by Jeevan Tiwari on 10/08/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import Foundation
import CoreLocation
import BluedolphinCloudSdk
import Polyline

class LocationFilters: UIViewController{
    
    var delegate: LocationsFilterDelegate?
    
   // var finalLocations = [LocationDataModel]()
    
     func plotMarkers(date: Date){
        
        let queue = DispatchQueue(label: "filter")
        
        queue.sync {
            let locations = UserDayData.getLocationData(date: date)
            
            DispatchQueue.main.async {
            
                if let getLocations = locations{
                    
                    let locationAfterAccuracy = self.removeUnneccessaryLocationsWithAccuracy(locations: getLocations)
                    
                    if let locationAfterTime = self.removeUnnecessaryLocationWithTime(locations: locationAfterAccuracy, currentIndex: 0){
                        //completion(locationAfterTime)
                        
                    }
                    
                    // let finalLocations = self.findFaultyLocations(locations: locationAfterTime)
                    
                }
            }
        }

    }
    
    func plotMarkerInMap(locations: [LocationDataModel]){
        
        let locationAfterAccuracy = self.removeUnneccessaryLocationsWithAccuracy(locations: locations)
        
        if let locationAfterTime = self.removeUnnecessaryLocationWithTime(locations: locationAfterAccuracy, currentIndex: 0){
            //completion(locationAfterTime)
            
        }
        
    }
    
    
    
    
    func removeUnneccessaryLocationsWithAccuracy(locations: [LocationDataModel]) ->  [LocationDataModel]{
        
        let updatedLocations  = locations.filter{
            if let accuracy = $0.accuracy{
                return accuracy < 700.0
            }
            return false
        }
        return updatedLocations
        
    }
    
    func removeUnnecessaryLocationWithTime(locations: [LocationDataModel], currentIndex: Int) -> [LocationDataModel]?{
        
        
        for index in currentIndex..<locations.count{
            
            if index == locations.count - 1{
                
            }else{
                
                
                let distance = LogicHelper.shared.distanceBetween(firstLat: locations[index].latitude, firstLong: locations[index].longitude, secondLat: locations[index + 1].latitude, secondLong: locations[index + 1].longitude)
                
                
                if distance == 0 || distance > 8000{
                    
                    removeFromGoogleApi(locations: locations, index: index + 1)
                    return nil
                    
                    
                }
                
            }
            
        }
        
        print(locations)
        delegate?.finalLocations(locations: locations)
        return locations
        
    }
    
    
    func removeFromGoogleApi(locations: [LocationDataModel], index: Int){
        
        var removeLocation = locations
        if let firstLat = locations[index].latitude, let firstLong = locations[index].longitude, let secondLat = locations[index - 1].latitude, let secondLong = locations[index - 1].longitude{
            
            GoogleUtils.findApproxTimeToTravel(firstLat: firstLat, firstLong: firstLong, secondLat: secondLat, secondLong: secondLong) { (googleDistance) in
                
                
                if let firstLocationDate = locations[index].lastSeen, let secondLocationDate = locations[index - 1].lastSeen{
                    
                    
                    let discardBool = LogicHelper.shared.discardLocationUsingGoogle(timeRequired: googleDistance, timeDifference: LogicHelper.shared.getTime(date: firstLocationDate) - LogicHelper.shared.getTime(date: secondLocationDate))
                    
                    if discardBool == false {
                        
                        self.removeUnnecessaryLocationWithTime(locations: removeLocation, currentIndex: index)
                        // locations[index].isDiscarded = false
                    }else{
                        
                        
                        removeLocation.remove(at: index)
                        self.removeUnnecessaryLocationWithTime(locations: removeLocation, currentIndex: index - 1)
                        // locations[index].isDiscarded = true
                    }
                    
                }
                
                
            }
            
            
        }
        
        
        
        
        
    }
    
    
    
}
