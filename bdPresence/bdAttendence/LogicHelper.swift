//
//  LogicHelper.swift
//  bdPresence
//
//  Created by Jeevan Tiwari on 25/07/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import Foundation
import CoreLocation
import BluedolphinCloudSdk

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
    
    
    
    // Plotting of Map work
    func plotMarkers(date: Date, completion: @escaping([LocationDataModel]) -> Void){
        
            let locations = UserDayData.getLocationData(date: date)
        
                if let getLocations = locations{
                    
                    let locationAfterAccuracy = self.removeUnneccessaryLocationsWithAccuracy(locations: getLocations)
                    
                    let locationAfterTime = self.removeUnnecessaryLocationWithTime(locations: locationAfterAccuracy)
                    
                    let locationAfterGoogle = self.removeLocationFromGoogleDistanceApi(locations: locationAfterTime)
                    
                    //let locationAfterGoogleCheck = self.removeUnnecessaryLocationWithTime(locations: locationAfterTime)
                   let finalLocations = self.removeDiscardedValues(locations: locationAfterGoogle)
                    
                    completion(finalLocations)
                        
            }
        
    }
    
     func plotMarkerInMap(locations: [LocationDataModel], completion: @escaping([LocationDataModel]) -> Void){
        
        
            
            let locationAfterAccuracy = self.removeUnneccessaryLocationsWithAccuracy(locations: locations)
            
            let locationAfterTime = self.removeUnnecessaryLocationWithTime(locations: locationAfterAccuracy)
            
            let locationAfterGoogle = self.removeLocationFromGoogleDistanceApi(locations: locationAfterTime)
            
            //let locationAfterGoogleCheck = self.removeUnnecessaryLocationWithTime(locations: locationAfterTime)
            let finalLocations = self.removeDiscardedValues(locations: locationAfterGoogle)
            
            completion(finalLocations)
            
        
        
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
    
    
    func removeUnnecessaryLocationWithTime(locations: [LocationDataModel]) -> [LocationDataModel]{
        
        
        for index in 0..<locations.count{
            
            if index == locations.count - 1{
                
            }else{
                
                
                let distance = distanceBetween(firstLat: locations[index].latitude, firstLong: locations[index].longitude, secondLat: locations[index + 1].latitude, secondLong: locations[index + 1].longitude)
                
                locations[index + 1].distance = distance
                
            }
            
        }
        
        return locations
        
    }
    
    
    func removeLocationFromGoogleDistanceApi(locations: [LocationDataModel]) -> [LocationDataModel]{
        
        
        for index in 0..<locations.count{
            
            if let distance = locations[index].distance{
                
                if distance == 0 || distance > 8000{
                    
                    if let firstLat = locations[index].latitude, let firstLong = locations[index].longitude, let secondLat = locations[index - 1].latitude, let secondLong = locations[index - 1].longitude{
                        
                        GoogleUtils.findApproxTimeToTravel(firstLat: firstLat, firstLong: firstLong, secondLat: secondLat, secondLong: secondLong) { (googleDistance) in
                            
                            
                            
                            if let firstLocationDate = locations[index].lastSeen, let secondLocationDate = locations[index - 1].lastSeen{
                                
                                
                                let discardBool = self.discardLocationUsingGoogle(timeRequired: googleDistance, timeDifference: self.getTime(date: secondLocationDate) - self.getTime(date: firstLocationDate))
                                
                                if discardBool == false {
                                    
                                    locations[index].isDiscarded = false
                                }else{
                                    locations[index].isDiscarded = true
                                }
                                
                            }
                            
                            
                            
                        }
                    }
                    
                }else {
                    
                    locations[index].isDiscarded = false
                }
                
            }else{
                locations[index].isDiscarded = false
            }
            
        }
        
        return locations
        
    }
    
    
    func removeDiscardedValues(locations: [LocationDataModel]) -> [LocationDataModel]{
        
        var updatedLocations = [LocationDataModel]()
        
        for location in locations{
            
            if location.isDiscarded == false{
                updatedLocations.append(location)
            }
        }
        
        return updatedLocations
    }
    
    func discardLocationUsingGoogle(timeRequired: [GoogleRowModel]?, timeDifference : Int) -> Bool{
        
        
        guard let googleTimeArray = timeRequired else{
            return false
        }
        
        var timeTaken = 0
        
        for timeArray in googleTimeArray{
            
            if let elements = timeArray.elements{
                
                for element in elements{
                    
                    if let getTime = element.duration?.value{
                        timeTaken = timeTaken + getTime
                        
                    }
                    
                }
                
            }
            
        }
        
        if 0.45 * Double(timeTaken) <= Double(timeDifference){
            return true
        }
        
        return false
        
    }
    
    
    func distanceBetween(firstCoordinate first: CLLocation, secondCoordinate second: CLLocation) -> Double{
        
        return first.distance(from: second)
        
    }
    
    func distanceBetween(firstLat: String?, firstLong: String?, secondLat: String?, secondLong: String?) -> Double{
        
        
        guard let firstUnwrappedLat = firstLat, let firstUnwrappedLong = firstLong, let secondUnwrappedLat = secondLat, let secondUnwrappedLong = secondLong else {
            return 0
            
        }
        
        if let firstLocationLat = CLLocationDegrees(firstUnwrappedLat), let firstLocationLong = CLLocationDegrees(firstUnwrappedLong), let secondLocationLat = CLLocationDegrees(secondUnwrappedLat), let secondLocationLong = CLLocationDegrees(secondUnwrappedLong){
            
            let firstLocation = CLLocation(latitude: CLLocationDegrees(firstLocationLat), longitude: CLLocationDegrees(firstLocationLong))
            let secondLocation = CLLocation(latitude: CLLocationDegrees(secondLocationLat), longitude: CLLocationDegrees(secondLocationLong))
            
            return firstLocation.distance(from: secondLocation)
            
        }
        
        return 0
    }
    
    
    func getTime(date: Date) -> Int{
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        
        return hour * 60 * 60 + minutes * 60 + seconds
        
    }
    
    
    
    
    
}
