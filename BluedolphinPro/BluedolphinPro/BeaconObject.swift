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
    dynamic var lastseen:String?
    dynamic var distance:String?
    dynamic var rssi:String?
    dynamic var major:String?
    dynamic var minor:String?
    dynamic var uuid:String?
    required convenience init?(map : Map){
        self.init()
    }
    static func mapToRMCBeacon(dict:NSDictionary) -> RMCBeacon{
        return Mapper<RMCBeacon>().map(JSONObject: dict)!
    }
    func mapping(map: Map) {
        lastseen    <- map["lastseen"]
        distance <- map["distance"]
        rssi <- map["rssi"]
        major <- map["major"]
        minor    <- map["minor"]
        uuid <- map["uuid"]
    }
    
}
