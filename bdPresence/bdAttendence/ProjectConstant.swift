//
//  ProjectConstant.swift
//  bdAttendence
//
//  Created by Raghvendra on 17/05/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import Foundation
import UIKit

var APPVERSION = "1.3.1"
var appIdentifier = "com.raremedia.bdAttendence"
let AppstoreURL = "https://itunes.apple.com/in/app/bdattendance/id1233146566?mt=8"
let supportEmail = "support@raremediacompany.in"
let supportAddress = "G-84 Outer Circle, Connaught Place, Delhi"
let supportContactNumber = "+911141561260"

let CHECK_IN_DURATION_TOLERANCE:Double = 60 * 60
let VALID_CHECKIN_DURATION :Double = 5*60
var officeStartHour = 9
var officeStartMin = 0
var officeEndHour = 21
var officeEndMin = 0

enum CheckinDetailKeys:String{
    case userInteraction
    case swipeUp
    case swipeDown
    case bluetoothStatus
    case gpsStatus
    case AppTerminated
    
}

enum SideMenuOptions:String{
    case MyDashboard = "My Dashboard"
    case SystemDetail = "System Detail"
    case ThisWeek = "This Week"
    case Transmit
    case ContactUs = "Contact Us"
}

enum NotificationType:String{
    case NewAssignment = "New-Assignment"
    case Welcome = "Welcome-Message"
    case UpdatedAssignment = "Updated-Assignment"
    case FirstCheckin
    case NoCheckin
    case testNotification
    case AttendanceMarked
    case shiftStartReminder
    case shiftActiveUserInactive
    case userInactiveAfterShiftEnd
    case MultipleLogout = "Multiple-Logout"
    
}
enum ProjectUserDefaultsKeys:String{
    case startDayTime
}
enum LocalNotifcation:String{
    case Profile = "MyProfile"
    case Assignment = "MyAssignments"
    case VirtualBeacon
    case Pushreceived
    case NewAssignment
    case Draft
    case BaseAnalytics
    case Attendance
    case Background
    case TimeUpdate
    case LocationUpdate
    case FirstBeaconCheckin
    case Dashboard
    case SystemDetail
    case CheckoutScreen
    case CheckinScreen
    case DayCheckinScreen
    case ThisWeek
    case ContactUs
    case ShiftEnded
}
enum StoryboardIdentifier:String{
    case myprofile
    case contactUs
    case history
    case VirtualBeacon
    case systemDetail
    case dashboard
}
enum ErrorMessage:String{
    case UserNotFound = "Number not found. Contact admin"
    case InternalServer = "We are facing some internal issue please try again after sometime"
    case NotValidData = "Input you send is not valid"
    case emailError = "Please enter the valid email"
    case FECodeError = "Please enter the mobile number"
    case NetError = "Could not connect to internet please try again."
    case InvalidFECode = "Please enter valid mobile  number"
    case InvalidOtp = "Please enter valid 6 digit OTP code"
    case MultipleUser = "You are already logged into some other device. Do you wish to log out from other device and continue with this device?"
}
enum NotificationMessage:String{
    case AttendanceMarked  = "We've marked you present for today. Have a wonderful day! "
}


struct APPFONT {
//   static var regular = UIFont(name: "SourceSansPro-Regular", size: 15.0)
//   static var semibold = UIFont(name: "SourceSansPro-Semibold", size: 17.0)
//   static var black = UIFont(name: "SourceSansPro-Black", size: 17.0)
    static var OTPBODY = UIFont(name: "SourceSansPro-Regular", size: 30.0)
    static var OTPACTION = UIFont(name: "SourceSansPro-Semibold", size: 15.0)
    static var OTPCONFIRMATION = UIFont(name: "SourceSansPro-Regular", size: 18.0)
    static var HELPTEXT = UIFont(name: "SourceSansPro-Regular", size: 15.0)
    static var HELPTEXTBUTTON = UIFont(name: "SourceSansPro-ExtraLight", size: 24.0)
     static var BODYTEXT =  UIFont(name: "SourceSansPro-Regular", size: 24.0)
    static var PERMISSIONHEADER =  UIFont(name: "SourceSansPro-Regular", size: 24.0)
    static var PERMISSIONBODY =  UIFont(name: "SourceSansPro-Regular", size: 18.0)
    static var PERMISSIONENABLED =  UIFont(name: "SourceSansPro-Regular", size: 24.0)
    static var PERMISSIONDISABLED =  UIFont(name: "SourceSansPro-ExtraLight", size: 24.0)
    static var DAYHEADER =  UIFont(name: "SourceSansPro-ExtraLight", size: 18.0)
    static var DAYHOUR =  UIFont(name: "SourceSansPro-Semibold", size: 30.0)
    static var DAYHOURTEXT =  UIFont(name: "SourceSansPro-Semibold", size: 15.0)
    static var CHARTINFO =  UIFont(name: "SourceSansPro-Regular", size: 12.0)
    static var FOOTERBODY =  UIFont(name: "SourceSansPro-Regular", size: 18.0)
    static var MENUTEXT =  UIFont(name: "SourceSansPro-Light", size: 15.0)
    static var VERSIONTEXT = UIFont(name: "SourceSansPro-Regular", size: 12.0)
    static var DAYCHAR = UIFont(name: "SourceSansPro-Semibold", size: 11.0)
    static var PROFILEHEADER =  UIFont(name: "SourceSansPro-Light", size: 24.0)
    static var MESSAGEHELPTEXT = UIFont(name: "SourceSansPro-Regular", size: 16.0)
}


struct APPColor {
    static var black = UIColor(hex: "414042")
    static var blue = UIColor(hex: "74a8da")
    static var green = UIColor(hex: "77c5c9")
    static var yellow = UIColor(hex: "fff200")
    static var GreenGradient =  UIColor(hex: "80edf7")
    static var BlueGradient = UIColor(hex: "4a7397")
    static var newGreen = UIColor(hex: "60c19e")
    static var newGray = UIColor(hex: "e7e7e7")
    static var newYellow = UIColor(hex: "fdfab0")
    static var llGray = UIColor(hex: "00b8dd")
    static var llYellow = UIColor(hex: "00dd6e")

    static var greenGradient = UIColor(red: 107.0/255.0, green: 195.0/255.0, blue: 213.0/255.0, alpha: 1.0)
    static var blueGradient = UIColor(red: 112.0/255.0, green: 179.0/255.0, blue: 215.0/255.0, alpha: 1.0)

}
