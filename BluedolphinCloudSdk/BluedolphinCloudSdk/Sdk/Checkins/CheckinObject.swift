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
    
    dynamic var latitude:String? = nil
    dynamic var longitude:String? = nil
    dynamic var accuracy:String? = nil
    dynamic var altitude:String? = nil
    dynamic var organizationId:String? = nil
    dynamic var checkinId:String? = nil
    dynamic var time:String? = nil
    dynamic var checkinCategory:String? = nil
    dynamic var checkinType:String? = nil
    dynamic var checkinDetails:String? = nil
    dynamic var imageUrl:String? = nil
    dynamic var assignmentId:String? = nil
    dynamic var imageName:String? = nil
    dynamic var relativeUrl:String? = nil
    dynamic var jobNumber:String? = nil
    var beaconProximity  = List<RMCBeacon>()
    
    
    override open static func primaryKey() -> String {
        return "checkinId"
        
    }
    
    //Impl. of Mappable protocol
    required convenience public  init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
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
        beaconProximity <- map["beaconProximity"]
    }
    
    
    
    
}
