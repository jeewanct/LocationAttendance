//
//  CoreLocationManager.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 09/11/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit


public struct CurrentLocation {
   public static var coordinate = CLLocationCoordinate2D(latitude: 28.63, longitude: 77.23)
   public static var accuracy = "11"
   public static var altitude = "102.23"
   public static var address = String()
   public static var time = Date()
   public static var lastLocation = CLLocation(latitude: 28.63, longitude: 77.23)
}



 class CoreLocationManager : NSObject, CLLocationManagerDelegate {
    
    public static var sharedInstance = CoreLocationManager()
    let locationManager: CLLocationManager
    
    
    //var tempLocationManager : CLLocationManager?
    
    //static let sharedManager : CoreLocationManager = CoreLocationManager()

    
    override init() {
            locationManager = CLLocationManager()
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.distanceFilter = 5
            
            locationManager.requestAlwaysAuthorization()
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.pausesLocationUpdatesAutomatically = false
            super.init()
            locationManager.delegate = self
    }
    
    
//    public func startMonitoringLocation () {
//        if tempLocationManager != nil {
//            tempLocationManager?.stopMonitoringSignificantLocationChanges()
//        }
//
//        tempLocationManager  = CLLocationManager()
//        tempLocationManager?.delegate = self
//        tempLocationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
//        tempLocationManager?.activityType = CLActivityType.otherNavigation
//        //tempLocationManager.distanceFilter  = 100// Must move at least 3km
//        tempLocationManager?.allowsBackgroundLocationUpdates = true
//        //            locationManager.pausesLocationUpdatesAutomatically = fa
//
//        tempLocationManager?.requestAlwaysAuthorization()
//        tempLocationManager?.startMonitoringSignificantLocationChanges()
//    }
    
//    public func stopMonitoringLocation () {
//        tempLocationManager?.stopMonitoringSignificantLocationChanges()
//    }
    
//    public func restartMonitoringLocation () {
//        tempLocationManager?.stopMonitoringSignificantLocationChanges()
//        //tempLocationManager?.requestAlwaysAuthorization()
//        tempLocationManager?.startMonitoringSignificantLocationChanges()
//    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("didChangeAuthorizationStatus")
        
        switch status {
        case .notDetermined:
            print(".NotDetermined")
            break
            
        case .authorizedAlways:
            print(".Authorized")
            //self.locationManager.startUpdatingLocation()
            break
            
        case .denied:
            print(".Denied")
            break
            
        default:
            print("Unhandled authorization status")
            break
            
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let location = locations.last{
            print("Update Location to \(location)")
            print(location.horizontalAccuracy)
            geoCode(location)
            
            CurrentLocation.coordinate = location.coordinate
            CurrentLocation.accuracy = String(location.horizontalAccuracy)
            CurrentLocation.altitude = String(location.altitude)
            CurrentLocation.time = location.timestamp
           
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: iBeaconNotifications.Location.rawValue),  object: location)
            
            
        }

        
        
    }
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        /*
         @Sourabh - Setting local notification to user when we didn't get location
        */
//        let notification = UILocalNotification()
//        notification.fireDate = NSDate(timeIntervalSinceNow: 2) as Date
//        notification.alertBody = "Look's like you have turned off your Location Services"
//        notification.soundName = UILocalNotificationDefaultSoundName
//        notification.userInfo = ["notificationType": "NOLocation"]
//        UIApplication.shared.scheduleLocalNotification(notification)
        print("Error while updating location " + error.localizedDescription)
    }
    public func stopLocationUpdates(){
        print("Location update Stoppped")
        self.locationManager.stopUpdatingLocation()
    }
    public func startLocationUpdate(){
        print("Location update Started")
        self.locationManager.startUpdatingLocation()
        
    }
    func geoCode(_ location : CLLocation!){
        /* Only one reverse geocoding can be in progress at a time hence we need to cancel existing
         one if we are getting location updates */
        let geoCoder = CLGeocoder()
        geoCoder.cancelGeocode()
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (data, error)   in
            guard let placeMarks = data as [CLPlacemark]! else {
                return
            }
            let loc: CLPlacemark = placeMarks[0]
            let addressDict : [NSString:NSObject] = loc.addressDictionary as! [NSString: NSObject]
            let addrList = addressDict["FormattedAddressLines"] as! [String]
            let address = addrList.joined(separator: ", ")
            print(address)
            CurrentLocation.address = address
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LocationUpdate"), object: self, userInfo: nil)
            
        })
        
    }
    
//    func showAlert(_ message : String) {
//        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
//        let OkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (action) in
//            return        }
//        alertController.addAction(OkAction)
//        currenViewController().present(alertController, animated: true) {
//        }
//    }
//    
    
    
    
    
    
}
