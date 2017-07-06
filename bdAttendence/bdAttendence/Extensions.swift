//
//  Extensions.swift
//  bdAttendence
//
//  Created by Raghvendra on 19/04/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import Foundation
import UIKit

func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    //Swift.print(items[0], separator:separator, terminator: terminator)
}
extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
extension Date{
    
    func startOfWeek() -> Foundation.Date? {
        let comp :DateComponents = Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        
        return Calendar.current.date(from: comp)!
    }
    func dayOfWeekFull() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or capitalized(with: locale)
    }
}

public extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    public class func once(token: String, block:(Void)->Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}

enum NotificationType:String{
    case NewAssignment = "New-Assignment"
    case Welcome = "Welcome-Message"
    case UpdatedAssignment = "Updated-Assignment"
    case FirstCheckin
    case NoCheckin

}

enum LocalNotifcation:String{
    case Profile = "MyProfile"
    case Assignment = "MyAssignments"
    case VirtualBeacon = "VirtualBeacon"
    case Pushreceived = "Pushreceived"
    case NewAssignment = "NewAssignment"
    case Draft = "Draft"
    case BaseAnalytics
    case Attendance
    case Background
    case TimeUpdate
    case LocationUpdate
    case FirstBeaconCheckin
    case Dashboard
    case SystemDetail
}
enum ErrorMessage:String{
    case UserNotFound = "User not found with that phone number in system,Please contact your administrator"
    case InternalServer = "We are facing some internal issue please try again after sometime"
    case NotValidData = "Input you send is not valid"
    case emailError = "Please enter the valid email"
    case FECodeError = "Please enter the mobile number"
    case NetError = "Could not connect to internet please try again."
    case InvalidFECode = "Please enter valid mobile  number"
    case InvalidOtp = "Please enter valid otpcode"
}
enum NotificationMessage:String{
    case AttendanceMarked  = "We've marked you present for today. Have a wonderful day!"
}


