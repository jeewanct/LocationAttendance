//
//  Singelton.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 03/11/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation
import UIKit
 open class SDKSingleton {
    
   public static let sharedInstance: SDKSingleton = SDKSingleton()
    
   public var organizationId = String()
   public var userId = String()
   public var DeviceUDID = String()
   public var accessToken = String()
   public var userName = String()
   public var mobileNumber = String()
   public var employeeShiftSwitchFlexibility = Bool()
   public var locationTracking = Bool()
   public var transmitter = Bool()
   public var shiftId = String()
   public var iosAPPVersion = String()

    func batteryLevel() -> Float {
        return UIDevice.current.batteryLevel
    }
    
}
