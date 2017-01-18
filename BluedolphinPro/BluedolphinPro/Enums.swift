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
    case FeCode = "Fecode"
    
}
enum APIResult:String{
    case Success = "Success"
    case InvalidCredentials = "InvalidCredentials"
    case InternalServer = "InternalServerError"
    case InvalidData = "InvalidData"
    case Fail = "Fail"
}
enum CheckinCategory:String{
    case Transient = "Transient"
    case NonTransient = "Non-Transient"
    case Data = "Data"
}

enum CheckinType:String{
    case PhotoCheckin = "Photo"
    case Inprogress = "In-Progress"
    case Downloaded = "Downloaded"
    case Submitted = "Submitted"
    case Completed = "Completed"
    case Assigned = "Assigned"
    case Location = "Location"
    case Data = "Data"
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
    case JobNumber = "jobNumber"
    case Submission = "submission"
    case Downloaded = "downloaded"
}
