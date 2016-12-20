//
//  CheckinObject.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 21/11/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation

import RealmSwift
import ObjectMapper


class RMCCheckin:Object,Mappable{
    
    dynamic var latitude:String?
    dynamic var longitude:String?
    dynamic var accuracy:String?
    dynamic var altitude:String?
    dynamic var organizationId:String?
    dynamic var checkinId:String?
    dynamic var time:String?
    dynamic var checkinCategory:String?
    dynamic var checkinType:String?
    dynamic var checkinDetails:String?
    dynamic var imageUrl:String?
    dynamic var assignmentId:String?
    
    
    dynamic var imageName:String?
    dynamic var relativeUrl:String?
    dynamic var jobNumber:String?
    override static func primaryKey() -> String? {
        return "checkinId"
        
    }
    
    //Impl. of Mappable protocol
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        latitude    <- map["latitude"]
        longitude <- map["longitude"]
        accuracy <- map["accuracy"]
        altitude <- map["altitude"]
        organizationId    <- map["organizationId"]
        checkinId <- map["checkinId"]
        time <- map["time"]
        checkinCategory <- map["checkinCategory"]
        checkinType <- map["checkinType"]
        checkinDetails <- map["checkinDetails"]
        imageUrl <- map["imageUrl"]
        assignmentId <- map["assignmentId"]
        imageName <- map["imageName"]
        relativeUrl <- map["relativeUrl"]
        jobNumber <- map["jobNumber"]
    }
    
    
    
    
}
