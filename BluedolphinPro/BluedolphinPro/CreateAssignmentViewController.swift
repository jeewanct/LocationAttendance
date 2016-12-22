//
//  CreateAssignmentViewController.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 22/12/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import UIKit
import RealmSwift

class CreateAssignmentViewController: UIViewController {
    @IBOutlet weak var nameTextfield: UITextField!

    @IBOutlet weak var endDateTextfield: UITextField!
    @IBOutlet weak var startDateTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var phoneNumberTextfield: UITextField!
    @IBOutlet weak var contactPersonTextfield: UITextField!
    @IBOutlet weak var addressTextfield: UITextField!
    var uuidString = String()
    var activeTextfield = UITextField()
     var changeSegment : SegmentChanger?
    var assignmentStartdate = String()
    var assignmentEnddate = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Create Assignments"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(CreateAssignmentViewController.cancelPressed(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(CreateAssignmentViewController.savePressed(_:)))
        setDelegate()
        // Do any additional setup after loading the view.
    }

    func setDelegate(){
        nameTextfield.delegate = self
        addressTextfield.delegate = self
        contactPersonTextfield.delegate = self
        phoneNumberTextfield.delegate = self
        emailTextfield.delegate = self
        startDateTextfield.delegate = self
        endDateTextfield.delegate = self
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChanged(sender:)), for: UIControlEvents.valueChanged)
        startDateTextfield.inputView = datePicker
        endDateTextfield.inputView = datePicker
        
        addressTextfield.text = CurrentLocation.address
        nameTextfield.isUserInteractionEnabled = false
        addressTextfield.isUserInteractionEnabled = false
        nameTextfield.text = Singleton.sharedInstance.userName.capitalized
        
        
    }
    func cancelPressed(_:UIButton){
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func savePressed(_:UIButton){
        
        createAssignment()
        
        
    }
    func getJobNumber()->String{
        let realm = try! Realm()
        let tokenObject = realm.objects(AccessTokenObject.self).filter("organizationId=%@",Singleton.sharedInstance.organizationId).first
        let organisationName  = tokenObject?.organizationName
        
        let jobNumber = organisationName![0..<4].uppercased() + "-" + uuidString[0..<4]
        return jobNumber
        
    }
    
    func createAssignment(){
        uuidString = getUUIDString()
        let assignmentObject = AssignmentHolder()
        assignmentObject.accuracy = CurrentLocation.accuracy
        assignmentObject.altitude = CurrentLocation.altitude
        assignmentObject.longitude = String(CurrentLocation.coordinate.longitude)
        assignmentObject.latitude = String(CurrentLocation.coordinate.latitude)
        assignmentObject.assignmentId = uuidString
        assignmentObject.assigneeIds  = [Singleton.sharedInstance.userId]
        assignmentObject.assignmentAddress = addressTextfield.text!
        assignmentObject.assignmentDeadline = assignmentEnddate
        assignmentObject.assignmentStartTime = assignmentStartdate
        assignmentObject.organizationId = Singleton.sharedInstance.organizationId
        assignmentObject.time = Date().formattedISO8601
        assignmentObject.status = CheckinType.Assigned.rawValue
        
        assignmentObject.assignmentDetails = [
            "mobile":phoneNumberTextfield.text!,
            "contactPerson":contactPersonTextfield.text!,
            "instructions":"Firebase push",
            "email":emailTextfield.text!,
            "jobNumber":getJobNumber()
            
        ]
        let assignmentModel = AssignmentModel()
        assignmentModel.postAssignments(assignment: assignmentObject)
        
        if let delegate = self.changeSegment {
            delegate.moveToSegment(CheckinType.Assigned.rawValue)
        }
        self.dismiss(animated: true, completion: nil)
    }
    func dateChanged(sender:UIDatePicker){
        activeTextfield.text = sender.date.formatted
        switch activeTextfield {
        case startDateTextfield:
            assignmentStartdate = sender.date.formattedISO8601
        case endDateTextfield:
            assignmentEnddate = sender.date.formattedISO8601
        default:
            break
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CreateAssignmentViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextfield = textField
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if updatedText.characters.count > 10 && textField == phoneNumberTextfield {
            return false
        }
        return true
        
    }
}
