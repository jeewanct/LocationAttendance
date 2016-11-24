//
//  Singelton.swift
//  BluedolphinCloudSdk
//
//  Created by Raghvendra on 21/11/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation

import UIKit
public class CoreSingleton {
    
    public static let sharedInstance: CoreSingleton = CoreSingleton()
    
   public var organizationId = String()
   public var userId = String()
   public var DeviceUDID = String()
   public var accessToken = String()
   public func batteryLevel() -> Float {
        
        return UIDevice.current.batteryLevel
    }
    
}
