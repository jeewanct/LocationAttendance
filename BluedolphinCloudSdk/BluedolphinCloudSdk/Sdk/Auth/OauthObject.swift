//
//  OauthObject.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 21/11/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation

import RealmSwift
import ObjectMapper




 class AccessTokenObject :Object,Mappable {
     dynamic var organizationId:String = ""
     dynamic var token:String = ""
     dynamic var userId:String = ""
    dynamic var organizationName:String = ""
    dynamic var expires  = 0
    dynamic var userName:String?
    //dynamic var primeKey :String?
    //Impl. of Mappable protocol
    required convenience public init?(map: Map) {
        self.init()
    }
    
    
    
    
    override open static func primaryKey() -> String? {
        return "organizationId"
    }
    
    
    
    public func mapping(map: Map) {
        organizationId <- map["organizationId"]
        token <- map["token"]
        userId <- map["userId"]
        organizationName <- map["organizationName"]
        expires <- map["expires"]
        userName <- map["userName"]
        // primeKey = userId! + "." + organizationId!
    }
    
    
}
 class RefreshTokenObject :Object,Mappable {
    
    dynamic var token:String = ""
    dynamic var userId:String = ""
    dynamic var expires  = 0
    //Impl. of Mappable protocol
    required convenience public init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        
        token <- map["token"]
        userId <- map["userId"]
        expires <- map["expires"]
    }
    override open static func primaryKey() -> String? {
        return "userId"
    }
    
    
}
