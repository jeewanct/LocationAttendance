//
//  ShiftHandling.swift
//  BluedolphinCloudSdk
//
//  Created by Raghvendra on 01/09/17.
//  Copyright © 2017 raremediacompany. All rights reserved.
//

import Foundation

class UserShift:NSObject{
    var startMin:Int = 0
    var startHr:Int = 8
    var endHr:Int = 20
    var endMin:Int = 0
    var duration:Int = 43200
    var startTime = Date()
    var endTime = Date()
    var shiftId = String()
    
    init(object:NSDictionary){
        if let value = object["start_min"] as? String{
            startMin = Int(value) ?? 0
        }
        if let value = object["start_hour"] as? String{
            startHr = Int(value) ?? 8
        }
        if let value = object["end_hour"] as? String{
            endHr = Int(value) ?? 21
        }
        if let value = object["end_min"] as? String{
            endMin = Int(value) ?? 0
            
        }
        if let value = object["objectId"] as? String{
            shiftId = value
            
        }
        startTime = Date().dateAt(hours: startHr, minutes: startMin)!
        if endHr > startHr{
            endTime =  Date().dateAt(hours: endHr, minutes: endMin)!
        }else{
            let nextDay =  Calendar.current.date(byAdding: .day, value: 1, to: Date())!
            endTime = nextDay.dateAt(hours: endHr, minutes: endMin)!
        }
        
        duration = Int(endTime.timeIntervalSince(startTime))
        
    }
    
}
open class ShiftHandling {
    public class func getShiftDetail()->(Int,Int,Int,Int,Int){
        var officeStartHour = 9
        var officeStartMin = 0
        var officeEndHour = 21
        var officeEndMin = 0
        var shifDuration = 43200
        if let value = UserDefaults.standard.value(forKey: UserDefaultsKeys.BDShiftStartMin.rawValue) as? Int{
            officeStartMin = value
        }
        if let value = UserDefaults.standard.value(forKey: UserDefaultsKeys.BDShiftStartHour.rawValue) as? Int{
            officeStartHour = value
        }
        if let value = UserDefaults.standard.value(forKey: UserDefaultsKeys.BDShiftEndMin.rawValue) as? Int{
            officeEndMin = value
        }
        if let value = UserDefaults.standard.value(forKey: UserDefaultsKeys.BDShiftEndHour.rawValue) as? Int{
            officeEndHour = value
        }
        if let value = UserDefaults.standard.value(forKey: UserDefaultsKeys.BDShiftDuration.rawValue) as? Int{
            shifDuration = value
        }
        return (officeStartHour,officeStartMin,officeEndHour,officeEndMin,shifDuration)
    }
    
    public class func checkUserShiftStatus(currentTime:Date,broadcastOn:Bool = true)->Bool{
        let value = getShiftDetail()
        let todaysDate = Date()
        
        let startTime = todaysDate.dateAt(hours: value.0, minutes: value.1)!
        var endTime = startTime.addingTimeInterval(TimeInterval(exactly: value.4)!)
        if value.0 < value.2 {
            endTime = Calendar.current.date(byAdding: .day, value: 1, to: endTime)!
        }
        if currentTime < startTime && currentTime > endTime {
            let maxLapseTime = endTime.addingTimeInterval(3600)
            if currentTime > maxLapseTime {
                if let lastBeaconCheckinTime = UserDefaults.standard.value(forKey: UserDefaultsKeys.LastBeaconCheckinTime.rawValue) as? Date {
                    if lastBeaconCheckinTime.secondsFrom(currentTime) >= 3600 {
                        if broadcastOn{
                             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShiftEnded"), object: self, userInfo: nil)
                        }
                      
                       return true
                        
                    }
                }
                
            }
        }
        return false
 
    }
}
    

