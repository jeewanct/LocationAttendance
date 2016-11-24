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
            "Authorization":"Bearer " + Singleton.sharedInstance.accessToken
        ]
        
        return headers
    }
    
    
    func getAssignments(){
        
    }
    
    func postAssignments(){
        let realm = try! Realm()
        let checkins = realm.objects(AssignmentObject.self)
        var data = [NSDictionary]()
        for value in checkins{
            data.append(value.toDictionary())
        }
        let param = [
            "userId":Singleton.sharedInstance.accessToken,
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

}




