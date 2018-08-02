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
        
        let queue = DispatchQueue.global(qos: .userInteractive)
        
        queue.async {
            let locations = UserDayData.getLocationData(date: date)
            
            DispatchQueue.main.async() {
                
                if let getLocations = locations{
                   
                    
                        
                    
                    
                    let locationAfterAccuracy = self.removeUnneccessaryLocationsWithAccuracy(locations: getLocations)
                    
                    let locationAfterTime = self.removeUnnecessaryLocationWithTime(locations: locationAfterAccuracy)
                    
                    let locationAfterGoogleCheck = self.removeUnnecessaryLocationWithTime(locations: locationAfterTime)
                    
                    
                    completion(locationAfterGoogleCheck)
                        
                    }
                    
                    
             
                
                
                
            }
        }
        
        
    }
    
    func removeUnneccessaryLocationsWithAccuracy(locations: [LocationDataModel]) ->  [LocationDataModel]{
        
        var updatedLocations = [LocationDataModel]()
        
        
        for location in locations{
            
            if let getAccuracy = location.accuracy, let accuracy = Float(getAccuracy){
                
                if accuracy > 700{
                    
                }else{
                    updatedLocations.append(location)
                }
            }
        }
        
        
       // let finalLocations = removeUnnecessaryLocationWithTime(locations: updatedLocations)
       // userLocations = finalLocations
    
        return updatedLocations
        
        //print("After removing locations", finalLocations)
        
        
        
    }
    
    func removeUnnecessaryLocationWithTime(locations: [LocationDataModel]) -> [LocationDataModel]{
        
        var updatedLocations = [LocationDataModel]()
        
        
        if locations.count <= 2{
            return locations
        }else{
    
        
        for index1 in 0..<locations.count - 1 {
            
            
            if let firstLat = locations[index1].latitude, let firstLong =  locations[index1].longitude, let secondLat = locations[index1 + 1].latitude, let secondLong = locations[index1 + 1].longitude{
                
                let distanceBetweenTwoCoordinates = distanceBetween(firstLat: firstLat, firstLong: firstLong, secondLat: secondLat, secondLong: secondLong)
                
                if distanceBetweenTwoCoordinates == 0 || distanceBetweenTwoCoordinates > 8000{
                    
                    
                    GoogleUtils.findApproxTimeToTravel(firstLat: firstLat, firstLong: firstLong, secondLat: secondLat, secondLong: secondLong) { (googleDistance) in
                        
                        if let firstLocationDate = locations[index1].lastSeen, let secondLocationDate = locations[index1 + 1].lastSeen{
                            
                            let discardBool = self.discardLocationUsingGoogle(timeRequired: googleDistance, timeDifference: self.getTime(date: secondLocationDate) - self.getTime(date: firstLocationDate))
                            
                            if discardBool == true{
                                updatedLocations.append(locations[index1 + 1])
                            }
                            
                        }
                        
                    }
                    
                    
                    
                    
                }else{
                    
                    updatedLocations.append(locations[index1])
                }
                
                
            }
            
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
    
    func distanceBetween(firstLat: String, firstLong: String, secondLat: String, secondLong: String) -> Double{
        
        if let firstLocationLat = CLLocationDegrees(firstLat), let firstLocationLong = CLLocationDegrees(firstLong), let secondLocationLat = CLLocationDegrees(secondLat), let secondLocationLong = CLLocationDegrees(secondLong){
            
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
