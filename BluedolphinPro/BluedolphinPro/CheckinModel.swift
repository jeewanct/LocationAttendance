//
//  CheckinModel.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 01/11/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation
import RealmSwift

class CheckinModel:Meta{
    internal static func url() -> String {
        return  APIURL + ModuleUrl.Checkin.rawValue
    }
    
    func getHeader()->[String:String]{
        let headers = [
            "Content-Type":"application/json",
            "Accept-Encoding":"application/gzip",
            "Accept":"application/json",
            "Authorization":"Bearer " + Singleton.sharedInstance.accessToken
        ]
        
        return headers
    }
    
    
    
    
    func postCheckin(){
        let realm = try! Realm()
        let checkins = realm.objects(RMCCheckin.self)
        var data = [NSDictionary]()
        for value in checkins{
            data.append(value.toDictionary())
        }
        let param = [
            "userId":Singleton.sharedInstance.userId,
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
    
    

        
        let realm = try! Realm()
        try! realm.write {
            realm.create(RMCCheckin.self, value: checkinData.asJson(), update: true)
        }

    }
    
}
