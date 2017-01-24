//
//  SelfAssignmentViewController.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 12/12/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import UIKit
import XLForm
import RealmSwift

class SelfAssignmentViewController:XLFormViewController  {
    var uuidString = String()
    fileprivate struct Tags {
        static let StartDate = "startDate"
        static let EndDate = "endDate"
        static let StartTime = "startTime"
        static let EndTime = "endTime"
        static let Name = "name"
        static let Email = "email"
        static let Address = "address"
        static let PhoneNumber = "number"
        static let ContactPerson = "contactPerson"
        static let TextView = "textView"
        static let Notes = "notes"
    }
    var changeSegment : SegmentChanger?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Create Assignments"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(SelfAssignmentViewController.cancelPressed(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(SelfAssignmentViewController.savePressed(_:)))
        self.tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length,
                                                       self.tableView.contentInset.left,
                                                       self.tableView.contentInset.bottom,
                                                       self.tableView.contentInset.right);

        // Do any additional setup after loading the view.
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        initializeForm()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeForm()
    }
    func cancelPressed(_:UIButton){
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func savePressed(_:UIButton){
        let data =  form.formValues()
        uuidString = getUUIDString()
        let assignmentObject = AssignmentHolder()
        assignmentObject.accuracy = CurrentLocation.accuracy
        assignmentObject.altitude = CurrentLocation.altitude
        assignmentObject.longitude = String(CurrentLocation.coordinate.longitude)
        assignmentObject.latitude = String(CurrentLocation.coordinate.latitude)
        assignmentObject.assignmentId = uuidString
        assignmentObject.assigneeIds  = [SDKSingleton.sharedInstance.userId]
        assignmentObject.assignmentAddress = data["address"] as? String
        assignmentObject.assignmentDeadline = "\(data["endDate"]!)"
        assignmentObject.assignmentStartTime = "\(data["startDate"]!)"
        assignmentObject.organizationId = SDKSingleton.sharedInstance.organizationId
        assignmentObject.time = Date().formattedISO8601
        assignmentObject.status = CheckinType.Assigned.rawValue
        
        assignmentObject.assignmentDetails = [
            "mobile":data["number"]!,
            "contactPerson":data["contactPerson"]!,
            "instructions":"Firebase push",
            "email":data["email"]!,
            "jobNumber":getJobNumber()
        
        ]
        let assignmentModel = AssignmentModel()
        assignmentModel.postAssignments(assignment: assignmentObject)
    
        if let delegate = self.changeSegment {
            delegate.moveToSegment(CheckinType.Assigned.rawValue)
        }
        self.dismiss(animated: true, completion: nil)

        

    }
    func getJobNumber()->String{
        let realm = try! Realm()
        let tokenObject = realm.objects(AccessTokenObject.self).filter("organizationId=%@",SDKSingleton.sharedInstance.organizationId).first
        let organisationName  = tokenObject?.organizationName
        
        let jobNumber = organisationName![0..<4].uppercased() + "-" + uuidString[0..<4]
        return jobNumber
        
    }

    func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        form = XLFormDescriptor()
        form.assignFirstResponderOnShow = true
        section = XLFormSectionDescriptor()
        
      
        form.addFormSection(section)
        row = XLFormRowDescriptor(tag: Tags.Name, rowType: XLFormRowDescriptorTypeText, title: "Name")
        row.isRequired = true
        section.addFormRow(row)
        row = XLFormRowDescriptor(tag: Tags.Address, rowType: XLFormRowDescriptorTypeSelectorPush, title: "Address")
        row.value = CurrentLocation.address
        row.isRequired = true
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.ContactPerson, rowType: XLFormRowDescriptorTypeText, title: "Contact Person")
        row.isRequired = true
        section.addFormRow(row)
        row = XLFormRowDescriptor(tag: Tags.PhoneNumber, rowType: XLFormRowDescriptorTypePhone, title: "Phone Number")
        
        row.isRequired = true
        section.addFormRow(row)
        row = XLFormRowDescriptor(tag: Tags.Email, rowType: XLFormRowDescriptorTypeEmail, title: "Email")
        // validate the email
        row.addValidator(XLFormValidator.email())
        row.isRequired = true
        section.addFormRow(row)
        // Date
        row = XLFormRowDescriptor(tag: Tags.StartDate, rowType: XLFormRowDescriptorTypeDateTime, title:"Start Date")
        row.value = Date()
        section.addFormRow(row)
        row = XLFormRowDescriptor(tag: Tags.EndDate, rowType: XLFormRowDescriptorTypeDateTime, title:"End Date")
        row.value = Date()
        section.addFormRow(row)
        
//        // Time
//        row = XLFormRowDescriptor(tag: Tags.StartTime, rowType: XLFormRowDescriptorTypeTime, title: "From")
//        row.value = Date()
//
//        section.addFormRow(row)
//        row = XLFormRowDescriptor(tag: Tags.EndTime, rowType: XLFormRowDescriptorTypeTime, title: "To")
//        row.value = Date()
//        section.addFormRow(row)
        
        
        
        self.form = form
}
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return UIView()
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
