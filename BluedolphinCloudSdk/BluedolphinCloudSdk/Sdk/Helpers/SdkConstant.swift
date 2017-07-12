//
//  SdkConstant.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 25/10/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation


var AppVersion = "1.0"
let deviceType = "ios"
var CheckinInterVal = 300
var CheckinGap = 1800


enum ModuleUrl :String{
    case User = "user/"
    case Checkin = "/checkin"
    case Oauth = "auth/"
    case Organisation = "organisation/"
    case Assignment = "/assignment"
    case UpdatePassword = "user/updateotp"
    case GetOtp = "user/otp?mobile="
    
}




//let APIURL = "https://0uvkmcic37.execute-api.ap-south-1.amazonaws.com/bd/live/"
//Staging server 


var APIURL = "https://dqxr67yajg.execute-api.ap-southeast-1.amazonaws.com/bd/staging/"


//dev Server

//let APIURL = "https://kxjakkoxj3.execute-api.ap-southeast-1.amazonaws.com/bd/dev/"





//local server

//let APIURL = "http://192.168.1.3:8709"

