//
//  DraftObject.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 16/03/17.
//  Copyright © 2017 raremediacompany. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

open class DraftAssignmentObject:Object,Mappable{
    dynamic var assignmentId:String?
    dynamic var latitude:String?
    dynamic var longitude:String?
    dynamic var altitude:String?
    dynamic  var accuracy:String?
    dynamic  var assignmentDeadline:String?
    dynamic var assignmentStartTime:String?
    dynamic var assignmentAddress:String?
    dynamic var contactPerson:String?
    dynamic var mobile:String?
    dynamic var email:String?
    dynamic var draftDescription:String?
    dynamic var jobNumber:String?
    override open static func primaryKey() -> String? {
        return "assignmentId"
        
    }
    
    //Impl. of Mappable protocol
    required convenience public init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        latitude    <- map["latitude"]
        longitude <- map["longitude"]
        accuracy <- map["accuracy"]
        altitude <- map["altitude"]
        contactPerson    <- map["contactPerson"]
        mobile <- map["mobile"]
        assignmentDeadline <- map["assignmentDeadline"]
        assignmentId <- map["assignmentId"]
        email <- map["email"]
        
        assignmentStartTime <- map["assignmentStartTime"]
        assignmentAddress <- map["assignmentAddress"]
        draftDescription <- map["draftDescription"]
        jobNumber <- map["jobNumber"]
    }
    
    
    
    
}
