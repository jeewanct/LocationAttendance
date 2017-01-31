//
//  VicinityManager.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 30/01/17.
//  Copyright © 2017 raremediacompany. All rights reserved.
//

import Foundation
import RealmSwift
enum BeaconScanning:String{
  case StartScanning
  case NoScanning
  case Failure
}

class VicinityManager {
    internal static func url() -> String {
        return  APIURL + ModuleUrl.Organisation.rawValue + SDKSingleton.sharedInstance.organizationId 
    }
    
    
    func getHeader()->[String:String]{
        let headers = [
            "Content-Type":"application/json",
            "Accept-Encoding":"application/gzip",
            "Accept":"application/json",
            "Authorization":"Bearer " + SDKSingleton.sharedInstance.accessToken,
            "userId":SDKSingleton.sharedInstance.userId
        ]
        
        return headers
    }
    
    func getNearByBeacons(completion: @escaping (_ result: BeaconScanning) -> Void){
        let url = VicinityManager.url() + "/beacon?vicinity=\(CurrentLocation.coordinate.latitude),\(CurrentLocation.coordinate.longitude)&maxDistance=2000"
        print(url)
        NetworkModel.fetchData(url, header: getHeader() as NSDictionary, success: { (response) in
            guard let status = response["statusCode"] as? Int else {
                return
            }
            switch status {
            case 200:
                guard let responseData = response["data"] as? NSDictionary else {
                    return
                }
                if let documents = responseData["documents"] as? NSArray {
                    for beacon in documents{
                        self.saveBeacons(data: beacon as! NSDictionary)
                    }
                    if documents.count != 0{
                        completion(.StartScanning)

                    }else {
                        completion(.NoScanning)
                    }
                }
                
                break;
            default:break
            }
        }) { (error) in
            completion(.Failure)
            print(error)
        }
    }
    
    func saveBeacons(data:NSDictionary){
        let vicintyBeacon = VicinityBeacon()
        if let beaconData = data["beaconData"] as? NSDictionary {
            if let beaconlocation = beaconData["location"] as? NSDictionary{
                let location = RMCLocation()
                if let accuracy = beaconlocation["accuracy"] as? NSNumber{
                    location.accuracy = String(describing:accuracy )
 
                }
                
                if let altitude = beaconlocation["altitude"] as? NSNumber {
                    location.altitude = String(describing:altitude )
                    
                }
                if let coordinates = beaconlocation["coordinates"] as? [Double]{
                    location.longitude = String(coordinates[0])
                    location.latitude = String(coordinates[1])
                    print(coordinates[0])
                }
                print(location)
                vicintyBeacon.location = location
                
                
            }
            if let updatedOn = beaconData["updatedOn"] as? String {
                vicintyBeacon.updatedOn = updatedOn
            }
            if let address = beaconData["address"] as? String {
                vicintyBeacon.address = address
            }
            if let addedOn = beaconData["addedOn"] as? String {
                vicintyBeacon.addedOn = addedOn
            }
            if let beaconId = beaconData["beaconId"] as? String {
                vicintyBeacon.beaconId = beaconId
            }
            if let major = beaconData["major"] as? String {
                vicintyBeacon.major = major
            }
            if let minor = beaconData["minor"] as? String {
                vicintyBeacon.minor = minor
            }
            if let uuid = beaconData["uuid"] as? String {
                vicintyBeacon.uuid = uuid
            }
            
        }
         if let associationIds = data["associationIds"] as? NSDictionary {
            if let organizationId = associationIds["organizationId"] as? String {
                vicintyBeacon.organizationId = organizationId
            }
            if let placeId = associationIds["placeId"] as? String {
                vicintyBeacon.placeId = placeId
            }
        }
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(vicintyBeacon,update:true)
        }
    }
    func fetchBeaconsFromDb() ->Results<VicinityBeacon>{
        let realm = try! Realm()
        let beacons = realm.objects(VicinityBeacon.self)
        return beacons
    }
    
}
