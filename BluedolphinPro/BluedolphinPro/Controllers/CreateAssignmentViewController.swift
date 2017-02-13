//
//  CreateAssignmentViewController.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 22/12/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation

class CreateAssignmentViewController: UIViewController {
    @IBOutlet weak var nameTextfield: UITextField!

    @IBOutlet weak var endDateTextfield: UITextField!
    @IBOutlet weak var startDateTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var phoneNumberTextfield: UITextField!
    @IBOutlet weak var contactPersonTextfield: UITextField!
   
    @IBOutlet weak var addressButton: UIButton!
    var uuidString = String()
    var activeTextfield = UITextField()
     var changeSegment : SegmentChanger?
    var assignmentStartdate = String()
    var assignmentEnddate = String()
    let datePicker = UIDatePicker()
    var selectedLocation = CLLocation()
    var assignmentAddress = String()
   

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
        
        contactPersonTextfield.delegate = self
        phoneNumberTextfield.delegate = self
        emailTextfield.delegate = self
        startDateTextfield.delegate = self
        endDateTextfield.delegate = self
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChanged(sender:)), for: UIControlEvents.valueChanged)
        startDateTextfield.inputView = datePicker
        endDateTextfield.inputView = datePicker

      
        
        nameTextfield.isUserInteractionEnabled = false
        nameTextfield.text = SDKSingleton.sharedInstance.userName.capitalized
        
        self.addressButton.layer.borderWidth = 1.0
        self.addressButton.layer.borderColor =
            UIColor.lightGray.withAlphaComponent(0.4).cgColor
        self.addressButton.clipsToBounds = true
        self.addressButton.layer.cornerRadius = 5
        self.addressButton.titleLabel?.numberOfLines = 2
        addressButton.addTarget(self, action: #selector(addressButtonAction), for: UIControlEvents.touchUpInside)
        
        
    }
    func cancelPressed(_:UIButton){
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func savePressed(_:UIButton){
        //        if placeNameTextfield.text!.isBlank{
        //            self.showAlert(SelfAssignmentError.placeNameError.rawValue)
        //        }else
        
        if assignmentAddress.isBlank{
            self.showAlert(SelfAssignmentError.addressError.rawValue)
        }else if contactPersonTextfield.text!.isBlank{
            self.showAlert(SelfAssignmentError.contactPersonError.rawValue)
        }else if phoneNumberTextfield.text!.isBlank{
            self.showAlert(SelfAssignmentError.contactNumberError.rawValue)
        }else if !phoneNumberTextfield.text!.isMobile{
            self.showAlert(SelfAssignmentError.mobileInvalid.rawValue)
        }else if !emailTextfield.text!.isBlank && !emailTextfield.text!.isEmail{
            self.showAlert(SelfAssignmentError.emailError.rawValue)
        }else if startDateTextfield.text!.isBlank{
            self.showAlert(SelfAssignmentError.startdateError.rawValue)
        }else if NSDate().compare(startDateTextfield.text!.asDateFormat()) == ComparisonResult.orderedDescending {
            
            self.showAlert(SelfAssignmentError.starttimeError.rawValue)
            
            
        }
        else if endDateTextfield.text!.isBlank{
            self.showAlert(SelfAssignmentError.enddateError.rawValue)
        }else if NSDate().compare(endDateTextfield.text!.asDateFormat()) == ComparisonResult.orderedDescending {
            
            self.showAlert(SelfAssignmentError.endtimeError.rawValue)
            
            
        }
        else{
            createAssignment()
        }
        
        
        
    }
    func getJobNumber()->String{
        let realm = try! Realm()
        let tokenObject = realm.objects(AccessTokenObject.self).filter("organizationId=%@",SDKSingleton.sharedInstance.organizationId).first
        let organisationName  = tokenObject?.organizationName
        
        let jobNumber = organisationName![0..<4].uppercased() + "-" + uuidString[0..<4]
        return jobNumber
        
    }
    func addressButtonAction(){
        let navController = self.storyboard?.instantiateViewController(withIdentifier: "SearchScreen") as! UINavigationController
        let controller = navController.topViewController as! AddressSearchViewController
        controller.changeAddress = self
        self.present(navController, animated: true, completion: nil)
        
    }
    
    func createAssignment(){
        uuidString = getUUIDString()
        let assignmentObject = AssignmentHolder()
        assignmentObject.accuracy = String(selectedLocation.horizontalAccuracy)
        assignmentObject.altitude = String(selectedLocation.altitude)
        assignmentObject.longitude = String(selectedLocation.coordinate.longitude)
        assignmentObject.latitude = String(selectedLocation.coordinate.latitude)
        assignmentObject.assignmentId = uuidString
        assignmentObject.assigneeIds  = [SDKSingleton.sharedInstance.userId]
        assignmentObject.assignmentAddress = assignmentAddress
        assignmentObject.assignmentDeadline = assignmentEnddate
        assignmentObject.assignmentStartTime = assignmentStartdate
        assignmentObject.organizationId = SDKSingleton.sharedInstance.organizationId
        assignmentObject.time = Date().formattedISO8601
        assignmentObject.status = CheckinType.Assigned.rawValue
        
        assignmentObject.assignmentDetails = [
            "mobile":phoneNumberTextfield.text!,
            "contactPerson":contactPersonTextfield.text!,
            "instructions":" ",
            "email":emailTextfield.text!,
            "jobNumber":getJobNumber()
            
        ]
        let assignmentModel = AssignmentModel()
       assignmentModel.createAssignment(assignmentData: assignmentObject)
        assignmentModel.postdbAssignments()
        
        if let delegate = self.changeSegment {
            delegate.moveToSegment(CheckinType.Downloaded.rawValue)
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
    
    func showAlert(_ message : String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (action) in
            return        }
        alertController.addAction(OkAction)
        self.present(alertController, animated: true) {
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
        switch  textField {
        case startDateTextfield:
            datePicker.minimumDate = Date()
            endDateTextfield.text = ""
        case endDateTextfield:
            if startDateTextfield.text!.isBlank{
                showAlert("Please select Assignment start date ")
            }else{
                datePicker.minimumDate = startDateTextfield.text?.asDateFormat()
                
            }
        
            
            
        default:
            break
        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if updatedText.characters.count > 10 && textField == phoneNumberTextfield {
            return false
        }
        return true
        
    }
}





extension CreateAssignmentViewController :SelectedAddress{
    func showSelectedAddress(_ address:String,location:CLLocation){
        
        assignmentAddress = address
        addressButton.setTitle(" " + assignmentAddress, for: UIControlState.normal)
        selectedLocation  = location
        
    }
    
}
