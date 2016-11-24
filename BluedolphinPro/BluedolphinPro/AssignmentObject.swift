//
//  AssignmentObject.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 23/11/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation

import RealmSwift
import ObjectMapper


class AssignmentObject:Object,Mappable{
    var assignmentId:String?
    var assigneeId:String?
    var status:String?
    var latitude:String?
    var longitude:String?
    var altitude:String?
    var accuracy:String?
    var organizationId:String?
    var assignmentDeadline:String?
    var assignmentDetails:String?
    override static func primaryKey() -> String? {
        return "assignmentId"
        
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
        assignmentId <- map["assignmentId"]
        assignmentDeadline <- map["assignmentDeadline"]
        assigneeId <- map["assigneeId"]
        status <- map["status"]
        assignmentDetails <- map["assignmentDetails"]
    }
    
    
    
    
}


class RMCAssignmentObject :Object {
    dynamic var assignmentId:String?
    dynamic var addedOn:String?
    dynamic var time:String?
    dynamic var updatedOn:String?
    dynamic var assignmentDetails:String?
    dynamic var statusLog:String?
    var assigneeData = List<RMCAssignee>()
    dynamic var assignerData:RMCAssignee?
    dynamic var location:RMCLocation?
    
    required convenience init?(map: Map) {
        self.init()
    }

}


class RMCAssignee :Object{
    dynamic var userId:String?;
    dynamic var organisationId:String?;
}

class RMCLocation:Object{
    
}

