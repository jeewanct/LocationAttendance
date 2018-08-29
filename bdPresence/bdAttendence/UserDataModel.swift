//
//  UserDataModel.swift
//  bdAttendence
//
//  Created by Raghvendra on 05/07/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import Foundation
import RealmSwift
import BluedolphinCloudSdk


class LocationDataModel{

    var lastSeen: Date?
    var accuracy: Double?
    var altitude: String?
    var userId: String?
    var organizationId: String?
    var checkinId: String?
    var latitude: String?
    var longitude: String?
    var details: String?
    var address: String?
    var geoTaggedLocations: GeoTagLocationModel?
    var isRepeated: Bool?
    var distance: Double?
    var isDiscarded: Bool?
    
}



class GraphData:NSObject {
    fileprivate var startTime:TimeInterval?
    fileprivate var endTime:TimeInterval?
    init(sTime:TimeInterval,eTime:TimeInterval){
        startTime = sTime
        endTime = eTime
    }
    func getStartTime()->TimeInterval{
        return startTime!
    }
    func getEndTime()->TimeInterval{
        return endTime!
    }
    
}

class FrequencyBarGraphData :NSObject  {
    fileprivate var startTime:TimeInterval?
    fileprivate var endTime:TimeInterval?
    fileprivate var elapsedTime:TimeInterval?
    fileprivate var lastCheckinTime:TimeInterval?
    fileprivate var lastCheckInAddress:String?
    
    
    var graphData = [GraphData]()
    
    public func getStartTime()->TimeInterval? {
        return startTime
    }
    
    public func setStartTime( startTime:TimeInterval) {
        self.startTime = startTime
    }
    
    public func getEndTime()->TimeInterval? {
        return endTime
    }
    
    public func setEndTime( endTime:TimeInterval) {
        self.endTime = endTime
    }
    
    public func getElapsedTime()->TimeInterval? {
        return elapsedTime ?? 0
    }
    
    public func setElapsedTime(elapsedTime:TimeInterval) {
        self.elapsedTime = elapsedTime
    }
    
    public func getLastCheckinTime() ->TimeInterval?{
        return lastCheckinTime 
    }
    
    public func setLastCheckinTime( lastCheckinTime:TimeInterval) {
        self.lastCheckinTime = lastCheckinTime;
    }
    
    public func getLastCheckInAddress()->String? {
        return lastCheckInAddress ?? " "
    }
    
    public func setLastCheckInAddress( lastCheckInAddress:String) {
        self.lastCheckInAddress = lastCheckInAddress;
    }
}


class UserDayData {
    class func getFrequencyBarData(date:Date) ->FrequencyBarGraphData{
        

        let calendar = Calendar.current
        let frequencyGraphData = FrequencyBarGraphData()
        let slotStartTime =  calendar.date(bySettingHour: officeStartHour, minute: officeStartMin, second: 0, of: date)!.timeIntervalSince1970
        let slotEndTime = calendar.date(bySettingHour: officeEndHour, minute: officeEndMin, second: 0, of: date)!.timeIntervalSince1970
        
        frequencyGraphData.setStartTime(startTime: slotStartTime)
        frequencyGraphData.setEndTime(endTime: slotEndTime)
        
        
        //let isToday =  Calendar
        let realm = try! Realm()
        let weekDay = Calendar.current.component(.weekday, from: date)
        let weekOfYear = Calendar.current.component(.weekOfYear, from: date)
        var lastCheckInRecorded :TimeInterval = 0;
        var elapsedTime:TimeInterval
            = 0;
        
        
        if let attendanceLogForToday = realm.objects(AttendanceLog.self).filter("dayofWeek = %@","\(weekDay)").first {
            
            if weekOfYear == Calendar.current.component(.weekOfYear, from: attendanceLogForToday.timeStamp!){
                let beaconData = attendanceLogForToday.beaconList.sorted(byKeyPath: "lastSeen", ascending: true).filter("beaconNumber = %@","0").filter("lastSeen BETWEEN %@",[date.dayStart(),date.dayEnd()])
                
                
                
                print("============")
                
                //print(beaconData)
                for i in 0..<beaconData.count{
                    let beaconObject = beaconData[i]
                    if i == 0{
                        if (beaconObject.lastSeen?.timeIntervalSince1970)! < slotStartTime{
                            let dateComponents =  calendar.dateComponents([.hour,.minute], from: beaconObject.lastSeen!)
                            let newStartTime = beaconObject.lastSeen?.dateAt(hours: dateComponents.hour!, minutes: 0)
//                            let newValue =  Calendar.current.date(byAdding: .hour, value: -1, to: newStartTime!)
                            frequencyGraphData.setStartTime(startTime: newStartTime!.timeIntervalSince1970)
                        }
                    }
                    if i == beaconData.count - 1 {
                        if (beaconObject.lastSeen?.timeIntervalSince1970)! > slotEndTime{
                            let dateComponents =  calendar.dateComponents([.hour,.minute], from: beaconObject.lastSeen!)
                            let newEndTime = beaconObject.lastSeen?.dateAt(hours: dateComponents.hour!, minutes: 0)
                            let newValue =  Calendar.current.date(byAdding: .hour, value: 1, to: newEndTime!)
                            frequencyGraphData.setEndTime(endTime: newValue!.timeIntervalSince1970)
                        }
                    }
                    let  frequencyStartTime = beaconObject.lastSeen?.timeIntervalSince1970
                    var  frequencyEndTime = frequencyStartTime
                    
                    if  i+1 < beaconData.count{
                        
                        let nextBeacon = beaconData[i+1]
                        let timeDifference = getBeaconTimeDifference(timePrev: frequencyStartTime!, timeNext: nextBeacon.lastSeen!.timeIntervalSince1970)
            
                        frequencyEndTime = frequencyStartTime! + timeDifference
                        
                    }
                    frequencyGraphData.graphData.append(GraphData(sTime: frequencyStartTime!, eTime: frequencyEndTime!))
                    if (lastCheckInRecorded != 0) {
                        // check how much time elapsed
                        let elapsedTimeNow = getElapsedTime(previousCheckInTime: lastCheckInRecorded, currentCheckInTime: frequencyStartTime!);
                        elapsedTime =  elapsedTime + elapsedTimeNow;
                    }
                    // if (isToday) {
                    frequencyGraphData.setLastCheckinTime(lastCheckinTime: frequencyStartTime!);
                    // }
                    
                    lastCheckInRecorded = frequencyStartTime!
                    
                    if (i == beaconData.count - 1) {
                        if let lastKnownBeacon =  realm.objects(VicinityBeacon.self).filter("major = %@ AND minor = %@ AND uuid = %@",beaconObject.major!,beaconObject.minor!,beaconObject.uuid!).first  {
                            
                            frequencyGraphData.setLastCheckInAddress(lastCheckInAddress: lastKnownBeacon.address!)
                            
                        }
                    }
                }
                frequencyGraphData.setElapsedTime(elapsedTime: elapsedTime);
                
            }else{
                
            }
        }
        
        
        return frequencyGraphData
        
    }
    
    
    
    class func getLocationData(date: Date) -> [LocationDataModel]?{
        
        let realm = try! Realm()
        let weekDay = Calendar.current.component(.weekday, from: date)
        let weekOfYear = Calendar.current.component(.weekOfYear, from: date)
        //let frequencyGraphData = FrequencyBarGraphData()

        if let attendanceLogForToday = realm.objects(LocationAttendanceLog.self).filter("dayofWeek = %@","\(weekDay)").first {
            if weekOfYear == Calendar.current.component(.weekOfYear, from: attendanceLogForToday.timeStamp!){
                
                //let locationData = attendanceLogForToday.locationList.sorted(byKeyPath: "latitude", ascending: true).filter("lastSeen BETWEEN %@",[date.dayStart(),date.dayEnd()])
                
                let locationData = attendanceLogForToday.locationList.filter("lastSeen BETWEEN %@",[date.dayStart(),date.dayEnd()])
                
                var locationDataArray = [LocationDataModel]()
                
                for index in 0..<locationData.count{
                 
                    let locationValue = LocationDataModel()
                    //frequencyGraphData.setLastCheckinTime(lastCheckinTime: (locationData[index].lastSeen?.timeIntervalSince1970)!);
                    if let accuracy = locationData[index].accuracy{
                        
                        if let accuracyData = Double(accuracy){
                            locationValue.accuracy = accuracyData
                        }
                    }
                    
                    locationValue.altitude = locationData[index].altitude
                    locationValue.checkinId = locationData[index].checkinId
                    locationValue.details = locationData[index].details
                    locationValue.lastSeen = locationData[index].lastSeen
                    locationValue.latitude = locationData[index].latitude
                    locationValue.longitude = locationData[index].longitude
                    locationValue.userId = locationData[index].userId
                    locationValue.organizationId = locationData[index].organizationId
                    locationValue.address = locationData[index].details
                    locationDataArray.append(locationValue)
                    
                }
                return locationDataArray
                
            }
            
        }
        
        return nil
        
    }
    
    
    class func getFrequencyLocationBarData(date:Date) ->FrequencyBarGraphData{
        
        
        let calendar = Calendar.current
        let frequencyGraphData = FrequencyBarGraphData()
        let slotStartTime =  calendar.date(bySettingHour: officeStartHour, minute: officeStartMin, second: 0, of: date)!.timeIntervalSince1970
        let slotEndTime = calendar.date(bySettingHour: officeEndHour, minute: officeEndMin, second: 0, of: date)!.timeIntervalSince1970
        
        frequencyGraphData.setStartTime(startTime: slotStartTime)
        frequencyGraphData.setEndTime(endTime: slotEndTime)
        
        //let isToday =  Calendar
        let realm = try! Realm()
        let weekDay = Calendar.current.component(.weekday, from: date)
        let weekOfYear = Calendar.current.component(.weekOfYear, from: date)
        var lastCheckInRecorded :TimeInterval = 0;
        var elapsedTime:TimeInterval
            = 0;
        
        
        if let attendanceLogForToday = realm.objects(LocationAttendanceLog.self).filter("dayofWeek = %@","\(weekDay)").first {
            
            if weekOfYear == Calendar.current.component(.weekOfYear, from: attendanceLogForToday.timeStamp!){
                let beaconData = attendanceLogForToday.locationList.sorted(byKeyPath: "lastSeen", ascending: true).filter("lastSeen BETWEEN %@",[date.dayStart(),date.dayEnd()])
                
                
                let latitudeData = attendanceLogForToday.locationList.sorted(byKeyPath: "latitude", ascending: true).filter("lastSeen BETWEEN %@",[date.dayStart(),date.dayEnd()])
                
                let longitueData = attendanceLogForToday.locationList.sorted(byKeyPath: "longitude", ascending: true).filter("lastSeen BETWEEN %@",[date.dayStart(),date.dayEnd()])
                
                frequencyGraphData.setLastCheckinTime(lastCheckinTime: (beaconData.last?.lastSeen?.timeIntervalSince1970)!)
                
                print("============")
             
                print(latitudeData)
                print(longitueData)
                
                for lat in 0..<latitudeData.count{
                    
                    
                }
                
                for long in 0..<longitueData.count{
                    
                    
                }
                
            }
            
        }
        return frequencyGraphData
        
    }
    
    class func getBeaconTimeDifference(timePrev:TimeInterval,timeNext:TimeInterval) -> TimeInterval{
        let elapsedTime = timeNext - timePrev;
        if (elapsedTime <= CHECK_IN_DURATION_TOLERANCE) {
            return elapsedTime + 100;
        }
        return 1;
    }
    
    class func getElapsedTime(previousCheckInTime:TimeInterval,currentCheckInTime:TimeInterval) -> TimeInterval {
        let elapsedTime = currentCheckInTime - previousCheckInTime;
        if (elapsedTime <= CHECK_IN_DURATION_TOLERANCE) {
            return elapsedTime;
        }
        return 0;
    }
}
