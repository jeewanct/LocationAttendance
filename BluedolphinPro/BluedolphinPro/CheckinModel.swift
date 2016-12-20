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
        var data = [NSDictionary]()
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
            if checkinData.checkinType == CheckinType.PhotCheckin.rawValue && checkinData.imageUrl == nil {
               
            }else {
                data.append(checkinData.asJson())
            }
            
            
        }
        print (data)
        if data.count == 0 {
            return
        }
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
        case 200:
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
        if checkin.checkinType == CheckinType.PhotCheckin.rawValue {
            checkin.imageName = checkinData.imageName
            checkin.relativeUrl = checkinData.relativeUrl
            
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
        
        checkins = checkins.filter("checkinType=%@",CheckinType.PhotCheckin.rawValue)
        for data in checkins {
            if let checkinDetails = data.checkinDetails?.parseJSONString as? NSDictionary{
                if let number = checkinDetails["jobNumber"] as? String{
                    customAlbum = CustomPhotoAlbum(name: number)
                    //data.jobNumber
                }
            }
            if let id = data.relativeUrl
            {
                customAlbum?.fetchPhoto(localIdentifier: id, completion: { (image) in
                    let manager = AWSS3Manager()
                    manager.configAwsManager()
                    manager.sendFile(imageName: data.imageName!, image: image, extention: "png", completion: { (url) in
                        try! realm.write {
                            data.imageUrl = url
                        }
                    })
                    
                })
            }
            
           
            
            
        }
        
        
    }
    
    
    
}
