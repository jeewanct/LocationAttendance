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
    
    init(object:NSDictionary){
        if let value = object["startMin"] as? String{
            startMin = Int(value) ?? 0
        }
        if let value = object["startHr"] as? String{
            startHr = Int(value) ?? 8
        }
        if let value = object["endHr"] as? String{
            endHr = Int(value) ?? 21
        }
        if let value = object["endMin"] as? String{
            endMin = Int(value) ?? 0
            
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
    
class ShiftHandling {
    func getShiftDetail()->(Int,Int,Int,Int,Int){
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
    
    func checkUserShiftStatus(time:Date){
    
        
    }
}
