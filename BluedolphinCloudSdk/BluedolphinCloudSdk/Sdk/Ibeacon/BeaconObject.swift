//
//  BeaconObject.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 16/01/17.
//  Copyright © 2017 raremediacompany. All rights reserved.
//

import Foundation
import RealmSwift
import  ObjectMapper

 open class RMCBeacon :Object,Mappable{
   public dynamic var lastSeen:String? = nil
   public dynamic var distance:String? = nil
   public dynamic var rssi:String? = nil
   public dynamic var major:String? = nil
   public dynamic var minor:String? = nil
   public dynamic var uuid:String? = nil
   public dynamic var beaconId:String? = nil
    required convenience public init?(map : Map){
        self.init()
    }
//    override open static func primaryKey() -> String? {
//        return "beaconId"
//        
//    }
//    static func mapToRMCBeacon(dict:NSDictionary) -> RMCBeacon{
//     return Mapper<RMCBeacon>().map(JSONObject: dict)!
//
//    }
    public func mapping(map: Map) {
        lastSeen    <- map["lastSeen"]
        distance <- map["distance"]
        rssi <- map["rssi"]
        major <- map["major"]
        minor    <- map["minor"]
        uuid <- map["uuid"]
        beaconId <- map["beaconId"]
       
    }
    
}

 open class VicinityBeacon:Object{
    
   public dynamic var addedOn:String? = nil
   public dynamic var updatedOn:String? = nil
   public dynamic var uuid:String? = nil
   public dynamic var major:String? = nil
   public dynamic var minor:String? = nil
   public dynamic var beaconId:String? = nil
  public  dynamic var address:String? = nil
  public  dynamic var organizationId:String? = nil
  public  dynamic var placeId:String? = nil
  public  dynamic var location:RMCLocation?
    required convenience public init?(map : Map){
        self.init()
    }
    override open static func primaryKey() -> String?  {
        return "beaconId"
        
    }
    func mapping(map: Map) {
        addedOn    <- map["addedOn"]
        updatedOn <- map["updatedOn"]
        uuid <- map["uuid"]
        major <- map["major"]
        minor    <- map["minor"]
        beaconId <- map["beaconId"]
        address <- map["address"]
        organizationId <- map["organizationId"]
        placeId <- map["placeId"]
        location <- map["location"]
    }
    
    
    
}


