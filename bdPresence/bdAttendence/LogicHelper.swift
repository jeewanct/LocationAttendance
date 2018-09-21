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
import Polyline
import GooglePlaces
class LogicHelper{
    
    static let shared = LogicHelper()
    
    func reverseGeoCode(location: CLLocation, completion: @escaping(String) -> Void){
        
        //var userAddress = ""
        
        let geoCoder = GMSGeocoder()
        geoCoder.reverseGeocodeCoordinate(location.coordinate) { (response, error) in
            
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                
            //   let currentAddress = lines.joinWithSeparator("\n")
                
                completion(lines.joined(separator: "\n"))
            }
            
        }
        
        
        
        
//        geoCoder.reverseGeocodeLocation(location) { (response , error) in
//
//            guard let loc = response?.first else {
//                return
//            }
//
//            let addressDict : [NSString:NSObject] = loc.addressDictionary as! [NSString: NSObject]
//            let addrList = addressDict["FormattedAddressLines"] as! [String]
//            let address = addrList.joined(separator: ", ")
//            print("address from SDK = \(address)")
//            completion(address)
//            //userAddress = address
//
//
//
//        }
//
        // return userAddress
        
    }
    
    func reverseGeoCodeGeoLocations(location: CLLocation, index1: Int, index2: Int, completion: @escaping(String, Int, Int) -> Void){
        
        //var userAddress = ""
        
        
        let geoCoder = GMSGeocoder()
        geoCoder.reverseGeocodeCoordinate(location.coordinate) { (response, error) in
            
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                
                //   let currentAddress = lines.joinWithSeparator("\n")
                
               //lines.joined(separator: "\n") completion(lines.joined(separator: "\n"))
                completion(lines.joined(separator: "\n"), index1, index2)
            }
            
        }
        
//        CLGeocoder().reverseGeocodeLocation(location) { (response , error) in
//
//            guard let loc = response?.first else {
//                return
//            }
//
//            let addressDict : [NSString:NSObject] = loc.addressDictionary as! [NSString: NSObject]
//            let addrList = addressDict["FormattedAddressLines"] as! [String]
//            let address = addrList.joined(separator: ", ")
//            print("address from SDK = \(address)")
//            completion(address, index1, index2)
//            //userAddress = address
//
//
//
//        }
        
        // return userAddress
        
    }
    
    
    
    // Plotting of Map work
    func plotMarkers(date: Date, completion: @escaping([LocationDataModel]) -> Void){
        
        let locations = UserDayData.getLocationData(date: date)
        
       
            if let getLocations = locations{
                
                let locationAfterAccuracy = self.removeUnneccessaryLocationsWithAccuracy(locations: getLocations)
                
                if let locationAfterTime = self.removeUnnecessaryLocationWithTime(locations: locationAfterAccuracy, currentIndex: 0){
                    completion(locationAfterTime)
                    
                }
                
               // let finalLocations = self.findFaultyLocations(locations: locationAfterTime)
                
                
                
                
                
            }
          
        
    }
    
    func plotMarkerInMap(locations: [LocationDataModel], completion: @escaping([LocationDataModel]) -> Void){
        
        
        
        let locationAfterAccuracy = self.removeUnneccessaryLocationsWithAccuracy(locations: locations)
        
        
        if  let locationAfterTime = self.removeUnnecessaryLocationWithTime(locations: locationAfterAccuracy, currentIndex: 0){
            completion(locationAfterTime)
            
        }
        
       
        
       // completion(finalLocations)
        
        
        
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
                
                
                let distance = distanceBetween(firstLat: locations[index].latitude, firstLong: locations[index].longitude, secondLat: locations[index + 1].latitude, secondLong: locations[index + 1].longitude)
                
                
                if distance == 0 || distance > 8000{
                    
                    removeFromGoogleApi(locations: locations, index: index + 1)
                    return nil
                    
                    
                }
                
            }
            
        }
        
        print(locations)
        
        return locations
        
    }
    

    
    func removeFromGoogleApi(locations: [LocationDataModel], index: Int){
        
        var removeLocation = locations
        if let firstLat = locations[index].latitude, let firstLong = locations[index].longitude, let secondLat = locations[index - 1].latitude, let secondLong = locations[index - 1].longitude{
            
            GoogleUtils.findApproxTimeToTravel(firstLat: firstLat, firstLong: firstLong, secondLat: secondLat, secondLong: secondLong) { (googleDistance) in
                
                
                if let firstLocationDate = locations[index].lastSeen, let secondLocationDate = locations[index - 1].lastSeen{
                    
                    
                    let discardBool = self.discardLocationUsingGoogle(timeRequired: googleDistance, timeDifference: self.getTime(date: firstLocationDate) - self.getTime(date: secondLocationDate))
                    
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
        
        if 0.60 * Double(timeTaken) <= Double(timeDifference){
            return false
        }
        
        return true
        
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
    
    func convertToTimeSpendInLocation(firstDate: Date, secondDate: Date) -> String {
        
        let firstTime = LogicHelper.shared.getTime(date: firstDate)
        let secondTime = LogicHelper.shared.getTime(date: secondDate)
        
        let difference  = abs(firstTime - secondTime)
        
        let hour = Int(difference / 3600)
        let minute = Int((difference % 3600) / 60 )
        
        if hour == 0 {
            return "\(minute)min"
        }
        
        
        return "\(hour)hr \(minute)min "
        
    }
    
    func getTimeStamp() -> CLong{
        
        let time = Date().timeIntervalSince1970
        
        return CLong(time)
        
    }
    
    func getMinHour(date: Date) -> (Int, Int){
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
    
        return (hour,minutes)
        
    }
    
    
    func getLocationDate(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        
        
        let dateString = formatter.string(from: date)
        //
        //        let (hour, minute) = getMinHour(date: date)
        //
        //        let finalString = "\(hour)"
        return dateString
        //print(dateString)
    }
    
    
    func sortOnlyLocations(location: [LocationDataModel]) -> [LocationDataModel]{
        var finalLocations = location
        
        finalLocations.sort(by: { (first, second) -> Bool in
            
            
            if let firstDate = first.lastSeen , let secondDate = second.lastSeen{
                return  firstDate.compare(secondDate) == .orderedAscending
                
            }
            
            return false
        })
        
        return finalLocations
        
    }
    
    func sortGeoLocations(locations: [[LocationDataModel]]) -> [[LocationDataModel]]{
        
        var finalLocations = locations
        
        
        finalLocations.sort { (first, second) -> Bool in
            
            if let firstElement = first.first, let secondElement = second.first{
                
                if let firstDate = firstElement.lastSeen , let secondDate = secondElement.lastSeen{
                    return  firstDate.compare(secondDate) == .orderedAscending
                    
                }
                
                return false
                
                
            }
            
            return false
        }
        
        
        
        return finalLocations
        
    }
    
    func timeInSeconds() -> Int{
        
        let someDate = Date()
        
        // convert Date to TimeInterval (typealias for Double)
        let timeInterval = someDate.timeIntervalSince1970
        
        return Int(timeInterval)
    }
    
    
    func dashBoardDate(date : Date) -> String{
        // Day
        let calendar = Calendar.current
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: date)
        
        // Formate
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "MMM, yyyy"
        let newDate = dateFormate.string(from: date)
        
        var day  = "\(anchorComponents.day!)"
        switch (day) {
        case "1" , "21" , "31":
            day.append("st")
        case "2" , "22":
            day.append("nd")
        case "3" ,"23":
            day.append("rd")
        default:
            day.append("th")
        }
        return day + " " + newDate
    }
    
    
    func checkIfAllLocationsAreSame(locations: [[LocationDataModel]]) -> Bool{
        
        
        
        var firstCheckInId = ""
        if let firstCheckIn = locations.first{
            
            if let first = firstCheckIn.first{
                if let checkInId = first.geoTaggedLocations?.placeDetails?.placeId{
                    firstCheckInId = checkInId
                }else{
                    return false
                }
            }
            
        }
        for location in locations{
            
            if let firstLocation  = location.first{
                if firstLocation.geoTaggedLocations?.placeDetails?.placeId != firstCheckInId{
                    return false
                    
                }
            }
            
        }
        
        return true
        
    }
    
    
    func getStayTime(firstSeen: Date?, lastSeen: Date? ) -> String{
     
        
        var seen = ""
        
        
        if let startDate = firstSeen {
            seen.append(LogicHelper.shared.getLocationDate(date: startDate))
        }
        
        
        if let endDate = lastSeen{
        
            seen.append("-")
            seen.append(LogicHelper.shared.getLocationDate(date: endDate))
        }
        
    
        return seen
            
        
    }
        
        
    
}


public extension Foundation.Date {
    struct Date {
        static let formatterISO8601: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: Calendar.Identifier.iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
            return formatter
        }()
    }
    
    
    //    var startOfWeek: Date {
    //        let date = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
    //        let dslTimeOffset = NSTimeZone.local.daylightSavingTimeOffset(for: date)
    //        return date.addingTimeInterval(dslTimeOffset)
    //    }
    //
    //    var endOfWeek: Date {
    //        return Calendar.current.date(byAdding: .second, value: 604799, to: self.startOfWeek)!
    //    }
    
    var formattedISO8601: String { return Date.formatterISO8601.string(from: self) }
    
}


extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}

extension Date {
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}

extension String {
    var dateFromISO8601: Date? {
        return Formatter.iso8601.date(from: self)   // "Mar 22, 2017, 10:22 AM"
    }
}

