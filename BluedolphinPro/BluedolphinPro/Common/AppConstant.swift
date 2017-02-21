//
//  AppConstant.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 24/11/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation
import  UIKit


let AppVersion = "1.0"
let deviceType = "ios"

let TARGET_DEVICE_SIZE = CGSize(width: 414,height: 736)
struct ScreenConstant {
    static var width     = UIScreen.main.bounds.size.width
    static var height    = UIScreen.main.bounds.size.height
    static var originX   = UIScreen.main.bounds.origin.x
    static var originY   = UIScreen.main.bounds.origin.y
}
struct GOOGLE_MAPS{
    static var ApiKey = "AIzaSyCv2aXPsTEYdWG2q3IM9neN690s4JFxe4A"
    //static var Serverkey
}

struct APPCOLOR {
    static var baseColor = UIColor(red: 64/255, green: 116/255, blue: 186/255, alpha: 1)
    static var selectionColor = UIColor(red: 248/255, green: 156/255, blue: 28/255, alpha: 1)
    static var headerColor = UIColor(red: 33/255, green: 64/255, blue: 140/255, alpha: 1)
    static var navColor = UIColor(red: 116/255, green: 169/255, blue: 219/255, alpha: 1)
}

enum LocalNotifcation:String{
    case Profile = "MyProfile"
    case Assignment = "MyAssignments"
    case Pushreceived = "Pushreceived"
    case NewAssignment = "NewAssignment"
}
enum NotificationType:String{
    case NewAssignment = "New-Assignment"
    case Welcome = "Welcome-Message"
    case UpdatedAssignment = "Updated-Assignment"
}

enum SortEnum:String{
    case StartDateAsc
    case StartDateDes
    case EndDateAsc
    case EndDateDes
    case ClearSort
}

enum SelfAssignmentError:String{
    case placeNameError = "Please enter Place name"
    case addressError = "Please enter address"
    case contactPersonError = "Please enter contact Person"
    case contactNumberError = "Please enter contact Number"
    case mobileInvalid = "Please enter valid mobile number"
    case emailError = "Please enter valid email "
    case startdateError = "Please enter Assignment Start Date"
    case starttimeError = "Assignment Start Time cannot be less than Current Time"
    case enddateError = "Please enter Assignment End Date"
    case endtimeError = "Assignment End Time cannot be less than Current Time"
}

