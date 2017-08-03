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




open class AccessTokenObject :Object,Mappable {
   public  dynamic var organizationId:String = ""
     public dynamic var token:String = ""
    public  dynamic var userId:String = ""
   public dynamic var organizationName:String = ""
   public dynamic var expires  = 0
   public dynamic var userName:String?
   public dynamic var orgFeatures:String?
     
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
        orgFeatures <- map["orgFeatures"]
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
