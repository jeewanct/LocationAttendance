//
//  GetClusteringFromServer.swift
//  bdPresence
//
//  Created by Jeevan Tiwari on 20/09/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import UIKit
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

class ClusterDataFromServer{

    
    class func showView(date: Date, notification: Notification) -> (headerData: [String]?, locationData: [UserDetailsDataModel]?, showFrom: ShowCheckinFrom)? {
    
        
        if let userNotification  = notification.userInfo as? [String: Any]{
            
            if let error = userNotification["status"] as? Bool{
                
                if !error{
                    //AlertsController.shared.displayAlertWithoutAction(whereToShow: self, message: "Something went wrong.")
                }else{
                    
                    UserDefaults.standard.set(Date(), forKey: "lastDashBoardUpdated")
                    
                    if let getDataIfAvail =  UserDayData.getLocationDataFromServer(date: date){
                        
                        if getDataIfAvail.count > 0{
                            let headerData = getHeaderData(locationData: getDataIfAvail)
                            return (headerData, getDataIfAvail, ShowCheckinFrom.Server)
                            //showDatabaseData(locationData: getDataIfAvail)
                            
                        }else{
                            return (nil, nil, ShowCheckinFrom.LocalDatabase)
                            //                            AlertsController.shared.displayAlertWithoutAction(whereToShow: self, message: "No Checkins!")
                          //  updateView()
                        }
                        
                    }else{
                        return (nil, nil, ShowCheckinFrom.LocalDatabase)
                        //AlertsController.shared.displayAlertWithoutAction(whereToShow: self, message: "No Checkins!")
                        
                    }
                }
                
            }
            
        }
    
    return nil
        
    }
    
    
    class func getHeaderData(locationData: [UserDetailsDataModel]) -> [String]{
        
        var headerData = [String]()
        if let firstData = locationData.last{
            if let startTime = firstData.startTime{
                
                headerData.append(LogicHelper.shared.getLocationDate(date: startTime))
                
                
            }else{
                headerData.append("")
            }
        }
        
        var distance = 0.0
        for location in locationData {
            
            if let distanceDb = location.distance{
                distance = distance + distanceDb 
            }
            
            
        }
        
        headerData.append(String(distance.roundToDecimal(2)))
        
        headerData.append(String(locationData.count))
        
        return headerData
        
        //mapView?.addMarkersInMap(allLocations: locationData)
        
        //delegate?.dataFromServer(locationData: locationData, headerData: headerData)
        
        
    }
    
    
    class func getDataFrom(date: Date,from: LocationDetailsScreenEnum) -> (headerData: [String]?, locationData: [UserDetailsDataModel]?, showIndicator: Bool)?{
    
        
        if let valueForDashBoard = UserDefaults.standard.value(forKey: "lastDashBoardUpdated") as? Date{

            if let getDataIfAvail =  UserDayData.getLocationDataFromServer(date: date){

                if getDataIfAvail.count > 0 {
                    
                    if from != LocationDetailsScreenEnum.historyScreen{
                        if Date().secondsFrom(valueForDashBoard) > 600{
                            GetClusteringFromServer.getDataOf(date: date)
                        }
                    }
                    
                    let headerData = getHeaderData(locationData: getDataIfAvail)
                    return (headerData, getDataIfAvail, false)
                    //showDatabaseData(locationData: getDataIfAvail)
                }else{
                    
                    GetClusteringFromServer.getDataOf(date: date)
                    return (nil, nil, true)
                }

            }else{
                GetClusteringFromServer.getDataOf(date: date)
                return (nil, nil, true)
               
            }
            
            

        }else{
            GetClusteringFromServer.getDataOf(date: date)
            return (nil, nil, true)
        }
        
        return nil
    }
    
//    func getDataOf(date: Date){
//        let convertedDate = date.toString(dateFormat: "YYYYMMdd")
//        let query = "{\"docId\":{\"$in\":[\"\(SDKSingleton.sharedInstance.organizationId)|\(SDKSingleton.sharedInstance.userId)|\(convertedDate)\"]}}"
//
//
//        if let getQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed){
//            GetCheckinsData.getClusterData(query: getQuery, date: date)
//        }
//
//    }
    
    class func convertDataToUserModel(locationData: [[LocationDataModel]]) -> [UserDetailsDataModel]{
        
        var user = [UserDetailsDataModel]()
        
            for location in locationData{
                
                let userData = UserDetailsDataModel()
                
                
                
                for locationDetail in location{
                    
                    
                    userData.startTime = locationDetail.lastSeen
                    
                    if let canGeoTag = UserDefaults.standard.value(forKey: "canGeoTag") as? Bool{
                        
                        if canGeoTag == true{
                            userData.canGeoTag = true
                        }else{
                            userData.canGeoTag = false
                        }
                    }
                    
                    
                    
                    if let geoTagged = locationDetail.geoTaggedLocations{
                        var lastSeenString = ""
                        userData.isGeoTagged = true
                        
                        var firstDate = Date()
                        if let lastGeoTaggedElement = location.first{
                            
                            if let lastSeen = lastGeoTaggedElement.lastSeen{
                                lastSeenString.append(LogicHelper.shared.getLocationDate(date: lastSeen))
                                firstDate = lastSeen
                            }
                            //userData.address = geoTagged.placeDetails?.address
                            
                        }
                        
                        if location.count > 1 {
                            if let lastGeoTaggedElement = location.last{
                                
                                lastSeenString.append("-")
                                if let lastSeen = lastGeoTaggedElement.lastSeen{
                                    lastSeenString.append(LogicHelper.shared.getLocationDate(date: lastSeen))
                                    let timeSpend = LogicHelper.shared.convertToTimeSpendInLocation(firstDate: firstDate, secondDate: lastSeen)
                                    
                                    let dateString = lastSeenString
                                    lastSeenString = timeSpend + " (\(dateString))"
                                    
                                    
                                }
                                //userData.address = geoTagged.placeDetails?.address
                                
                                
                                
                            }
                        }
                        userData.address = geoTagged.placeDetails?.address
                        userData.lastSeen =  lastSeenString
                        if let locationName = locationDetail.geoTaggedLocations?.locationName{
                            userData.geoLocationName = locationName
                        }
                        
                    }else{
                        
                        
                        userData.isGeoTagged = false
                        var firstDate = Date()
                        if location.count > 1{
                            var lastSeenString = ""
                            if let lastGeoTaggedElement = location.first{
                                
                                if let lastSeen = lastGeoTaggedElement.lastSeen{
                                    firstDate = lastSeen
                                    lastSeenString.append(LogicHelper.shared.getLocationDate(date: lastSeen))
                                }
                                
                                
                            }
                            
                            if location.count > 1{
                                if let lastGeoTaggedElement = location.last{
                                    
                                    lastSeenString.append("-")
                                    if let lastSeen = lastGeoTaggedElement.lastSeen{
                                        lastSeenString.append(LogicHelper.shared.getLocationDate(date: lastSeen))
                                        let timeSpend = LogicHelper.shared.convertToTimeSpendInLocation(firstDate: firstDate, secondDate: lastSeen)
                                        
                                        let dateString = lastSeenString
                                        lastSeenString = timeSpend + " (\(dateString))"
                                    }
                                    
                                    
                                    userData.lastSeen = lastSeenString
                                    
                                }
                            }
                        }else{
                            if let lastSeen = locationDetail.lastSeen{
                                userData.lastSeen = LogicHelper.shared.getLocationDate(date: lastSeen)
                            }
                        }
                        
                        if locationDetail.address != ""{
                            userData.address = locationDetail.address
                        }
                        
                        
                        if let lat = locationDetail.latitude, let long = locationDetail.longitude{
                            
                            if let latitude = CLLocationDegrees(lat), let longitude = CLLocationDegrees(long){
                                userData.cllLocation = CLLocation(latitude: latitude, longitude: longitude)
                                if let checkinId = locationDetail.checkinId{
                                    userData.checkInId = checkinId
                                }
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    
                }
                
                user.append(userData)
            }
        
        return user
    }
    
    
    
    class func checkIfAllLocationsAreSame(locations: [[LocationDataModel]]) -> Bool{
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
    
    class func checkIfNewDataCameFromServer(firstData: [UserDetailsDataModel], secondData: [UserDetailsDataModel]) -> Bool{
        
        if let firstElementPrevious = firstData.first, let secondElementPrevious = secondData.first{
            
            if firstElementPrevious.lastSeen == secondElementPrevious.lastSeen{
                return false
            }else{
                return true
            }
           
        }
        
        return true
        
        
    }
    
    
}


