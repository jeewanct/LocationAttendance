//
//  AttendanceLog.swift
//  BluedolphinCloudSdk
//
//  Created by Raghvendra on 28/06/17.
//  Copyright © 2017 raremediacompany. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

open class BeaconData :Object,Mappable{
   public dynamic var lastSeen:Date?
   public dynamic var distance:String?
   public dynamic var rssi:String?
   public dynamic var major:String?
   public dynamic var minor:String?
   public dynamic var uuid:String?
   public dynamic var beaconId:String?
   public dynamic var latitude:String?
   public dynamic var longitude:String?
    public dynamic var beaconNumber:String?
    required convenience public init?(map : Map){
        self.init()
    }
    public func mapping(map: Map) {
        lastSeen    <- map["lastSeen"]
        distance <- map["distance"]
        rssi <- map["rssi"]
        major <- map["major"]
        minor    <- map["minor"]
        uuid <- map["uuid"]
        beaconId <- map["beaconId"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        beaconNumber <- map["beaconNumber"]
        
    }
    
}

open class AttendanceLog:Object,Mappable{
   public dynamic var dayofWeek:String?
   public dynamic var timeStamp:Date?
   public var beaconList = List<BeaconData>()
    override open static func primaryKey() -> String? {
        return "dayofWeek"
        
    }
    required convenience public init?(map : Map){
        self.init()
    }
    public func mapping(map: Map) {
        dayofWeek    <- map["dayofWeek"]
        timeStamp <- map["timeStamp"]
        beaconList <- map["beaconList"]
    }
    
    
}

open class AttendanceLogModel {
    
    class func getAttendanceLog(day:String){
        
        
        
    }
  public  class func updateAttendanceLog(beaconList:List<RMCBeacon>){
        let realm = try! Realm()
        var count = 0
        for beaconData:RMCBeacon in beaconList{
            guard let beconLastSeen = beaconData.lastSeen!.asDate else{
                print("Date Error")
                return
            }
            
            let weekDay = Calendar.current.component(.weekday, from: beconLastSeen)
            let weekOfYear = Calendar.current.component(.weekOfYear, from: beconLastSeen)
            if let dayOfWeekData = realm.objects(AttendanceLog.self).filter("dayofWeek = %@","\(weekDay)").first {
                if weekOfYear == Calendar.current.component(.weekOfYear, from: dayOfWeekData.timeStamp!){
                    
                    try! realm.write {
                        let newBeaconData = createBeaconData(beacon: beaconData,beaconNumber :count)
                        dayOfWeekData.beaconList.append(newBeaconData)
                        realm.add(dayOfWeekData,update:true)
                    }
                }else{
                    
                    try! realm.write {
                        realm.deleteObjectAndChilds(dayOfWeekData.beaconList)
                        let newbeaconList = List<BeaconData>()
                        let newBeaconData = createBeaconData(beacon: beaconData,beaconNumber :count)
                        newbeaconList.append(newBeaconData)
                        dayOfWeekData.beaconList = newbeaconList
                        dayOfWeekData.timeStamp = beconLastSeen
                        realm.add(dayOfWeekData,update:true)
                    }
                }
            }else {
                let dayOfWeekData = AttendanceLog()
                
                
                try! realm.write {
                    let newbeaconList = List<BeaconData>()
                    let newBeaconData = createBeaconData(beacon: beaconData,beaconNumber :count)
                    newbeaconList.append(newBeaconData)
                    dayOfWeekData.beaconList = newbeaconList
                    dayOfWeekData.timeStamp = beconLastSeen
                    dayOfWeekData.dayofWeek = "\(weekDay)"
                    realm.add(dayOfWeekData,update:true)
                }
                
            }
            count = count + 1
        }
        
    }
    
    class func createBeaconData(beacon:RMCBeacon,beaconNumber :Int)-> BeaconData{
            
            let beaconData = BeaconData()
            beaconData.beaconId = beacon.beaconId
            beaconData.distance = beacon.distance
            beaconData.latitude = String(CurrentLocation.coordinate.latitude)
            beaconData.longitude = String(CurrentLocation.coordinate.longitude)
            beaconData.lastSeen = beacon.lastSeen!.asDate
            beaconData.rssi = beacon.rssi
            beaconData.major = beacon.major
            beaconData.minor = beacon.minor
            beaconData.uuid = beacon.uuid
            beaconData.beaconNumber = "\(beaconNumber)"
            return beaconData
        }
        
}
