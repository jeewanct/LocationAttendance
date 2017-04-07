//
//  BlueDolphinManager.swift
//  BluedolphinCloudSdk
//
//  Created by Raghvendra on 03/04/17.
//  Copyright © 2017 raremediacompany. All rights reserved.
//

import Foundation


open class BlueDolphinManager:NSObject {
    public static let manager: BlueDolphinManager = BlueDolphinManager()
    var secretKey:String = String()
    var organisationId:String  = String()
    var emailId:String  = String()
    var coreLocationController:CoreLocationController?
    
    var seanbeacons = NSMutableDictionary()
    var beaconSentflag = true
    let beaconManager = IBeaconManager()
    
    public func setConfig(secretKey:String,orgnisationId:String){
       self.secretKey = secretKey
       self.organisationId = orgnisationId
       self.coreLocationController  = CoreLocationController()
        
    }
    public func authorizeUser(email:String,firstName:String,lastName:String = "",metaInfo:NSDictionary){
        self.emailId = email
        let object = [
            "grantType":"accessToken",
            "loginType":"secretKey",
            "selfRequest":true,
            "secretKey":self.secretKey,
            "organizationId":self.organisationId,
            "email": self.emailId,
            "firstName":firstName,
            "lastName":lastName
        ] as [String : Any]
        let oauth = OauthModel()
        oauth.getToken(userObject: object) { (result) in
            switch (result){
            case APIResult.Success.rawValue:
               getUserData()
               self.postTransientCheckin(metaInfo: metaInfo as! [String : AnyObject])
                
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
     func postTransientCheckin(metaInfo:[String:AnyObject]){
        
        let checkin = CheckinHolder()
        var details = metaInfo
        details[AssignmentWork.AppVersion.rawValue] = AppVersion as AnyObject
        details[AssignmentWork.UserAgent.rawValue] = deviceType as AnyObject
        checkin.checkinDetails = details
        checkin.checkinCategory = CheckinCategory.Transient.rawValue
        checkin.checkinType = CheckinType.Location.rawValue
        
        let checkinModelObject = CheckinModel()
        checkinModelObject.createCheckin(checkinData: checkin)
        if isInternetAvailable() {
            checkinModelObject.postCheckin()
        }
    }
    
   public func getNearByBeacons(){
        getUserData()
        let vicinityManager = VicinityManager()
        if isInternetAvailable() {
            vicinityManager.getNearByBeacons { (value) in
                switch value {
                case .StartScanning: 
                self.startScanning()
                case .Failure,.NoScanning:
                    break;
                    
                }
            }
        }
        
    }
    
    
    func startScanning(){
    
        var beaconArray = [iBeacon]()
        let vicinityManager = VicinityManager()
        
        let beaconsData = vicinityManager.fetchBeaconsFromDb()
        for beaconObject in beaconsData{
            let ibeacon =
                iBeacon(minor: beaconObject.minor, major: beaconObject.major, proximityId: beaconObject.uuid!, id: beaconObject.beaconId!)
            beaconArray.append(ibeacon)
        }
        
        print("Beacons count \(beaconArray.count)")
        beaconManager.registerBeacons(beaconArray)
        //        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: iBeaconNotifications.BeaconProximity.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(beaconsRanged(notification:)), name: NSNotification.Name(rawValue: iBeaconNotifications.BeaconProximity.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(beaconsEntry(notification:)), name: NSNotification.Name(rawValue: iBeaconNotifications.BeaconEntry.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(beaconsExit(notification:)), name: NSNotification.Name(rawValue: iBeaconNotifications.BeaconExit.rawValue), object: nil)
        beaconManager.startMonitoring({
            
        }) { (messages) in
            print("Error Messages \(messages)")
        }
    }
    
    public func updateToken(){
       getUserData()
       let oauth = OauthModel()
       oauth.updateToken()
    }
    
    public func stopScanning(){
        beaconManager.stopMonitoring()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: iBeaconNotifications.BeaconProximity.rawValue), object: nil)
    }
    
    func beaconsEntry(notification:NSNotification){
        if let beacon = notification.object as? iBeacon{
            let dict = [
                "uuid" : beacon.UUID ,
                "major": String(describing: beacon.major!),
                "minor" : String(describing: beacon.minor!),
                //"proximity" :  String(describing: beacon.proximity),
                "rssi" : beacon.rssi,
                "distance" :beacon.accuracy,
                "lastseen" : getCurrentDate().formattedISO8601
                
            ]
            let checkin = CheckinHolder()
            var beaconArray = Array<Any>()
            
            beaconArray.append(dict)
            
            checkin.beaconProximities = beaconArray
            checkin.checkinDetails = [AssignmentWork.AppVersion.rawValue:AppVersion as AnyObject,AssignmentWork.UserAgent.rawValue:deviceType as AnyObject,"BeaconState":"BeaconEntry" as AnyObject]
            checkin.checkinCategory = CheckinCategory.Transient.rawValue
            checkin.checkinType = CheckinType.Beacon.rawValue
            let checkinModelObject = CheckinModel()
            checkinModelObject.createCheckin(checkinData: checkin)
            if isInternetAvailable(){
                checkinModelObject.postCheckin()
            }
        }
    }
    func beaconsExit(notification:NSNotification){
        if let beacon = notification.object as? iBeacon{
            let dict = [
                "uuid" : beacon.UUID ,
                "major": String(describing: beacon.major!),
                "minor" : String(describing: beacon.minor!),
                //"proximity" :  String(describing: beacon.proximity),
                "rssi" : beacon.rssi,
                "distance" :beacon.accuracy,
                "lastseen" : getCurrentDate().formattedISO8601
                
            ]
            let checkin = CheckinHolder()
            var beaconArray = Array<Any>()
          
            beaconArray.append(dict)
        
            checkin.beaconProximities = beaconArray
            checkin.checkinDetails = [AssignmentWork.AppVersion.rawValue:AppVersion as AnyObject,AssignmentWork.UserAgent.rawValue:deviceType as AnyObject,"BeaconState":"BeaconExit" as AnyObject]
            checkin.checkinCategory = CheckinCategory.Transient.rawValue
            checkin.checkinType = CheckinType.Beacon.rawValue
            let checkinModelObject = CheckinModel()
            checkinModelObject.createCheckin(checkinData: checkin)
            if isInternetAvailable(){
                checkinModelObject.postCheckin()
            }
        }
        
        
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
                    "lastseen" : getCurrentDate().formattedISO8601
                    
                ]
                seanbeacons.addEntries(from: [beacon.major! :dict])
                print(dict)
            }
            if beaconSentflag {
                beaconSentflag = false
                let delay = 60.0 * Double(NSEC_PER_SEC)
                let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: time, execute: {
                    self.beaconSentflag = true
                     if self.seanbeacons.count != 0 {
                    self.sendCheckins()
                    }
                })
            }
  
        }
    }
    
    func sendCheckins(){
            let checkin = CheckinHolder()
            var beaconArray = Array<Any>()
            for (_,value) in self.seanbeacons {
                beaconArray.append(value)
            }
            checkin.beaconProximities = beaconArray
            checkin.checkinDetails = [AssignmentWork.AppVersion.rawValue:AppVersion as AnyObject,AssignmentWork.UserAgent.rawValue:deviceType as AnyObject]
            checkin.checkinCategory = CheckinCategory.Transient.rawValue
            checkin.checkinType = CheckinType.Beacon.rawValue
            self.seanbeacons = NSMutableDictionary()                //
            let checkinModelObject = CheckinModel()
            checkinModelObject.createCheckin(checkinData: checkin)
            if isInternetAvailable(){
                checkinModelObject.postCheckin()
            }
            
        
    }
    
}
