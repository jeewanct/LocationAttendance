//
//  LocationAttendanceLog.swift
//  BluedolphinCloudSdk
//
//  Created by Raghvendra on 03/10/17.
//  Copyright © 2017 raremediacompany. All rights reserved.
//

import Foundation


import Foundation
import RealmSwift
import ObjectMapper

open class LocationData :Object,Mappable{
    public dynamic var lastSeen:Date? = nil
    public dynamic var accuracy:String? = nil
    public dynamic var altitude:String? = nil
    public dynamic var userId:String? = nil
    public dynamic var organizationId:String? = nil
    public dynamic var checkinId:String? = nil
    public dynamic var latitude:String? = nil
    public dynamic var longitude:String? = nil
    public dynamic var details:String? = nil
    

    required convenience public init?(map : Map){
        self.init()
    }
    public func mapping(map: Map) {
        lastSeen    <- map["lastSeen"]
        accuracy <- map["accuracy"]
        altitude <- map["altitude"]
        userId <- map["userId"]
        organizationId    <- map["organizationId"]
        checkinId <- map["checkinId"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        details <- map["details"]
        
    }
    
}

open class LocationAttendanceLog:Object,Mappable{
    public dynamic var dayofWeek:String? = nil
    public dynamic var timeStamp:Date? = nil
    public var locationList = List<LocationData>()
    override open static func primaryKey() -> String? {
        return "dayofWeek"
        
    }
    required convenience public init?(map : Map){
        self.init()
    }
    public func mapping(map: Map) {
        dayofWeek    <- map["dayofWeek"]
        timeStamp <- map["timeStamp"]
        locationList <- map["locationList"]
    }
    
    
}

 class LocationAttendanceLogModel {
    

      class func updateAttendanceLog(checkinData:RMCCheckin){
        let realm = try! Realm()
        let lastSeen = getCurrentDate()
        
            let weekDay = Calendar.current.component(.weekday, from: lastSeen)
            let weekOfYear = Calendar.current.component(.weekOfYear, from:  lastSeen)
            if let dayOfWeekData = realm.objects(LocationAttendanceLog.self).filter("dayofWeek = %@","\(weekDay)").first {
                if weekOfYear == Calendar.current.component(.weekOfYear, from: dayOfWeekData.timeStamp!){
                    
                    try! realm.write {
                        let newLocationData = createLocationData(checkin: checkinData)
                        dayOfWeekData.locationList.append(newLocationData)
                        realm.add(dayOfWeekData,update:true)
                    }
                }else{
                    
                    try! realm.write {
                        
                        realm.delete(dayOfWeekData.locationList)
                        realm.delete(dayOfWeekData)
                        let dayOfWeekData = LocationAttendanceLog()
                        let newLocationList = List<LocationData>()
                        let newLocationData = createLocationData(checkin: checkinData)
                        newLocationList.append(newLocationData)
                        dayOfWeekData.locationList = newLocationList
                        dayOfWeekData.timeStamp = lastSeen
                        dayOfWeekData.dayofWeek = "\(weekDay)"
                        realm.add(dayOfWeekData,update:true)
                    }
                }
            }else {
                let dayOfWeekData = LocationAttendanceLog()
                
                
                try! realm.write {
                    let newLocationList = List<LocationData>()
                    let newLocationData = createLocationData(checkin: checkinData)
                    newLocationList.append(newLocationData)
                    dayOfWeekData.locationList = newLocationList
                    dayOfWeekData.timeStamp = lastSeen
                    dayOfWeekData.dayofWeek = "\(weekDay)"
                    realm.add(dayOfWeekData,update:true)
                }
                
            }
        }
        
    
    
    class func createLocationData(checkin:RMCCheckin)-> LocationData{
       
        let locationData = LocationData()
        locationData.checkinId = checkin.checkinId
        locationData.userId = SDKSingleton.sharedInstance.userId
        locationData.organizationId = checkin.organizationId
        locationData.accuracy = checkin.accuracy
        locationData.altitude = checkin.altitude
        locationData.details = ""
        locationData.lastSeen = getCurrentDate()
        locationData.latitude = checkin.latitude
        locationData.longitude = checkin.longitude

        return locationData
    }
    
}
