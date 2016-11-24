//
//  CheckinModel.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 01/11/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation
import RealmSwift

public class CheckinModel:Meta{
    internal static func url() -> String {
        return  APIURL + ModuleUrl.Checkin.rawValue
    }
    
    func getHeader()->[String:String]{
        let headers = [
            "Content-Type":"application/json",
            "Accept-Encoding":"application/gzip",
            "Accept":"application/json",
            "Authorization":"Bearer " + CoreSingleton.sharedInstance.accessToken
        ]
        
        return headers
    }
    
    
   
    
  public  func postCheckin(){
        let realm = try! Realm()
        let checkins = realm.objects(CheckinObject.self)
        var data = [NSDictionary]()
        for value in checkins{
            data.append(value.toDictionary())
        }
        let param = [
            "userId":CoreSingleton.sharedInstance.userId,
            "data":data
        
        ] as [String : Any]
        print(param)
        NetworkModel.submitData(CheckinModel.url()+CoreSingleton.sharedInstance.organizationId, method: .post, params: param as [String : AnyObject], headers: self.getHeader(), success: { (responseData) in
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
                guard let checkin = realm.objects(CheckinObject.self).filter("checkinId = %@",checkinId).first  else {
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
    
   public func createCheckin(checkinData:NSObject){
    
    

        
        let realm = try! Realm()
        try! realm.write {
            realm.create(CheckinObject.self, value: checkinData.asJson(), update: true)
        }

    }
    
}
