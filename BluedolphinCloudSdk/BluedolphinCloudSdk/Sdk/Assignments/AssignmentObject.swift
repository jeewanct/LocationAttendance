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
    public typealias Object = List<T>
    public typealias JSON = Array<AnyObject>
    
    public func transformFromJSON(_ value: Any?) -> List<T>? {
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
    
    public func transformToJSON(_ value: List<T>?) -> Array<AnyObject>? {
        
        guard let realmList = value, realmList.count > 0 else { return nil }
        
        var resultArray = Array<T>()
        
        for entry in realmList {
            resultArray.append(entry)
        }
        
        return resultArray
    }
}



 class AssignmentObject:Object,Mappable{
    
    
   dynamic var assignmentId:String? = nil
   dynamic var assigneeId:String? = nil
   dynamic var status:String? = nil
   dynamic var latitude:String? = nil
   dynamic var longitude:String? = nil
   dynamic var altitude:String? = nil
   dynamic  var accuracy:String? = nil
   dynamic  var organizationId:String? = nil
   dynamic  var assignmentDeadline:String? = nil
    dynamic var assignmentStartTime:String? = nil
    dynamic var assignmentAddress:String? = nil
    dynamic var time :String? = nil
    
    dynamic var assignmentDetails:String? = nil
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
        organizationId    <- map["organizationId"]
        assignmentId <- map["assignmentId"]
        assignmentDeadline <- map["assignmentDeadline"]
        assigneeId <- map["assigneeId"]
        status <- map["status"]
        time <- map["time"]

        assignmentDetails <- map["assignmentDetails"]
        assignmentStartTime <- map["assignmentStartTime"]
        assignmentAddress <- map["assignmentAddress"]
    }
    
    
    
    
}


 class RMCAssignmentObject :Object,Mappable {
    dynamic var assignmentId:String? = nil
    dynamic var addedOn:String? = nil
    dynamic var time:String? = nil
    dynamic var updatedOn:String? = nil
    dynamic var assignmentDetails:String? = nil
    dynamic var assignmentStatusLog:String? = nil
    dynamic var assignmentDeadline:Date?  = nil
    dynamic var assignmentStartTime:Date?  = nil
    dynamic var assignmentAddress:String? = nil
    var assigneeData = List<RMCAssignee>()
    dynamic var assignerData:RMCAssignee?
    dynamic var location:RMCLocation?
    dynamic var status:String? = nil
    dynamic var jobNumber:String? = nil
    dynamic var bookmarked:String? = nil
    dynamic var lastUpdated:Date?  = nil
    dynamic var selfAssignment:String? = nil
    dynamic var downloadedOn:Date?  = nil
    dynamic var submittedOn:Date?  = nil
    dynamic var firstTypeAssignment :String? = nil
    override open static func primaryKey() -> String?  {
        return "assignmentId"
        
    }
    required convenience public init?(map: Map) {
        self.init()
    }
    public func mapping(map: Map) {
        addedOn    <- map["addedOn"]
        time <- map["time"]
        updatedOn <- map["updatedOn"]
        assignmentStatusLog <- map["assignmentStatusLog"]
        assigneeData    <- (map["assigneeData"],ArrayTransform<RMCAssignee>())
        assignmentId <- map["assignmentId"]
        assignerData <- map["assignerData"]
        location <- map["location"]
        assignmentDetails <- map["assignmentDetails"]
        assignmentDeadline <- map["assignmentDeadline"]
        assignmentStartTime <- map["assignmentStartTime"]
        assignmentAddress <- map["assignmentAddress"]
        status <- map["status"]
        bookmarked <- map["bookmark"]
        lastUpdated <- map["lastUpdated"]
        selfAssignment <- map["selfAssignment"]
        downloadedOn <- map["downloadedOn"]
        submittedOn <- map["submittedOn"]
        jobNumber <- map["jobNumber"]
        firstTypeAssignment <- map["firstTypeAssignment"]
    }
    
}


 class RMCAssignee :Object,Mappable{
    dynamic var userId:String? = nil;
    dynamic var organizationId:String? = nil;
    
    required convenience public init?(map: Map) {
        self.init()
    }
    //    override static func primaryKey() -> String? {
    //        return "userId"
    //
    //    }
    public func mapping(map: Map) {
        userId    <- map["userId"]
        organizationId <- map["organizationId"]
    }
}
// class assignmentLog:Object{
//    dynamic var status :String?
//    dynamic var time:String?
//    dynamic var checkinId:String?
//}

open class RMCLocation:Object,Mappable{
  public  dynamic var latitude:String? = nil
   public dynamic var longitude:String? = nil
   public dynamic var altitude:String? = nil
   public dynamic var accuracy:String? = nil
    required convenience public init?(map: Map) {
        self.init()
    }
    public func mapping(map: Map) {
        latitude    <- map["latitude"]
        longitude <- map["longitude"]
        accuracy <- map["accuracy"]
        altitude <- map["altitude"]
    }
    
}

 class AssignmentHolder:NSObject{
    
    
    var assignmentId:String?
    var assigneeIds:[String]?
    var status:String?
    var latitude:String?
    var longitude:String?
    var altitude:String?
    var accuracy:String?
    var organizationId:String?
    var assignmentDeadline:String?
    var assignmentStartTime:String?
    var assignmentDetails:NSDictionary?
    var assignmentAddress:String?
    var time:String?
    
    
}



