//
//  Ibeacon.swift
//  TrackApp
//
//  Created by Raghvendra on 06/01/17.
//  Copyright © 2017 OneCorp. All rights reserved.
//

import Foundation
import CoreLocation

public extension CLProximity {
    var sortIndex : Int {
        switch self {
        case .immediate:
            return 0
        case .near:
            return 1
        case .far:
            return 2
        case .unknown:
            return 3
        }
    }
}

/**iBeacon*/
open class iBeacon : NSObject {
    
    /// iBeacon Minor
    open let minor:UInt16?
    
    /// iBeacon Major
    open let major:UInt16?
    
    /// Internal name - it will be used by firebase
    fileprivate(set) open var id:String
    
    /// Human readable id
    fileprivate(set) open var readeableId:String = ""
    
    /// iBeacon UUID
    open let UUID: String
    open let rssi: String
    open let accuracy:String
    
    
    
    /// Default proximity
    internal(set) open var proximity: CLProximity  = CLProximity.unknown
    
    
    /// Default state
    internal(set) open var state:CLRegionState = CLRegionState.unknown
    
    
    
    public init(beacon:CLBeacon) {
        self.UUID = beacon.proximityUUID.uuidString
        self.minor = beacon.minor.uint16Value
        self.major = beacon.major.uint16Value
        self.id = ""
        self.proximity = beacon.proximity
        self.rssi = String(beacon.rssi)
        self.accuracy = String(beacon.accuracy)
        super.init()
        self.id = generateId()
    }
    
    /**Initializer*/
    public init(minor:UInt16?, major:UInt16?, proximityId:String){
        
        self.UUID = proximityId
        self.major = major
        self.minor = minor
        self.id = "" // silence the warning
        self.rssi = ""
        self.accuracy = ""
        super.init()
        self.id = generateId()
    }
    
    
    /**Initializer*/
    public init(minor:UInt16?, major:UInt16?, proximityId:String, id:String){
        
        self.UUID = proximityId
        self.major = major
        self.minor = minor
        self.id = id
        self.rssi = ""
        self.accuracy = ""
        super.init()
    }
    
    /**
     
     Generate a unique id based on the iBecon's paramaters
     
     - Returns: A Unique ID
     */
    func generateId() -> String {
        return "\(self.UUID)m\(self.major)m\(self.minor)"
    }
    
    override open var description:String {
        return debugDescription
    }
    
    override open var debugDescription:String{
        
        return "\(self.UUID)--\(self.major)--\(self.minor)"
    }
    
    override open func isEqual(_ object: Any?) -> Bool {
        
        if let minor = self.minor{
            let minorBool = (minor  == (object as! iBeacon).minor)
            if !minorBool {
                return false
            }
        }
        if let major = self.major{
            let minorBool = (major  == (object as! iBeacon).major)
            if !minorBool {
                return false
            }
        }
        
        
        if self.UUID.lowercased() == (object as! iBeacon).UUID.lowercased(){
            return true
        }
        return false
    }
}
