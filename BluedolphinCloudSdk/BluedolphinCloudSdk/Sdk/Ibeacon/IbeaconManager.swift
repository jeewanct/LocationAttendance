//
//  IbeaconManager.swift
//  TrackApp
//
//  Created by Raghvendra on 06/01/17.
//  Copyright © 2017 OneCorp. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit


/**Used to broadcast NSNotification*/
public enum iBeaconNotifications:String{
    case BeaconProximity
    case BeaconState
    case Location // new location discoverd
    case iBeaconEnabled
    case iBeaconDisabled
    case BeaconExit
    case BeaconEntry
    
}

/**Interacting with the iBeacons*/
 class IBeaconManager: NSObject, CLLocationManagerDelegate {
    
    let locationManager:CLLocationManager = CLLocationManager()
    //    private var beacons = [iBeacon]() // Currently unused
    /**Storing reference to registered regions*/
    fileprivate var regions = [CLBeaconRegion]()
    
    open var stateCallback:((_ beacon:iBeacon)->Void)?
    open var rangeCallback:((_ beacon:iBeacon)->Void)?
    var bluetoothManager:BluetoothManager?
    
    open var logging = true
    var broadcasting = true
    
    //Different cases
    var bluetoothDisabled = true
    
    /**Error Callback*/
    var errorCallback:((_ messages:[String])->Void)?
    
    /**Success Callback*/
    var successCallback:(()->Void)?
    
    
    override public init(){
        
        super.init()
        locationManager.delegate = self
        registerNotifications()
        locationManager.startUpdatingLocation()
        //test if enabled
    }
    
    
    /**Starts Monitoring for beacons*/
    open func startMonitoring(_ successCallback:@escaping (()->Void), errorCallback:@escaping (_ messages:[String])->Void){
        self.successCallback = successCallback
        self.errorCallback = errorCallback
        checkStatus()
    }
    
    /**Checks the status of the application*/
    func checkStatus(){
        //starts from Bluetooth
  
        if let _ = self.bluetoothManager{
              if let LastBeaconCheckinTime = UserDefaults.standard.value(forKeyPath: "LastBeaconCheckinTime") as? Date {
              }else{
                bluetoothManager = BluetoothManager()
                bluetoothManager?.callback = bluetoothUpdate
            }
            
        }
        else{
    
            bluetoothManager = BluetoothManager()
            bluetoothManager?.callback = bluetoothUpdate
        }
        
    }
    
    
    // var bluetoothManager
    
    /**Check Bluetooth*/
    fileprivate func bluetoothUpdate(_ status:Bool)->Void{
        
        if status == true{
            bluetoothDisabled = false
            //rund additional status check
            let tuple = statusCheck()
            if tuple.0{
                self.successCallback?()
                NotificationCenter.default.post(name: Notification.Name(rawValue: iBeaconNotifications.iBeaconEnabled.rawValue), object: nil)
                startMonitoring()
                
            }
            else{
                print("no bluetooth status")
                self.errorCallback?(tuple.messages)
                NotificationCenter.default.post(name: Notification.Name(rawValue: iBeaconNotifications.iBeaconDisabled.rawValue), object: tuple.messages)
            }
        }
        else{
            NotificationCenter.default.post(name: Notification.Name(rawValue: iBeaconNotifications.iBeaconDisabled.rawValue), object:nil)
            self.errorCallback?(["Bluetooth not enabled."])
            bluetoothDisabled = true
        }
    }
    
    /**Checks if ibeacons are enabled. Should be called first*/
    fileprivate func statusCheck()->(Bool,messages:[String]){
        
        locationManager.requestAlwaysAuthorization()
        var check = true
        var messages = [String]()
        
        if bluetoothDisabled == true
        {
            messages.append("Bluetooth must be turned on.")
            check = false
        }
        
        
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            if logging {
                print("Error - authorization status not enabled!")
            }
            messages.append("Location Services Must be Authorized.")
            check = false
        }else{
            
            locationManager.startUpdatingLocation()
        }
        
        if !CLLocationManager.isMonitoringAvailable(for: CLRegion.self){
            check = false
            messages.append("CLLocationManager monitoring is not enabled on this device.")
            
        }
        
        return (check, messages)
    }
    //
    
    /**Register Notifications*/
    func registerNotifications()
    {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationBackgroundRefreshStatusDidChange, object: UIApplication.shared, queue: nil) { (notification) -> Void in
            
        }
        
        
    }
    
    /**Register iBeacons*/
    open func registerBeacons(_ beacons:[iBeacon])
    {
        
        for beacon in beacons{
            
            var beaconRegion:CLBeaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString:beacon.UUID)!, identifier: beacon.id)
            
            /**Only major infoermation provided*/
            if let major = beacon.major{
                beaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString:beacon.UUID)!, major: major, identifier: beacon.id)
            }
            
            /**All the information provided*/
            if let major = beacon.major, let minor = beacon.minor{
                beaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString:beacon.UUID)!, major: major, minor: minor, identifier: beacon.id)
            }
            
            beaconRegion.notifyEntryStateOnDisplay = true
            beaconRegion.notifyOnEntry = true
            beaconRegion.notifyOnExit = true
            
            regions.append( beaconRegion)
        }
    }
    
    
    /**Register iBeacons*/
    open func registerBeacon(_ beaconId:String)
    {
        
        let bid = CLBeaconRegion(proximityUUID:  UUID(uuidString:beaconId)!, identifier: "Testing Beacon")
        regions.append(bid)
    }
    
    
    
    /**Starts monitoring beacons*/
    func startMonitoring(){
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.distanceFilter  = 100 // Must move at least 3km
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.startUpdatingLocation()
        
        
        for beaconRegion in regions{
            locationManager.startMonitoring(for: beaconRegion)
            locationManager.startRangingBeacons(in: beaconRegion)
            //FIXME: check if needed [self.locationManager performSelector:@selector(requestStateForRegion:) withObject:beaconRegion afterDelay:1];
            //FIXME: added more validation for the ibeacons permission matrix
        
        }
        
    }
    
    /**Stops monitoring beacons*/
    open func stopMonitoring(){
        for beaconRegion in regions{
            locationManager.stopMonitoring(for: beaconRegion)
            locationManager.stopRangingBeacons(in: beaconRegion)
        }
        //locationManager.stopUpdatingLocation()
    }
    
    
    // MARK: Core Location Delegate
    /*
     *  locationManager:didDetermineState:forRegion:
     *
     *  Discussion:
     *    Invoked when there's a state transition for a monitored region or in response to a request for state via a
     *    a call to requestStateForRegion:.
     */
    
    open func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion)
    {
        
        //we found a beacon. Now
        if let region = region as? CLBeaconRegion
        {
            if logging {
                print("State determined\(region) \(state.rawValue)")
            }
        }
        
        //we found a beacon. Now
        if let region = region as? CLBeaconRegion, let minor = region.minor, let major  = region.major{
            
            let beacon = iBeacon(minor: minor.uint16Value, major: major.uint16Value, proximityId: region.proximityUUID.uuidString)
            beacon.state = state
            
            if logging {
                print("State determined\(region) \(state.rawValue)")
            }
            
            if broadcasting{
                //broadcast notification
                //get beacon from clregion
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: iBeaconNotifications.BeaconState.rawValue), object: beacon)
            }
            
            if let callback = self.stateCallback{
                callback(beacon)
            }
        }
        //if we are outside stop ranging
        if state == .outside{
         manager.stopRangingBeacons(in: region as! CLBeaconRegion)
        }
        if state == .inside{
            manager.startRangingBeacons(in: region as! CLBeaconRegion)
        }
        
        
    }
    /*
     *  locationManager:didRangeBeacons:inRegion:
     *
     *  Discussion:
     *    Invoked when a new set of beacons are available in the specified region.
     *    beacons is an array of CLBeacon objects.
     *    If beacons is empty, it may be assumed no beacons that match the specified region are nearby.
     *    Similarly if a specific beacon no longer appears in beacons, it may be assumed the beacon is no longer received
     *    by the device.
     */
    
    var newBeacon = [String:TimeInterval]()
    
    func beaconScanning(beacons:[CLBeacon]) {
        objc_sync_enter(self);
         defer {
            
            //convert it to our iBeacons
            var myBeacons = [iBeacon]()
            for beacon in beacons{
                if beacon.proximity != .unknown{
                    let myBeacon = iBeacon(beacon: beacon)
                    if let value = newBeacon[myBeacon.id]  {
                        let time = value - NSDate.timeIntervalSinceReferenceDate
                        if time >= 60{
                            newBeacon.removeValue(forKey: myBeacon.id)
                    
                        }
                        
                        
                    }else{
                        newBeacon[myBeacon.id] = NSDate.timeIntervalSinceReferenceDate
                        myBeacons.append(myBeacon)
                        
                    }
                    
                   
                }
            }
            
            myBeacons.sort(by: {$0.proximity.sortIndex < $1.proximity.sortIndex})
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: iBeaconNotifications.BeaconProximity.rawValue), object: myBeacons)
        objc_sync_exit(self);
        }
    }
    
    open func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion)
    {
        //Notify the delegates and etc that we know how far are we from the iBeacon
        if logging {
            print("Did Range Beacons \(beacons)")
        }
        
        if broadcasting{
            //beaconScanning(beacons: beacons)
            //broadcast notification
            //convert CLBeacon to iBeacon
            
            var myBeacons = [iBeacon]()
            //convert it to our iBeacons
            for beacon in beacons{
                if beacon.proximity != .unknown{
                    let myBeacon = iBeacon(beacon: beacon)
                    myBeacons.append(myBeacon)
                }
            }
            
            myBeacons.sort(by: {$0.proximity.sortIndex < $1.proximity.sortIndex})
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: iBeaconNotifications.BeaconProximity.rawValue), object: myBeacons)
        }
        
        
        for beacon in beacons{
//            if logging {
//                print("Did Range Beacon \(beacon)")
//            }
            if let callback = self.rangeCallback{
                //convert it to the internal type of the beacon
                let ibeacon =  iBeacon(minor: beacon.minor.uint16Value, major: beacon.major.uint16Value, proximityId: beacon.proximityUUID.uuidString)
                ibeacon.proximity = beacon.proximity
                callback(ibeacon)
            }
        }
    }
    
    
    /**Update Location*/
    open func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last{
            print("Update Location to \(location)")
            print(location.horizontalAccuracy)
            if location.horizontalAccuracy <= locationManager.desiredAccuracy {
               NotificationCenter.default.post(name: Notification.Name(rawValue: iBeaconNotifications.Location.rawValue),  object: location)
            }
            
        }
    }
    
    /*
     *  locationManager:rangingBeaconsDidFailForRegion:withError:
     *
     *  Discussion:
     *    Invoked when an error has occurred ranging beacons in a region. Error types are defined in "CLError.h".
     */
    
    open func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error)
    {
        if logging {
            print("Ranging Fail\(region) \(error)")
        }
    }
    
    
    /*
     *  locationManager:didEnterRegion:
     *
     *  Discussion:
     *    Invoked when the user enters a monitored region.  This callback will be invoked for every allocated
     *    CLLocationManager instance with a non-nil delegate that implements this method.
     */
    open func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion)
    {
        if region is CLBeaconRegion{
            let beacon = region as! CLBeaconRegion
            let ibeacon =  iBeacon(minor: beacon.minor?.uint16Value, major: beacon.major?.uint16Value, proximityId: beacon.proximityUUID.uuidString)
            ibeacon.proximity = CLProximity(rawValue: 1)!
            NotificationCenter.default.post(name: Notification.Name(rawValue: iBeaconNotifications.BeaconEntry.rawValue), object: ibeacon)
            if logging {
                print("Region Entered! \(region) ")
               
                manager.startRangingBeacons(in: region as! CLBeaconRegion)
            }
        }
    }
    /*
     *  locationManager:didExitRegion:
     *
     *  Discussion:
     *    Invoked when the user exits a monitored region.  This callback will be invoked for every allocated
     *    CLLocationManager instance with a non-nil delegate that implements this method.
     */
    
    open func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion)
    {
        if region is CLBeaconRegion{
            let beacon = region as! CLBeaconRegion
            let ibeacon =  iBeacon(minor: beacon.minor?.uint16Value, major: beacon.major?.uint16Value, proximityId: beacon.proximityUUID.uuidString)
            ibeacon.proximity = CLProximity(rawValue: 1)!
            NotificationCenter.default.post(name: Notification.Name(rawValue: iBeaconNotifications.BeaconExit.rawValue), object: ibeacon)
            if logging {
                
                print("Exit Region! \(region) ")
                manager.stopRangingBeacons(in: region as! CLBeaconRegion)
            }
            
        }
    }
    /*
     *  locationManager:didFailWithError:
     *
     *  Discussion:
     *    Invoked when an error has occurred. Error types are defined in "CLError.h".
     */
    
    open func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        
        if logging {
            print("Manager Failed with error \(error)")
        }
        
    }
    /*
     *  locationManager:monitoringDidFailForRegion:withError:
     *
     *  Discussion:
     *    Invoked when a region monitoring error has occurred. Error types are defined in "CLError.h".
     */
    
    open func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error)
    {
        if logging {
            print("Monitoring Failed with error \(error)")
        }
        
    }
    /*
     *  locationManager:didChangeAuthorizationStatus:
     *
     *  Discussion:
     *    Invoked when the authorization status changes for this application.
     */
    
    open func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        if status == CLAuthorizationStatus.authorizedAlways{
            if statusCheck().0 == true {
                startMonitoring()
            }
        }
    }
    /*
     *  locationManager:didStartMonitoringForRegion:
     *
     *  Discussion:
     *    Invoked when a monitoring for a region started successfully.
     */
    
    open func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion)
    {
        
    }
    /*
     *  Discussion:
     *    Invoked when location updates are automatically paused.
     */
    
    open func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager)
    {
        
    }
    /*
     *  Discussion:
     *    Invoked when location updates are automatically resumed.
     *
     *    In the event that your application is terminated while suspended, you will
     *	  not receive this notification.
     */
    
    open func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager)
    {
        
    }
    
    /*
     **  Returns true is the beacon is inside the required range, false otherwise
     **
     */
    open static func isInRange( _ objectProximity : CLProximity, requiredProximity: CLProximity) -> Bool {
        return  objectProximity.sortIndex <= requiredProximity.sortIndex
    }
    
    
}
