//
//  DayCheckinList.swift
//  bdAttendence
//
//  Created by Raghvendra on 26/07/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import Foundation
import BluedolphinCloudSdk
import RealmSwift


class CheckinListData :NSObject{
    
    fileprivate var startTime:TimeInterval?
    fileprivate var endTime:TimeInterval?
    fileprivate var beaconsList:[BeaconData]
    fileprivate var distinctBeacons = Set<String>();
    
    init( startTime:TimeInterval,  endTime:TimeInterval, list :[BeaconData]) {
        self.startTime = startTime;
        self.endTime = endTime;
        self.beaconsList = list;
    }
    
    public func getStartTime() ->TimeInterval?{
        return startTime;
    }
    
    public func setStartTime(startTime:TimeInterval) {
        self.startTime = startTime;
    }
    
    public func getEndTime()->TimeInterval? {
        return endTime;
    }
    
    public func setEndTime( endTime:TimeInterval) {
        self.endTime = endTime;
    }
    
    public func getBeaconsList() ->[BeaconData] {
        return beaconsList;
    }
    
    public func setBeaconsList( beaconsList:[BeaconData]) {
        self.beaconsList = beaconsList;
    }
    
    public func getDistinctBeacons() ->Set<String>{
        return distinctBeacons;
    }
    
    public func setDistinctBeacons(distinctBeacons:Set<String>) {
        self.distinctBeacons = distinctBeacons;
    }
}

class CheckinListModel{
    class func getDataFromDb( date:Date)->[CheckinListData] {
        var data = [CheckinListData]();
        var calendar = Calendar.current;
        let realm = try! Realm()
        let weekDay = Calendar.current.component(.weekday, from: date)
        let weekOfYear = Calendar.current.component(.weekOfYear, from: date)
        
        
        if let attendanceLogForToday = realm.objects(AttendanceLog.self).filter("dayofWeek = %@","\(weekDay)").first {
            
            if weekOfYear == Calendar.current.component(.weekOfYear, from: attendanceLogForToday.timeStamp!){
                let beaconData = attendanceLogForToday.beaconList.sorted(byProperty: "lastSeen", ascending: true)
                    //.filter("beaconNumber = %@","0")
                print("============")
                //print(beaconData)
                
                var listData :CheckinListData!
                for i in 0..<beaconData.count{
                    let beaconObject = beaconData[i]
                    let  frequencyStartTime = beaconObject.lastSeen?.timeIntervalSince1970
                    var  frequencyEndTime = frequencyStartTime! + 1
                    if  listData == nil {
                        // initialize
                        var beaconList = [BeaconData]();
                        beaconList.append(beaconObject);
                        listData = CheckinListData(startTime: frequencyStartTime!, endTime: frequencyEndTime, list: beaconList)
                        var distictBeacons = listData.getDistinctBeacons()
                        distictBeacons.insert(beaconObject.beaconId!)
                        
                        listData.setDistinctBeacons(distinctBeacons: distictBeacons)
                        data.append(listData!);
                    } else {
                        // look ahead and set end time
                        if  i+1 < beaconData.count{
                            let nextBeacon = beaconData[i+1]
                            let nextBeaconTime = nextBeacon.lastSeen!.timeIntervalSince1970
                            let timeDifference = nextBeaconTime - frequencyStartTime!
                            
                            //getBeaconTimeDifference(timePrev: frequencyStartTime!, timeNext: nextBeaconTime )
                            
                            if (timeDifference < CHECK_IN_DURATION_TOLERANCE) {
                                // continue updating this group
                                frequencyEndTime = nextBeaconTime;
                                
                                listData.setEndTime(endTime: frequencyEndTime)
                                
                                var beconList = listData.getBeaconsList()
                                beconList.append(beaconObject);
                                
                                
                                listData.setBeaconsList(beaconsList: beconList)
                                
                                var distictBeacons = listData.getDistinctBeacons()
                                distictBeacons.insert(beaconObject.beaconId!)
                                
                                listData.setDistinctBeacons(distinctBeacons: distictBeacons)
                            } else {
                                // end this group
                                listData.setEndTime(endTime: frequencyEndTime);
                                var beconList = listData.getBeaconsList()
                                beconList.append(beaconObject);
                                
                                
                                listData.setBeaconsList(beaconsList: beconList)
                                
                                var distictBeacons = listData.getDistinctBeacons()
                                distictBeacons.insert(beaconObject.beaconId!)
                                
                                listData.setDistinctBeacons(distinctBeacons: distictBeacons)
                                //                                data.add(listData);
                                listData = nil;
                            }
                        } else {
                            listData.setEndTime(endTime: frequencyEndTime);
                            
                            var beconList = listData.getBeaconsList()
                            beconList.append(beaconObject);
                            
                            
                            listData.setBeaconsList(beaconsList: beconList)
                            var distictBeacons = listData.getDistinctBeacons()
                            distictBeacons.insert(beaconObject.beaconId!)
                            
                            listData.setDistinctBeacons(distinctBeacons: distictBeacons)
                            listData = nil;
                        }
                    }
                }
            } else {
                // data is stale/old so no data
            }
        } else {
            // no data recorded for current day
        }
        return  data
            //.reversed()
        
    }
    
    
    
}
