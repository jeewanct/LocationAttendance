//
//  Enums.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 21/11/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation


enum UserDefaultsKeys:String{
    case userId = "CurrentUserId"
    case organizationId = "CurrentOrganizationId"
    case accessToken =  "CurrentAccessToken"
    case deviceToken = "DeviceToken"
    case startDate = "START_DATE"
    
}
enum APIResult:String{
    case Success = "Success"
    case Fail = "Fail"
}
enum CheckinCategory:String{
    case Transient = "Transient"
    case NonTransient = "Non-Transient"
}

enum CheckinType:String{
    case PhotCheckin = "Photo"
    case Inprogress = "In-Progress"
    case Downloaded = "Downloaded"
    case Submitted = "Submitted"
    case Completed = "Completed"
    case Assigned = "Assigned"
    case Location = "Location"
}
enum ImageStatus:String{
    case Uploaded = "Uploaded"
    case NotUploaded = "NotUploaded"
}
enum AssignmentWork:String{
    case notes = "notes"
    case location = "location"
    case Photo = "imageUrl"
    case Signature = "signatureUrl"
}
