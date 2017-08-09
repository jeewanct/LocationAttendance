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
    case startDate = "START_DATE"
    case FeCode = "Fecode"
    case LastSyncTime
    case LastCheckinTime
    case LastBeaconCheckinTime
    case LastBeaconScanned
    case TotalTime
 
}
public enum APIResult:String{
    case Success = "Success"
    case InvalidCredentials = "InvalidCredentials"
    case InternalServer = "InternalServerError"
    case InvalidData = "InvalidData"
    case Fail = "Fail"
    case UserInteractionRequired
}
public enum CheckinCategory:String{
    case Transient = "Transient"
    case NonTransient = "Non-Transient"
    case Data = "Data"
}

public enum CheckinType:String{
    case PhotoCheckin = "Photo"
    case Inprogress = "In-Progress"
    case Downloaded = "Downloaded"
    case Submitted = "Submitted"
    case Completed = "Completed"
    case Assigned = "Assigned"
    case Location = "Location"
    case Data = "Data"
    case Beacon = "Beacon"
}
public enum ImageStatus:String{
    case Uploaded = "Uploaded"
    case NotUploaded = "NotUploaded"
}
public enum AssignmentWork:String{
    case notes = "notes"
    case location = "location"
    case Photo = "imageUrl"
    case Signature = "signatureUrl"
    case JobNumber = "jobNumber"
    case Submission = "submission"
    case Downloaded = "downloaded"
    case AppVersion = "versionName"
    case UserAgent = "userAgent"
    case Created = "Created"
    case batteryLevel
}
