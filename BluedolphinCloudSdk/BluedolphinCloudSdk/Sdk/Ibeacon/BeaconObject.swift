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

 class RMCBeacon :Object,Mappable{
    dynamic var lastSeen:String?
    dynamic var distance:String?
    dynamic var rssi:String?
    dynamic var major:String?
    dynamic var minor:String?
    dynamic var uuid:String?
    dynamic var beaconId:String?
    required convenience public init?(map : Map){
        self.init()
    }
    override open static func primaryKey() -> String? {
        return "beaconId"
        
    }
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

 class VicinityBeacon:Object{
    
    dynamic var addedOn:String?
    dynamic var updatedOn:String?
    dynamic var uuid:String?
    dynamic var major:String?
    dynamic var minor:String?
    dynamic var beaconId:String?
    dynamic var address:String?
    dynamic var organizationId:String?
    dynamic var placeId:String?
    dynamic var location:RMCLocation?
    required convenience public init?(map : Map){
        self.init()
    }
    override open static func primaryKey() -> String? {
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


