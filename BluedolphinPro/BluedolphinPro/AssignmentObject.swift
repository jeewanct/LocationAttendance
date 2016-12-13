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
class ArrayTransform<T:RealmSwift.Object> : TransformType where T:Mappable {
    typealias Object = List<T>
    typealias JSON = Array<AnyObject>
    
    func transformFromJSON(_ value: Any?) -> List<T>? {
        let realmList = List<T>()
        
        if let jsonArray = value as? Array<Any> {
            for item in jsonArray {
                if let realmModel = Mapper<T>().map(JSONObject: item) {
                    realmList.append(realmModel)
                }
            }
        }
        
        return realmList
    }
    
    func transformToJSON(_ value: List<T>?) -> Array<AnyObject>? {
        
        guard let realmList = value, realmList.count > 0 else { return nil }
        
        var resultArray = Array<T>()
        
        for entry in realmList {
            resultArray.append(entry)
        }
        
        return resultArray
    }
}


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


class RMCAssignmentObject :Object,Mappable {
    dynamic var assignmentId:String?
    dynamic var addedOn:String?
    dynamic var time:String?
    dynamic var updatedOn:String?
    dynamic var assignmentDetails:String?
    dynamic var statusLog:String?
    dynamic var assignmentDeadline:String?
    dynamic var assignmentStartTime:String?
    var assigneeData = List<RMCAssignee>()
    dynamic var assignerData:RMCAssignee?
    dynamic var location:RMCLocation?
    dynamic var status:String?
    var bookmarked:Bool?
    override static func primaryKey() -> String? {
        return "assignmentId"
        
    }
    required convenience init?(map: Map) {
        self.init()
    }
    func mapping(map: Map) {
        addedOn    <- map["addedOn"]
        time <- map["time"]
        updatedOn <- map["updatedOn"]
        statusLog <- map["statusLog"]
        assigneeData    <- (map["assigneeData"],ArrayTransform<RMCAssignee>())
        assignmentId <- map["assignmentId"]
        assignerData <- map["assignerData"]
        location <- map["location"]
        assignmentDetails <- map["assignmentDetails"]
        assignmentDeadline <- map["assignmentDeadline"]
        assignmentStartTime <- map["assignmentStartTime"]
        status <- map["status"]
        bookmarked <- map["bookmark"]
    }

}


class RMCAssignee :Object,Mappable{
    dynamic var userId:String?;
    dynamic var organizationId:String?;
    
    required convenience init?(map: Map) {
        self.init()
    }
//    override static func primaryKey() -> String? {
//        return "userId"
//        
//    }
    func mapping(map: Map) {
        userId    <- map["userId"]
        organizationId <- map["organizationId"]
    }
}

class RMCLocation:Object{
    var latitude:String?
    var longitude:String?
    var altitude:String?
    var accuracy:String?
    required convenience init?(map: Map) {
        self.init()
    }
    func mapping(map: Map) {
    latitude    <- map["latitude"]
    longitude <- map["longitude"]
    accuracy <- map["accuracy"]
    altitude <- map["altitude"]
    }
    
}

