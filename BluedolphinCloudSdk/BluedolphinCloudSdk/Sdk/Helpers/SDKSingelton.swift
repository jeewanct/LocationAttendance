//
//  Singelton.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 03/11/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation
import UIKit
class SDKSingleton {
    
    static let sharedInstance: SDKSingleton = SDKSingleton()
    
    var organizationId = String()
    var userId = String()
    var DeviceUDID = String()
    var accessToken = String()
    var userName = String()
    var mobileNumber = String()
    func batteryLevel() -> Float {
        
        return UIDevice.current.batteryLevel
    }
    
}
