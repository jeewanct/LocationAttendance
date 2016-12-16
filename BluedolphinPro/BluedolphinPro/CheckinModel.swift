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
        return  APIURL + ModuleUrl.Checkin.rawValue
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
            checkinData.assignmentId = value.assignmentId
            checkinData.checkinCategory = value.checkinCategory
            checkinData.checkinId = value.checkinId
            checkinData.checkinDetails = toDictionary(text: value.checkinDetails!) as! [String : AnyObject]?
            checkinData.checkinType = value.checkinType
            checkinData.imageUrl = value.imageUrl
            checkinData.time = value.time
            checkinData.organizationId = value.organizationId
            checkinData.imageStatus = value.imageStatus
            if checkinData.imageStatus == ImageStatus.Uploaded.rawValue {
               data.append(checkinData.asJson())
            }
            
            
        }
        let param = [
            //"userId":Singleton.sharedInstance.userId,
            "data":data
        
        ] as [String : Any]
        print(param)
        NetworkModel.submitData(CheckinModel.url()+Singleton.sharedInstance.organizationId, method: .post, params: param as [String : AnyObject], headers: self.getHeader(), success: { (responseData) in
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
        checkin.time = Date().formattedISO8601
        if checkin.checkinType == CheckinType.PhotCheckin.rawValue {
            checkin.imageStatus = ImageStatus.NotUploaded.rawValue
            checkin.relativeUrl = checkinData.relativeUrl
            
        }
        let realm = try! Realm()
        try! realm.write {
            realm.add(checkin, update: true)
        }

    }
    
}
