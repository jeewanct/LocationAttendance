//
//  UserDeviceModel.swift
//  BluedolphinCloudSdk
//
//  Created by Raghvendra on 31/08/17.
//  Copyright © 2017 raremediacompany. All rights reserved.
//

import Foundation

enum DObject:String{
    case shift
}

open class UserDeviceModel:NSObject, Meta{
    internal static func url() -> String {
        return  APIURL + ModuleUrl.Organisation.rawValue + SDKSingleton.sharedInstance.organizationId +  "/" + ModuleUrl.User.rawValue
    }
    
    class func getHeader()->[String:String]{
        let headers = [
            "Content-Type":"application/json",
            "Accept-Encoding":"application/gzip",
            "Accept":"application/json",
            "Authorization":"Bearer " + SDKSingleton.sharedInstance.accessToken,
            "userId":SDKSingleton.sharedInstance.userId
        ]
        return headers
    }
    
     public class  func getDeviceStatus(completion: @escaping (_ result: String,_ imeid:String) -> Void){
            let url = UserDeviceModel.url() + SDKSingleton.sharedInstance.userId + "?device=\(true)"
            NetworkModel.fetchData(url, header: getHeader() as NSDictionary, success: { (response) in
                guard let status = response["statusCode"] as? Int else {
                    return
                }
                switch status {
                case 200:
                    if let data = response["data"] as? NSArray {
                        for valueData  in data{
                            let valueDatadict = valueData as! NSDictionary
                            if let documents = valueDatadict["documents"] as? NSArray {
                                
                                for document in documents{
                                    let documentDict = document as! NSDictionary
                                    if let imeid = documentDict["imeiId"] as? String{
                                        completion(APIResult.Success.rawValue,imeid)
                                    }else{
                                        completion(APIResult.Success.rawValue,"")
                                    }
                                }
                                
                            }
                        }
                    }
                case 401:
                    
                    completion(APIResult.InvalidCredentials.rawValue,"")
                case 403:
                    completion(APIResult.UserInteractionRequired.rawValue,"")
                    
                case 409:
                    completion(APIResult.InvalidData.rawValue,"")
                case 500...502:
                    completion(APIResult.InternalServer.rawValue,"")
                    
                default:break
                }
                
                
                
                
            }) { (error) in
                print(error)
            }
        }
    
    public class  func getDObjectsShift(completion: @escaping (_ result: String,_ imeid:String) -> Void){
        let url = UserDeviceModel.url() + SDKSingleton.sharedInstance.userId + "?dObject=\(true)"
        NetworkModel.fetchData(url, header: getHeader() as NSDictionary, success: { (response) in
            guard let status = response["statusCode"] as? Int else {
                return
            }
            switch status {
            case 200:
                if let data = response["data"] as? NSArray {
                    for valueData  in data{
                        let valueDatadict = valueData as! NSDictionary
                        if let documents = valueDatadict["documents"] as? NSArray {
                            
                            for document in documents{
                                let documentDict = document as! NSDictionary
                                if let dObjectData = documentDict["dObjectData"] as? NSDictionary{
                                    if let objectName = dObjectData["objectName"] as? String{
                                        switch objectName {
                                        case DObject.shift.rawValue:
                                            processShiftData(dobject: documentDict)
                                            break
                                        default:
                                            break
                                        }
                                        
                                    }
                                }
                            }
                            
                        }
                    }
                }
            case 401:
                
                completion(APIResult.InvalidCredentials.rawValue,"")
            case 403:
                completion(APIResult.UserInteractionRequired.rawValue,"")
                
            case 409:
                completion(APIResult.InvalidData.rawValue,"")
            case 500...502:
                completion(APIResult.InternalServer.rawValue,"")
                
            default:break
            }
            
            
            
            
        }) { (error) in
            print(error)
        }
    }
    
   public class func processShiftData(dobject:NSDictionary){
    
        if let dObjectData = dobject["dObjectData"] as? NSDictionary{
            let shiftObject = UserShift(object: dObjectData)
            
            
            UserDefaults.standard.set(shiftObject.startMin, forKey: UserDefaultsKeys.BDShiftStartMin.rawValue)
            UserDefaults.standard.set(shiftObject.startHr, forKey: UserDefaultsKeys.BDShiftStartHour.rawValue)
            UserDefaults.standard.set(shiftObject.endMin, forKey: UserDefaultsKeys.BDShiftEndMin.rawValue)
            UserDefaults.standard.set(shiftObject.endHr, forKey: UserDefaultsKeys.BDShiftEndHour.rawValue)
            UserDefaults.standard.set(shiftObject.duration, forKey: UserDefaultsKeys.BDShiftDuration.rawValue)
            
            
        }
     if let dObjectDetails = dobject["dObjectDetails"] as? NSDictionary{
        if let workingDays = dObjectDetails["workingDays"] as? NSArray{
            for workingDaysObject in workingDays{
                let dayObject = workingDaysObject as! NSDictionary
                if let weekDays = dayObject["weekDays"] as? NSArray{
                   UserDefaults.standard.set(weekDays, forKey: UserDefaultsKeys.BDWorkingDays.rawValue)
                }
            }
        }
    }
    

}
    
    
}
      
