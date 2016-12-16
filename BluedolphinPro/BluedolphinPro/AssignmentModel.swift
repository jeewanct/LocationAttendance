//
//  Assignments.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 02/11/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation
import RealmSwift

class AssignmentModel :Meta{
    internal static func url() -> String {
        return  APIURL + ModuleUrl.Assignment.rawValue
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
    
    
    func getAssignments(assignmentId:String,completion: @escaping (_ result: String) -> Void){
        let url = AssignmentModel.url() + Singleton.sharedInstance.organizationId + "/assignment?assignmentId=" + assignmentId
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
                    for data in documents{
                      self.saveAssignment(assignmentData: data as! NSDictionary)
                    }
                }
                
                break;
            default:break
            }
        }) { (error) in
            
            print(error)
        }
        
        //        NetworkModel.submitData(url, method: .get, params: [:], headers: self.getHeader(), success: { (responseData) in
//            
//        }) { (error) in
//            print(error)
//        }
    }
    
    func postAssignments(){
        let realm = try! Realm()
        let checkins = realm.objects(AssignmentObject.self)
        var data = [NSDictionary]()
        for value in checkins{
            data.append(value.toDictionary())
        }
        let param = [
            //"userId":Singleton.sharedInstance.accessToken,
            "data":data
            
            ] as [String : Any]
        
        NetworkModel.submitData(AssignmentModel.url(), method: .put, params: param as [String : AnyObject], headers: self.getHeader(), success: { (responseData) in
            print(responseData)
        }) { (error) in
            print(error)
        }
    }
    
    func createAssignment(assignmentData:[String:String]){
        
        
        let assignment = AssignmentObject()
        
        assignment.accuracy = assignmentData["accuracy"]
        assignment.altitude = assignmentData["altitude"]
        assignment.assigneeId = assignmentData["assigneeId"]
        assignment.assignmentDetails = assignmentData["assignmentDetails"]
        assignment.assignmentId = assignmentData["assignmentId"]
        assignment.assignmentDeadline =  assignmentData["assignmentDeadline"]
        assignment.organizationId = assignmentData["organizationId"]
        assignment.status = assignmentData["status"]
        assignment.latitude =  assignmentData["latitude"]
        assignment.longitude =  assignmentData["longitude"]
        let realm = try! Realm()
        try! realm.write {
            realm.add(assignment,update:true)
        }
        
    }
    
    func getAssignmentFromDb()->Results<RMCAssignmentObject>{
        let realm = try! Realm()
        let assignments = realm.objects(RMCAssignmentObject.self)
       return assignments
        
    }
    func saveAssignment(assignmentData:NSDictionary){
        let assignment = RMCAssignmentObject()
        if let associationId = assignmentData["associationIds"] as? NSDictionary{
            assignment.assigneeData = ArrayTransform().transformFromJSON( associationId["assigneeData"])!
            if let assignerData = associationId["assignerData"] as? NSDictionary {
                let assigner = RMCAssignee()
                assigner.organizationId = assignerData["organizationId"] as? String
                assigner.userId =  assignerData["userId"] as? String
                assignment.assignerData = assigner
            }
        }
        if let assignmentDetails = assignmentData["assignmentDetails"] as? NSDictionary{
            assignment.assignmentDetails = toJsonString(assignmentDetails)
        }
        if let assignmentData = assignmentData["assignmentData"] as? NSDictionary{
            assignment.addedOn = assignmentData["addedOn"] as? String
            assignment.assignmentDeadline = assignmentData["assignmentDeadline"] as? String
            assignment.assignmentId = assignmentData["assignmentId"] as? String
            assignment.status = assignmentData["status"] as? String
            assignment.time = assignmentData["time"] as? String
            assignment.updatedOn = assignmentData["updatedOn"] as? String
            if let assignmentlocation = assignmentData["location"] as? NSDictionary{
                let location = RMCLocation()
                location.accuracy = String(describing: assignmentlocation["accuracy"] as! NSNumber)
               
                location.altitude = String(describing: assignmentlocation["altitude"] as! NSNumber)
                
                if let coordinates = assignmentlocation["coordinates"] as? [Double]{
                    location.longitude = String(coordinates[0])
                    location.latitude = String(coordinates[1])
                    print(coordinates[0])
                }
                print(location)
                assignment.location = location
            }
            
        }
        let realm = try! Realm()
        try! realm.write {
            realm.add(assignment,update:true)
        }
    }
    
    func updateAssignment(id:String,type:AssignmentWork,value:String,status:CheckinType){
        let realm = try! Realm()
        let assignment = realm.objects(RMCAssignmentObject.self).filter("assignmentId = %@",id).first
        assignment?.status = status.rawValue
        if let data = assignment?.assignmentDetails{
             let assignmentdetail =
                 toDictionary(text: data) as! NSMutableDictionary
            let currentUpdate = [type.rawValue:value]
            assignmentdetail.addEntries(from: currentUpdate)
            assignment?.assignmentDetails = toJsonString(assignmentdetail as AnyObject)
            
            

        }else{
            let currentUpdate = [type.rawValue:value]
            assignment?.assignmentDetails = toJsonString(currentUpdate as AnyObject)
        }
        
        if let statusLogString = assignment?.statusLog {
            let statusLog = toDictionary(text: statusLogString) as! NSMutableArray
            var currentUpdate = Dictionary<String,Any>()
                currentUpdate["time"] = Date().formattedISO8601
            currentUpdate["status"] = status.rawValue
            currentUpdate["assignmentDetail"] = assignment?.assignmentDetails
            currentUpdate["type"] = type.rawValue
            statusLog.add(currentUpdate)
            assignment?.statusLog = toJsonString(statusLog)
            
        }
        
        try! realm.write {
            realm.add(assignment!, update: true)
        }
        
        
       
        
        
        
        
        
    }

}






