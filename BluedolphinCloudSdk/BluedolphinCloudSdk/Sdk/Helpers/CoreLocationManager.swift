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
}



 class CoreLocationController : NSObject, CLLocationManagerDelegate {
    
    var locationManager:CLLocationManager = CLLocationManager()
    
    override init() {
        super.init()
        if (CLLocationManager.locationServicesEnabled())
        {
            
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.distanceFilter  = 100 // Must move at least 3km
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.pausesLocationUpdatesAutomatically = true
            //locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
        }
        else {
           // showAlert("This app does not have access to Location service,You can enable access in Settings->Privacy->Location->Location Services ")
        }
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("didChangeAuthorizationStatus")
        
        switch status {
        case .notDetermined:
            print(".NotDetermined")
            break
            
        case .authorizedAlways:
            print(".Authorized")
            self.locationManager.startUpdatingLocation()
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
        
        let location = locations.last! as CLLocation
       
            geoCode(location)
            
            CurrentLocation.coordinate = location.coordinate
            CurrentLocation.accuracy = String(location.horizontalAccuracy)
            CurrentLocation.altitude = String(location.altitude)
            CurrentLocation.time = location.timestamp
            print(CurrentLocation.time)
        
        
        
    }
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
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
