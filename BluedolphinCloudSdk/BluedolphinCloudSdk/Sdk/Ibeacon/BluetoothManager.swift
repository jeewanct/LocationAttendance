//
//  BluetoothManager.swift
//  TrackApp
//
//  Created by Raghvendra on 06/01/17.
//  Copyright © 2017 OneCorp. All rights reserved.
//

import Foundation

import Foundation
import CoreBluetooth
/**Bluetooth manager - responsible for getting the status of Bluetooth.*/
open class BluetoothManager: NSObject, CBCentralManagerDelegate {
    
    var centralManager:CBCentralManager!
    var blueToothReady = false
    var callback:((Bool)->Void)!
    var enabled = false
    override init() {
        super.init()
        
        self.centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main, options: [CBCentralManagerOptionShowPowerAlertKey:true])
    }
    
    convenience init(callback:@escaping (Bool)->Void)
    {
        self.init()
        self.callback = callback
        
    }
    @objc public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn{
            enabled = true
            callback(true)
        }
        else{
            enabled = false
            callback(false)
        }
    }
    
}

