//
//  CheckinModel.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 01/11/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation
import RealmSwift

func getUUIDString()->String{
    return UUID().uuidString
}

class CheckinModel:Meta{
    internal static func url() -> String {
        return  APIURL + ModuleUrl.Organisation.rawValue + Singleton.sharedInstance.organizationId + ModuleUrl.Checkin.rawValue
    }
    
    func getHeader()->[String:String]{
        let headers = [
            "Content-Type":"application/json",
            "Accept-Encoding":"application/gzip",
            "Accept":"application/json",
            "Authorization":"Bearer " + Singleton.sharedInstance.accessToken,
            "userId":Singleton.sharedInstance.userId
        ]
        
        return headers
    }
    
    
    
    
    func postCheckin(){
        let realm = try! Realm()
        let checkins = realm.objects(RMCCheckin.self)
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
               
            }else if checkinData.checkinType == CheckinType.Data.rawValue{
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
        print (checkinsDataArray)
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
            //"userId":Singleton.sharedInstance.userId,
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
        case 200,400:
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
    
    func createCheckin(checkinData:CheckinHolder){
        let checkin = RMCCheckin()
        checkin.checkinDetails = toJsonString(checkinData.checkinDetails as AnyObject)
        checkin.accuracy = CurrentLocation.accuracy
        checkin.altitude = CurrentLocation.altitude
        checkin.latitude = String(CurrentLocation.coordinate.latitude)
        checkin.longitude = String(CurrentLocation.coordinate.longitude)
        checkin.assignmentId = checkinData.assignmentId
        checkin.checkinCategory = checkinData.checkinCategory
        checkin.checkinId = getUUIDString()
        checkin.organizationId = Singleton.sharedInstance.organizationId
        checkin.checkinType = checkinData.checkinType
        checkin.jobNumber = checkinData.jobNumber
        checkin.time = Date().formattedISO8601
        if checkin.checkinType == CheckinType.PhotoCheckin.rawValue {
            checkin.imageName = checkinData.imageName
            checkin.relativeUrl = checkinData.relativeUrl
            
        }else if checkin.checkinType == CheckinType.Data.rawValue {
            let beconList = List<RMCBeacon>()
            for data in checkinData.beaconProximities!{
                let beconObject = RMCBeacon.mapToRMCBeacon(dict: data as! NSDictionary)
                
                beconList.append(beconObject)
                
            }
            
            checkin.beaconProximity = beconList
        }
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(checkin, update: true)
        }
        

        
        

    }
    func updatePhotoCheckin(){
        let realm = try! Realm()
         var checkins = realm.objects(RMCCheckin.self)
        print(checkins)
        var customAlbum :CustomPhotoAlbum?
        var checkinId = String()
        checkins = checkins.filter("checkinType=%@",CheckinType.PhotoCheckin.rawValue)
        for data in checkins {
            if let checkinDetails = data.checkinDetails?.parseJSONString as? NSDictionary{
                if let number = checkinDetails["jobNumber"] as? String{
                    customAlbum = CustomPhotoAlbum(name: number)
                    //data.jobNumber
                }
            }
            checkinId = data.checkinId!
            if let id = data.relativeUrl
            {
                customAlbum?.fetchPhoto(localIdentifier: id, completion: { (image) in
                    let manager = AWSS3Manager()
                    manager.configAwsManager()
                    manager.sendFile(imageName: data.imageName!, image: image, extention: "png", completion: { (url) in
                        let realm = try! Realm()
                        if let currentcheckin = realm.objects(RMCCheckin.self).filter("checkinId=%@",checkinId).first{
                            try! realm.write {
                                currentcheckin.imageUrl = url
                                currentcheckin.relativeUrl = ""
                            }
                        }
                        
                    })
                    
                })
            }
            
           
            
            
        }
        
        
    }
    
    
    
}
