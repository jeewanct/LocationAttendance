//
//  BlueDolphinManager.swift
//  BluedolphinCloudSdk
//
//  Created by Raghvendra on 03/04/17.
//  Copyright © 2017 raremediacompany. All rights reserved.
//

import Foundation
enum InitilizationError : Error {
    case SecretKeyError
    case OrganizationIdError
    case EmailError
    case firstNameError
    case lastNameError
}

open class BlueDolphinManager:NSObject {
    public static let manager: BlueDolphinManager = BlueDolphinManager()
    var secretKey:String = String()
    var organizationId:String  = String()
    public var emailId:String  = String()
    var coreLocationController:CoreLocationController?
    
    public var seanbeacons = NSMutableDictionary()
    var beaconSentflag = true
    
    var beaconManager = IBeaconManager()
    
    public func initialize(secretKey:String?,organizationId:String?,email:String?,firstName:String?,lastName:String?,metaInfo:NSDictionary?) {
        
        setConfig(secretKey:secretKey!,organizationId:organizationId!)
        authorizeUser(email: email!, firstName: firstName!, lastName: lastName!, metaInfo: metaInfo!)
        
    }
    
    public func setConfig(secretKey:String,organizationId:String){
        self.secretKey = secretKey
        self.organizationId = organizationId
        self.coreLocationController  = CoreLocationController()
        
    }
    
    
    public func authorizeUser(email:String,firstName:String,lastName:String = "",metaInfo:NSDictionary){
        self.emailId = email
        let object = [
            "grantType":"accessToken",
            "loginType":"secretKey",
            "selfRequest":true,
            "secretKey":self.secretKey,
            "organizationId":self.organizationId,
            "email": self.emailId,
            "firstName":firstName,
            "lastName":lastName
            ] as [String : Any]
        
        OauthModel.getToken(userObject: object) { (result) in
            switch (result){
            case APIResult.Success.rawValue:
                getUserData()
                self.postTransientCheckin(metaInfo: metaInfo as! [String : AnyObject])
                //self.getNearByBeacons()
                
            case APIResult.InvalidCredentials.rawValue:
                break
            case APIResult.InternalServer.rawValue:
                break
            case APIResult.InvalidData.rawValue:
                break
            default:
                break
                
            }
        }
    }
    
    
    public func postTransientCheckin(metaInfo:[String:AnyObject]){
        
        let checkin = CheckinHolder()
        var details = metaInfo
        details[AssignmentWork.AppVersion.rawValue] = AppVersion as AnyObject
        details[AssignmentWork.UserAgent.rawValue] = deviceType as AnyObject
        checkin.checkinDetails = details
        checkin.checkinCategory = CheckinCategory.Data.rawValue
        checkin.checkinType = CheckinType.Data.rawValue
        
        
        CheckinModel.createCheckin(checkinData: checkin)
        if isInternetAvailable() {
            CheckinModel.postCheckin()
        }
    }
    
    public func getNearByBeacons(completion: @escaping (_ result: BeaconScanning) -> Void){
        if isInternetAvailable() {
            VicinityManager.getNearByBeacons { (value) in
//                switch value {
//                case .StartScanning:
//                    
//                    self.startScanning()
//                case .Failure,.NoScanning:
//                    break;
//                    
//                }
                completion(value)
            }
        }
        
    }
    
    
    public func startScanning(){
        //beaconManager = IBeaconManager()
        var beaconArray = [iBeacon]()
        
        let beaconsData = VicinityManager.fetchBeaconsFromDb()
        for beaconObject in beaconsData{
            let ibeacon =
                iBeacon(minor: beaconObject.minor, major: beaconObject.major, proximityId: beaconObject.uuid!, id: beaconObject.beaconId!)
            beaconArray.append(ibeacon)
        }
        
        print("Beacons count \(beaconArray.count)")
        beaconManager.registerBeacons(beaconArray)
        //        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: iBeaconNotifications.BeaconProximity.rawValue), object: nil)
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(beaconsRanged(notification:)), name: NSNotification.Name(rawValue: iBeaconNotifications.BeaconProximity.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(beaconsEntry(notification:)), name: NSNotification.Name(rawValue: iBeaconNotifications.BeaconEntry.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(beaconsExit(notification:)), name: NSNotification.Name(rawValue: iBeaconNotifications.BeaconExit.rawValue), object: nil)
        beaconManager.startMonitoring({
            print("Sucesss")
        }) { (error) in
            print(error)
        }
    }
    
    public func updateToken(){
        getUserData()
        OauthModel.updateToken()
    }
    
    public func stopScanning(){
        beaconManager.stopMonitoring()
       // NotificationCenter.default.removeObserver(self)
    }
    
    func beaconsEntry(notification:NSNotification){
     
    }
    func beaconsExit(notification:NSNotification){
        
        
    }
    
    
    /**Called when the beacons are ranged*/
    func beaconsRanged(notification:NSNotification){
        if let visibleIbeacons = notification.object as? [iBeacon]{
            
            
            for beacon in visibleIbeacons{
                /// Do something with the iBeacon
                
                let dict = [
                    "uuid" : beacon.UUID ,
                    "major": String(describing: beacon.major!),
                    "minor" : String(describing: beacon.minor!),
                    //"proximity" :  String(describing: beacon.proximity),
                    "rssi" : beacon.rssi,
                    "distance" :beacon.accuracy,
                    "lastSeen" : getCurrentDate().formattedISO8601
                    
                ]
                seanbeacons.addEntries(from: [beacon.major! :dict])
                print(dict)
            }
            UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.LastBeaconScanned.rawValue)

            if beaconSentflag {
                beaconSentflag = false
                //                let delay = 60.0 * Double(NSEC_PER_SEC)
                //                let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                //                DispatchQueue.main.asyncAfter(deadline: time, execute: {
                var beaconArray = Array<Any>()
                for (_,value) in self.seanbeacons {
                    beaconArray.append(value)
                }
                
                if beaconArray.count != 0 {
                    if let LastBeaconCheckinTime = UserDefaults.standard.value(forKeyPath: UserDefaultsKeys.LastBeaconCheckinTime.rawValue) as? Date {
                 
                        print( "Difference LastBeaconCheckinTime \(LastBeaconCheckinTime.minuteFrom(Date()))")
                        if Date().secondsFrom(LastBeaconCheckinTime) > CheckinInterVal {
                            print("beacon data \(beaconArray)")
                            self.sendCheckins(array: beaconArray)
                        }
                        if Date().secondsFrom(LastBeaconCheckinTime) < 0{
                           self.sendCheckins(array: beaconArray)
                        }
                    }else{
                        self.sendCheckins(array: beaconArray)
                    }
                }
                self.beaconSentflag = true
                //})
            }
            
            
            
        }
    }
    
    public  func sendCheckins(array:Array<Any>){
        
        let checkin = CheckinHolder()
        
        checkin.beaconProximities = array
        checkin.checkinDetails = [AssignmentWork.AppVersion.rawValue:AppVersion as AnyObject,AssignmentWork.UserAgent.rawValue:deviceType as AnyObject]
        checkin.checkinCategory = CheckinCategory.Transient.rawValue
        checkin.checkinType = CheckinType.Beacon.rawValue
        self.seanbeacons = NSMutableDictionary()                //
        CheckinModel.createCheckin(checkinData: checkin)
        if isInternetAvailable(){
            CheckinModel.postCheckin()
        }
    }
    
    
    
}
