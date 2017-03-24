//
//  Extensions.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 02/11/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation
import RealmSwift


extension NSObject {
    class func fromJson(_ jsonInfo: NSDictionary) -> Self {
        let object = self.init()
        
        (object as NSObject).load(jsonInfo)
        
        return object
    }
    
    func load(_ jsonInfo: NSDictionary) {
        for (key, value) in jsonInfo {
            let keyName = key as! String
            
            if (responds(to: NSSelectorFromString(keyName))) {
                setValue(value, forKey: keyName)
            }
        }
    }
    
    func propertyNames() -> [String] {
        var names: [String] = []
        var count: UInt32 = 0
        let properties = class_copyPropertyList(classForCoder, &count)
        for i in 0 ..< Int(count) {
            let property: objc_property_t = properties![i]!
            let name: String = String(cString: property_getName(property))
            names.append(name)
        }
        free(properties)
        return names
    }
    
    func asJson() -> NSDictionary {
        var json:Dictionary<String, AnyObject> = [:]
        
        for name in propertyNames() {
            if let value: AnyObject = value(forKey: name) as AnyObject? {
                json[name] = value
            }
        }
        
        
        return json as NSDictionary
    }
    
}


extension Object {
    func toDictionary() -> NSDictionary {
        let properties = self.objectSchema.properties.map { $0.name }
        let dictionary = self.dictionaryWithValues(forKeys: properties)
        
        let mutabledic = NSMutableDictionary()
        mutabledic.setValuesForKeys(dictionary)
        
        for prop in self.objectSchema.properties as [Property]! {
            // find lists
            if let nestedObject = self[prop.name] as? Object {
                mutabledic.setValue(nestedObject.toDictionary(), forKey: prop.name)
            } else if let nestedListObject = self[prop.name] as? ListBase {
                var objects = [AnyObject]()
                for index in 0..<nestedListObject._rlmArray.count  {
                    let object = nestedListObject._rlmArray[index] as AnyObject
                    objects.append(object.toDictionary())
                }
                mutabledic.setObject(objects, forKey: prop.name as NSCopying)
            }
            
        }
        return mutabledic
    }
    
}


extension Foundation.Date {
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
    var formattedISO8601: String { return Date.formatterISO8601.string(from: self) }
    
    
    func hoursFrom(_ date:Foundation.Date) -> Int{
        return (Calendar.current as NSCalendar).components(NSCalendar.Unit.hour, from: date, to: self, options: []).hour!
    }
    func minuteFrom(_ date:Foundation.Date) -> Int{
        return (Calendar.current as NSCalendar).components(NSCalendar.Unit.minute, from: date, to: self, options: []).minute!
    }
    func timeStamp()->String {
        return "\(self.timeIntervalSince1970 * 1000)"
    }
    func offsetFrom(_ date:Foundation.Date) -> String {
        
        let dayHourMinuteSecond: NSCalendar.Unit = [.day, .hour, .minute, .second]
        let difference = (Calendar.current as NSCalendar).components(dayHourMinuteSecond, from: date, to: self, options: [])
        
        let seconds = "\(difference.second)s"
        let minutes = "\(difference.minute)m" + " " + seconds
        let hours = "\(difference.hour)h" + " " + minutes
        let days = "\(difference.day)d" + " " + hours
        
        if difference.day!    > 0 { return days }
        if difference.hour!   > 0 { return hours }
        if difference.minute! > 0 { return minutes }
        if difference.second! > 0 { return seconds }
        return ""
    }
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        return dateFormatter.string(from: self).capitalized
        // or capitalized(with: locale)
    }
    
    func dateDiff(_ date:Foundation.Date) -> String {
        let calendar: Calendar = Calendar.current
        
        let calendarUnits: NSCalendar.Unit = [.day, .hour, .minute, .second]
        let dateComponents = (calendar as NSCalendar).components(calendarUnits, from: date, to: self, options: [])
        
        // let weeks = abs(dateComponents.weekOfMonth)
        
        let days = abs(Int32(dateComponents.day!))
        let hours = abs(Int32(dateComponents.hour!))
        let min = abs(Int32(dateComponents.minute!))
        //let sec = abs(dateComponents.second)
        
        var timeAgo = ""
        
        //    if (sec > 0){
        //        if (sec > 1) {
        //            timeAgo = "\(sec) Seconds Ago"
        //        } else {
        //            timeAgo = "\(sec) Second Ago"
        //        }
        //    }
        if(days < 2) {
            if(hours<1){
                if (min > 0){
                    if (min > 1) {
                        timeAgo = "\(min) Minutes "
                    } else {
                        timeAgo = "\(min) Minute "
                    }
                }else if (min == 0){
                    timeAgo = "\(min) Minute "
                }
            }
        }
        
        if(hours > 0){
            if(days < 2) {
                if (hours > 1) {
                    timeAgo = "\(hours) Hours "
                } else {
                    timeAgo = "\(hours) Hour "
                }
            }
        }
        
        if (days > 0) {
            if (days > 1) {
                timeAgo = "\(days) Days "
            } else {
                timeAgo = "\(days) Day "
            }
        }
        //    if(weeks > 0){
        //        if (weeks > 1) {
        //            timeAgo = "\(weeks) Weeks Ago"
        //        } else {
        //            timeAgo = "\(weeks) Week Ago"
        //        }
        //    }
        
        print("timeAgo is===> \(timeAgo)")
        return timeAgo;
    }
    
    
    func dayStart() -> Foundation.Date? {
            let comp :DateComponents = Calendar.current.dateComponents([.year, .month,.day], from: self)
        
        //cal.firstWeekday = weekday ?? 1
        return Calendar.current.date(from: comp)!
    }
    
    func dayEnd() -> Foundation.Date? {
        var comp :DateComponents = Calendar.current.dateComponents([.year, .month,.day], from: self)
        
        comp.day = 1
        let date = Calendar.current.date(byAdding: comp, to: self.dayStart()!)!
        
        return date.addingTimeInterval(-1)
    }
    
    
}
extension Array {
    func chunk(_ chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map({ (startIndex) -> [Element] in
            let endIndex = (startIndex.advanced(by: chunkSize) > self.count) ? self.count-startIndex : chunkSize
            return Array(self[startIndex..<startIndex.advanced(by: endIndex)])
        })
    }
}


extension String {
    var asDate:Date! {
        let styler = DateFormatter()
        styler.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        styler.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return styler.date(from: self) as Date!
    }
    
    func asDateFormattedWith(format:String = "dd/MM/yyyy HH:mm") -> Date! {
        let styler = DateFormatter()
        styler.dateFormat = format
        styler.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        return styler.date(from: self)! as Date!
    }
    func asDateFormat(format:String = "dd/MM/yyyy HH:mm") -> Date! {
        let styler = DateFormatter()
        styler.dateFormat = format
        styler.timeZone = NSTimeZone.system
        return styler.date(from: self)! as Date!
    }
    
}

extension Date {
    var formatted:String {
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.system
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .medium
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter.string(from: self )
    }
    func formattedWith(format:String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = NSTimeZone.system
        return formatter.string(from: self )
    }
    func getDateFromCurrent(val:Int) ->String{
        
        return Calendar.current.date(byAdding: .day, value: val, to: self)!.formattedISO8601
    }
}

