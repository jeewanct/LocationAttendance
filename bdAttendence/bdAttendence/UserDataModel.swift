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


func deleteAllData(){
    let realm = try! Realm()
    try! realm.write {
        realm.deleteAll()
    }
    if let bundle = Bundle.main.bundleIdentifier {
        UserDefaults.standard.removePersistentDomain(forName: bundle)
    }
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
                let beaconData = attendanceLogForToday.beaconList.sorted(byProperty: "lastSeen", ascending: true).filter("beaconNumber = %@","0").filter("lastSeen BETWEEN %@",[date.dayStart(),date.dayEnd()])
                
                
                
                print("============")
                //print(beaconData)
                for i in 0..<beaconData.count{
                    let beaconObject = beaconData[i]
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
