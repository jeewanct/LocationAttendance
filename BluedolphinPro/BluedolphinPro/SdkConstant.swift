//
//  SdkConstant.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 25/10/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation


//Live server

let APIURL = "https://lsjefx2kij.execute-api.ap-southeast-2.amazonaws.com/test"
enum ModuleUrl :String{
    case User = "/users/"
    case Checkin = "/checkins/organization/"
    case Oauth = "/oauth/token"
    case Assignment = "/assignments/organization/"
}

//local server

//let APIURL = "http://192.168.1.3:8709"

//test


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


