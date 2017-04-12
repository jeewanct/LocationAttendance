//
//  CheckinModel.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 01/11/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation
import RealmSwift

public func getUUIDString()->String{
    return UUID().uuidString
}

 class CheckinModel:NSObject, Meta{
    internal static func url() -> String {
        return  APIURL + ModuleUrl.Organisation.rawValue + SDKSingleton.sharedInstance.organizationId + ModuleUrl.Checkin.rawValue
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
    
    
    
    
   public func postCheckin(checkinId:String = ""){
        let realm = try! Realm()
        var checkins = realm.objects(RMCCheckin.self)
        if checkinId != "" {
            checkins = checkins.filter("checkinId = %@",checkinId)
        }
        var checkinsDataArray = [NSDictionary]()
        for value in checkins{
            let checkinData = CheckinHolder()
            checkinData.accuracy = value.accuracy
            checkinData.altitude = value.altitude
            checkinData.longitude = value.longitude
            checkinData.latitude = value.latitude
            checkinData.assignmentId = value.assignmentId
            checkinData.checkinCategory = value.checkinCategory
            checkinData.checkinId = value.checkinId
            checkinData.checkinDetails = toDictionary(text: value.checkinDetails!) as! [String : AnyObject]?
            checkinData.checkinType = value.checkinType
            checkinData.imageUrl = value.imageUrl
            checkinData.time = value.time
            checkinData.organizationId = value.organizationId
                    //checkinData.imageName = value.imageName
            if checkinData.checkinType == CheckinType.PhotoCheckin.rawValue && checkinData.imageUrl == nil {
               
            }else if checkinData.checkinType == CheckinType.Beacon.rawValue{
                var beconArray = Array<NSDictionary>()
                for becon in value.beaconProximity {
                    print(becon)
                    
                    beconArray.append(becon.toDictionary())
                }
                checkinData.beaconProximities = beconArray
                print(checkinData.beaconProximities!)
                checkinsDataArray.append(checkinData.asJson())

            }
            
            else {
                checkinsDataArray.append(checkinData.asJson())
            }
            
            
        }
        if checkinsDataArray.count == 0 {
            return
        }
        let checkinchunks = checkinsDataArray.chunk(20)
        for elements in checkinchunks{
            sendCheckin(data:elements )
        }
    }
    
    func sendCheckin(data:[NSDictionary]){
        let param = [
            //"userId":SDKSingleton.sharedInstance.userId,
            "data":data
            
            ] as [String : Any]
        print(param)
        
        NetworkModel.submitData(CheckinModel.url(), method: .post, params: param as [String : AnyObject], headers: self.getHeader(), success: { (responseData) in
            guard let statusCode = responseData["statusCode"] as? Int else {
                return
            }
            switch(statusCode){
            case 200:
                if let data = responseData["data"] as? NSArray{
                    for checkin in data{
                        self.checkCheckinData(data: checkin as! NSDictionary )
                    }
                }
                
            default:
                break;
                
                
                
            }
            
        }) { (error) in
            print(error)
        }
        
    }
    
    
    func checkCheckinData(data:NSDictionary){
        guard let statusCode = data["statusCode"] as? Int else {
            return
        }
        switch statusCode{
        case 200,400,409:
            if let checkinId = data["checkinId"] as? String{
                let realm = try! Realm()
                guard let checkin = realm.objects(RMCCheckin.self).filter("checkinId = %@",checkinId).first  else {
                    return
                }
                try! realm.write {
                    realm.delete(checkin)
                }
            }
        default:
            break;
        }

        
        
    }
    
   public func createCheckin(checkinData:CheckinHolder){
    
        let realm = try! Realm()
        let checkin = RMCCheckin()
        var checkinDetails = checkinData.checkinDetails!
        checkinDetails[AssignmentWork.AppVersion.rawValue] = AppVersion as AnyObject?
        checkinDetails[AssignmentWork.UserAgent.rawValue] = deviceType as AnyObject?
        
        checkin.checkinDetails = toJsonString(checkinDetails as AnyObject)
        checkin.accuracy = CurrentLocation.accuracy
        checkin.altitude = CurrentLocation.altitude
        checkin.latitude = String(CurrentLocation.coordinate.latitude)
        checkin.longitude = String(CurrentLocation.coordinate.longitude)
        checkin.assignmentId = checkinData.assignmentId
        checkin.checkinCategory = checkinData.checkinCategory
        checkin.checkinId = getUUIDString()
        checkin.organizationId = SDKSingleton.sharedInstance.organizationId
        checkin.checkinType = checkinData.checkinType
        checkin.jobNumber = checkinData.jobNumber
        checkin.time = getCurrentDate().formattedISO8601
        if checkin.checkinType == CheckinType.PhotoCheckin.rawValue {
            checkin.imageName = checkinData.imageName
            checkin.relativeUrl = checkinData.relativeUrl
            
        }else if checkin.checkinType == CheckinType.Beacon.rawValue {
            let beconList = List<RMCBeacon>()
            for data in checkinData.beaconProximities!{
                if let dataDict = data as? [String:Any] {
                    let major = dataDict["major"] as! String
                    let minor = dataDict["minor"] as! String
                    let uuid = (dataDict["uuid"] as! String).uppercased()
                    if let vicinitybeacon =  realm.objects(VicinityBeacon.self).filter("major = %@ AND minor = %@ AND uuid = %@",major,minor,uuid).first  {
                        print(vicinitybeacon)
                        let beconObject = RMCBeacon()
                        beconObject.beaconId = vicinitybeacon.beaconId
                        beconObject.major = vicinitybeacon.major
                        beconObject.minor = vicinitybeacon.minor
                        beconObject.uuid = vicinitybeacon.uuid
                        beconObject.rssi = dataDict["rssi"] as? String
                        beconObject.distance = dataDict["distance"] as? String
                        beconObject.lastseen = dataDict["lastseen"] as? String
                        beconList.append(beconObject)
                    }
                }
                
            }
            checkin.beaconProximity = beconList
        }
        try! realm.write {
            realm.add(checkin, update: true)
        }

    }
   
    
//    public func updatePhotoCheckin(){
//        let realm = try! Realm()
//        var checkins = realm.objects(RMCCheckin.self)
//        var customAlbum :CustomPhotoAlbum?
//        var checkinId = String()
//        checkins = checkins.filter("checkinType=%@",CheckinType.PhotoCheckin.rawValue)
//        for data in checkins {
//            if let checkinDetails = data.checkinDetails?.parseJSONString as? NSDictionary{
//                if let number = checkinDetails["jobNumber"] as? String{
//                    customAlbum = CustomPhotoAlbum(name: number)
//                }
//            }
//            checkinId = data.checkinId!
//            if let id = data.relativeUrl
//            {
//                customAlbum?.fetchPhoto(localIdentifier: id, completion: { (image) in
//                    let manager = AWSS3Manager()
//                    manager.configAwsManager()
//                    manager.sendFile(imageName: data.imageName!, image: image, extention: "jpg", completion: { (url) in
//                        let realm = try! Realm()
//                        if let currentcheckin = realm.objects(RMCCheckin.self).filter("checkinId=%@",checkinId).first{
//                            try! realm.write {
//                                currentcheckin.imageUrl = url
//                                currentcheckin.relativeUrl = ""
//                            }
//                        }
//                        
//                    })
//                    
//                })
//            }
//
//        }
//        
//        
//    }
    
    
    
}
