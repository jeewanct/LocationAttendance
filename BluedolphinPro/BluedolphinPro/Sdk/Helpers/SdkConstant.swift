//
//  SdkConstant.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 25/10/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation


//Live server

//local server

//let APIURL = "http://192.168.1.3:8709"


//Staging server 


let APIURL = "https://dqxr67yajg.execute-api.ap-southeast-1.amazonaws.com/bd/staging/"
//dev Server

//let APIURL = "https://kxjakkoxj3.execute-api.ap-southeast-1.amazonaws.com/bd/dev/"
enum ModuleUrl :String{
    case User = "user/"
    case Checkin = "/checkin"
    case Oauth = "auth/"
    case Organisation = "organisation/"
    case Assignment = "/assignment"
    case UpdatePassword = "user/updateotp"
    case GetOtp = "user/otp?mobile="
}



//let APIURL = "http://bluedolphinapi-dev.ap-south-1.elasticbeanstalk.com/"
//
////"http://bluedolphinapi.ap-south-1.elasticbeanstalk.com"
////
//enum ModuleUrl :String{
//    case User = "/Users"
//    case Checkin = "/Checkins/Organization/"
//    case Oauth = "/Oauth2/Token"
//    case Assignment = "Assignments/Organization/"
//}


