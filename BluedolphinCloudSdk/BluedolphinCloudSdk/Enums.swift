//
//  Enums.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 21/11/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation


public enum UserDefaultsKeys:String{
    case userId = "CurrentUserId"
    case organizationId = "CurrentOrganizationId"
    case accessToken =  "CurrentAccessToken"
    case deviceToken = "DeviceToken"
    
}
public enum APIResult:String{
    case Success = "Success"
    case Fail = "Fail"
}
public enum CheckinCategory:String{
    case Transient = "Transient"
    case NonTransient = "Non-Transient"
}

public enum CheckinType:String{
    case PhotCheckin = "Photo"
    case Inprogress = "In Progress"
    case Downloaded = "Downloaded"
    case Submitted = "Submitted"
    case Completed = "Completed"
    case Assigned = "Assigned"
    case Location = "Location"
}
