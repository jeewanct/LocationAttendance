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
        return  APIURL + ModuleUrl.Organisation.rawValue
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
    
    
    func getAssignments(assignmentId:String,completion: @escaping (_ result: String) -> Void){
        let url = AssignmentModel.url() + SDKSingleton.sharedInstance.organizationId + "/assignment?assignmentId=" + assignmentId
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
        

    }
    
    
    
    func getAssignments(status:String,completion: @escaping (_ result: String) -> Void){
        let url = AssignmentModel.url() + SDKSingleton.sharedInstance.organizationId + "/assignment?assigneeId=" + SDKSingleton.sharedInstance.userId
            //+ "?status=" + status
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
        
}
    
    func postdbAssignments(){
        let realm = try! Realm()
        let checkins = realm.objects(AssignmentObject.self)
        var data = [NSDictionary]()
        for value in checkins{
            let assignmentholder = AssignmentHolder()
            assignmentholder.accuracy = value.accuracy
            assignmentholder.altitude = value.altitude
    
            assignmentholder.assigneeIds = value.assigneeId?.components(separatedBy: ",")
            assignmentholder.longitude = value.longitude
            assignmentholder.latitude = value.latitude
            assignmentholder.assignmentAddress = value.assignmentAddress
            assignmentholder.assignmentDeadline = value.assignmentDeadline
            assignmentholder.assignmentStartTime = value.assignmentStartTime
            assignmentholder.assignmentId = value.assignmentId
            assignmentholder.status = value.status
            assignmentholder.organizationId = value.organizationId
            assignmentholder.assignmentDetails = toDictionary(text: value.assignmentDetails!) as! NSDictionary?
            assignmentholder.time = value.time
            
            data.append(assignmentholder.asJson())
        }
        if data.count == 0 {
            return
        }
        let param = [
            //"userId":SDKSingleton.sharedInstance.accessToken,
            "data":data
            
            ] as [String : Any]
        print (param)
        NetworkModel.submitData(AssignmentModel.url() + SDKSingleton.sharedInstance.organizationId + "/assignment", method: .post, params: param as [String : AnyObject], headers: self.getHeader(), success: { (responseData) in
            guard let statusCode = responseData["statusCode"] as? Int else {
                return
            }
            switch(statusCode){
            case 200:
                if let data = responseData["data"] as? NSArray{
                    for checkin in data{
                        self.checkAssignmentData(data: checkin as! NSDictionary )
                    }
                }
                
            default:
                break;
                
                
                
            }
        }) { (error) in
            print(error)
        }
    }
    
    
    func postAssignments(assignment:NSObject){
       
        var data = [NSDictionary]()
      
            data.append(assignment.asJson())
        
        let param = [
            //"userId":SDKSingleton.sharedInstance.accessToken,
            "data":data
            
            ] as [String : Any]
        print(param)
        NetworkModel.submitData(AssignmentModel.url() + SDKSingleton.sharedInstance.organizationId + "/assignment", method: .post, params: param as [String : AnyObject], headers: self.getHeader(), success: { (responseData) in
            print(responseData)
        }) { (error) in
            print(error)
        }
    }
    
    func checkAssignmentData(data:NSDictionary){
        guard let statusCode = data["statusCode"] as? Int else {
            return
        }
        switch statusCode{
        case 200,400,409:
            if let checkinId = data["assignmentId"] as? String{
                let realm = try! Realm()
                guard let checkin = realm.objects(AssignmentObject.self).filter("assignmentId = %@",checkinId).first  else {
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
    
    
    
    func createAssignment(assignmentData:AssignmentHolder){
        
        saveSelfAssignment(assignmentData: assignmentData)
        
        
        let assignment = AssignmentObject()
        assignment.accuracy = assignmentData.accuracy
        assignment.altitude = assignmentData.altitude
        assignment.assigneeId = assignmentData.assigneeIds?.joined(separator: ",")
        assignment.assignmentDetails = toJsonString( assignmentData.assignmentDetails!)
        assignment.assignmentId = assignmentData.assignmentId
        assignment.assignmentDeadline =  assignmentData.assignmentDeadline
        assignment.organizationId = assignmentData.organizationId
        assignment.status = assignmentData.status
        assignment.assignmentStartTime = assignmentData.assignmentStartTime
        assignment.latitude =  assignmentData.latitude
        assignment.longitude =  assignmentData.longitude
        assignment.assignmentAddress  = assignmentData.assignmentAddress
        assignment.time = assignmentData.time
        let realm = try! Realm()
        try! realm.write {
            realm.add(assignment,update:true)
        }
        
        
    }
    
    func getAssignmentFromDb(assignmentId:String)->Results<RMCAssignmentObject>{
        let realm = try! Realm()
        let assignments = realm.objects(RMCAssignmentObject.self).filter("assignmentId= %@",assignmentId)
        return assignments
        
    }
    
    func saveSelfAssignment(assignmentData:AssignmentHolder){
        let assignment = RMCAssignmentObject()
        
                let assigner = RMCAssignee()
                assigner.organizationId = assignmentData.organizationId
                assigner.userId =  assignmentData.assigneeIds?[0]
                assignment.assignerData = assigner
        
        if let assignmentDetails = assignmentData.assignmentDetails {
            if let jobNumber = assignmentDetails["jobNumber"] as? String{
                assignment.jobNumber = jobNumber
            }
            
            assignment.assignmentDetails = toJsonString(assignmentDetails)
        }
       
            assignment.addedOn = assignmentData.time
            assignment.assignmentDeadline = (assignmentData.assignmentDeadline)?.asDate
            assignment.assignmentAddress = assignmentData.assignmentAddress
            assignment.assignmentStartTime = (assignmentData.assignmentStartTime)?.asDate
            assignment.assignmentId = assignmentData.assignmentId
            assignment.status = assignmentData.status
            assignment.time = assignmentData.time
            assignment.updatedOn = assignmentData.time
        
            let location = RMCLocation()
                location.accuracy = assignmentData.accuracy
                location.altitude = assignmentData.altitude
                location.longitude = assignmentData.longitude
                location.latitude = assignmentData.latitude
                assignment.location = location
            if assignment.assignerData?.userId == SDKSingleton.sharedInstance.userId {
                assignment.selfAssignment = "true"
            }else {
                assignment.selfAssignment = "false"
            }
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(assignment,update:true)
        }
        
        
        if assignment.status == CheckinType.Assigned.rawValue {
            self.postDownloadedCheckin(assignmentId: assignment.assignmentId!)
            
        }
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
            if let jobNumber = assignmentDetails["jobNumber"] as? String{
               assignment.jobNumber = jobNumber
            }
            
            assignment.assignmentDetails = toJsonString(assignmentDetails)
        }
        if let assignmentData = assignmentData["assignmentData"] as? NSDictionary{
            assignment.addedOn = assignmentData["addedOn"] as? String
            assignment.assignmentDeadline = (assignmentData["assignmentDeadline"] as? String)?.asDate
            assignment.assignmentAddress = assignmentData["assignmentAddress"] as? String
            assignment.assignmentStartTime = (assignmentData["assignmentStartTime"] as? String)?.asDate
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
            if assignment.assignerData?.userId == SDKSingleton.sharedInstance.userId {
                assignment.selfAssignment = "true"
            }else {
                assignment.selfAssignment = "false"
            }
            
            
        }
        let realm = try! Realm()
        try! realm.write {
            realm.add(assignment,update:true)
        }
        
        
        if assignment.status == CheckinType.Assigned.rawValue {
            self.postDownloadedCheckin(assignmentId: assignment.assignmentId!)

        }
    }
    
    
    func postDownloadedCheckin(assignmentId:String){
        
        let checkin = CheckinHolder()
        
        checkin.checkinDetails = [:]
        checkin.checkinCategory = CheckinCategory.NonTransient.rawValue
        checkin.checkinType = CheckinType.Downloaded.rawValue
        checkin.assignmentId = assignmentId
        let checkinModelObject = CheckinModel()
        checkinModelObject.createCheckin(checkinData: checkin)
        if isInternetAvailable(){
            checkinModelObject.postCheckin()
        }
        let delay = 3.0 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
        self.updateAssignment(id:assignmentId , type: AssignmentWork.Downloaded, value: Date().formattedISO8601, status: CheckinType.Downloaded)
        })
        
    }
    

    
    func updateAssignment(id:String,type:AssignmentWork,value:String,status:CheckinType){
        let realm = try! Realm()
        let assignment = realm.objects(RMCAssignmentObject.self).filter("assignmentId = %@",id).first
            try! realm.write {
            assignment!.status = status.rawValue
        }
        switch status {
        case .Downloaded:
            try! realm.write {
                assignment!.downloadedOn = Date()
            }
            
        case .Submitted :
            try! realm.write {
                assignment!.submittedOn = Date()
            }
        case .Inprogress,.PhotoCheckin:
            try! realm.write {
                assignment!.lastUpdated = Date()
            }
        default:
            try! realm.write {
                assignment!.lastUpdated = Date()
            }
        }
        
        
        if let data = assignment?.assignmentDetails{
             let assignmentdetail = NSMutableDictionary(dictionary:  toDictionary(text: data) as! NSDictionary)
            let currentUpdate = [type.rawValue:value]
            assignmentdetail.addEntries(from: currentUpdate)
            try! realm.write {
            assignment?.assignmentDetails = toJsonString(assignmentdetail as AnyObject)
            }
            
            

        }else{
            let currentUpdate = [type.rawValue:value]
            try! realm.write {
            assignment?.assignmentDetails = toJsonString(currentUpdate as AnyObject)
            }
        }
        
        if let statusLogString = assignment?.assignmentStatusLog {
            let statusLog = NSMutableArray(object:  toDictionary(text: statusLogString)!)
            
            var currentUpdate = Dictionary<String,Any>()
                currentUpdate["time"] = Date().formattedISO8601
            currentUpdate["status"] = status.rawValue
            currentUpdate["assignmentDetail"] = assignment?.assignmentDetails
            currentUpdate["type"] = type.rawValue
            statusLog.add(currentUpdate)
            try! realm.write {
            assignment?.assignmentStatusLog = toJsonString(statusLog)
            }
            
        }else {
            var currentUpdate = Dictionary<String,Any>()
            currentUpdate["time"] = Date().formattedISO8601
            currentUpdate["status"] = status.rawValue
            currentUpdate["assignmentDetail"] = assignment?.assignmentDetails
            currentUpdate["type"] = type.rawValue
            let statusLog = NSMutableArray()
            statusLog.add(currentUpdate)
            try! realm.write {
                assignment?.assignmentStatusLog = toJsonString(statusLog)
            }
        }
        
    }

}






