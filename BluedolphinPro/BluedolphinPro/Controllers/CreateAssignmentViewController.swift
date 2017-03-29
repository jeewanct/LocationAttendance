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
    fileprivate var uuidString = String()
   fileprivate var activeTextfield = UITextField()
    fileprivate var alertTextfield = UITextField()
    var changeSegment : SegmentChanger?
    fileprivate var assignmentStartdate = String()
    fileprivate var assignmentEnddate = String()
    fileprivate let datePicker = UIDatePicker()
   fileprivate var selectedLocation = CLLocation()
   fileprivate var assignmentAddress = String()
   fileprivate var tabView:ViewPagerControl!
    var draftObject :DraftAssignmentObject?
    var draftFlag = false
   

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Create Assignments"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(CreateAssignmentViewController.cancelPressed(_:)))
        //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(CreateAssignmentViewController.savePressed(_:)))
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
        datePicker.minimumDate = getCurrentDate()
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
        createTabbarView()
        setDraftForm()
        
        
        
    }
    
    func setDraftForm(){
        if draftFlag {
            if let data = draftObject?.assignmentAddress {
                assignmentAddress = data
                addressButton.setTitle(assignmentAddress, for: UIControlState.normal)
                
            }
            if let data = draftObject?.email {
                emailTextfield.text = data
                
            }
            if let data = draftObject?.assignmentId {
                uuidString = data
                
            }
            if let data = draftObject?.mobile {
                phoneNumberTextfield.text = data
                
            }
            if let data = draftObject?.contactPerson {
                contactPersonTextfield.text = data
                
            }
            if let data = draftObject?.assignmentStartTime {
                assignmentStartdate = data
                startDateTextfield.text = data.asDate.formatted
                
            }
            if let data = draftObject?.assignmentDeadline {
                assignmentEnddate = data
                endDateTextfield.text = data.asDate.formatted
                
            }
            
        }
    }
    func createTabbarView(){
        
       let data = ["Save as Draft","Save"]
        tabView = ViewPagerControl(items: data)
        tabView.type = .text
        tabView.frame = CGRect(x: 0, y: ScreenConstant.height - 50, width: ScreenConstant.width, height: 50)
        
        
        tabView.selectionIndicatorColor = UIColor.white
        //tabView.showSelectionIndication = false
        self.view.addSubview(tabView)
        
        tabView.indexChangedHandler = { index in
            
            self.tabChanger(segment: index)
            
        }
        
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        switch sender.tag{
        case 1001:
            break
            
        case 1002:
            savePressed()
        default:break
            
        }
        
    }
    
    func tabChanger(segment:Int){
        switch segment {
        case 0:
            if assignmentEnddate.isBlank && assignmentStartdate.isBlank && assignmentAddress.isBlank && contactPersonTextfield.text!.isBlank && phoneNumberTextfield.text!.isBlank && emailTextfield.text!.isBlank {
                self.showAlert("Please fill fields to save as draft")
            }else {
                showTextfieldAlert()
            }
            
        case 1:
           savePressed()
            
            
        default:
            break
        }
    }
    func cancelPressed(_:UIButton){
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func savePressed(){
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
    
    
    func createDraft(description:String){
        let draft = DraftAssignmentObject()
        if !assignmentAddress.isBlank{
        draft.assignmentAddress = assignmentAddress
            draft.accuracy = String(selectedLocation.horizontalAccuracy)
            draft.altitude = String(selectedLocation.altitude)
            draft.longitude = String(selectedLocation.coordinate.longitude)
            draft.latitude = String(selectedLocation.coordinate.latitude)
        }
        if !emailTextfield.text!.isBlank{
            draft.email = emailTextfield.text
        }
        if !contactPersonTextfield.text!.isBlank{
            draft.contactPerson = contactPersonTextfield.text
        }
        if !phoneNumberTextfield.text!.isBlank{
            draft.mobile = phoneNumberTextfield.text
        }
        if !contactPersonTextfield.text!.isBlank{
            draft.contactPerson = contactPersonTextfield.text
        }
        if !assignmentEnddate.isBlank{
            draft.assignmentDeadline = assignmentEnddate
        }
        if !assignmentStartdate.isBlank{
            draft.assignmentStartTime = assignmentStartdate
        }
        if uuidString.isBlank{
           uuidString = getUUIDString()
        }
        
        draft.assignmentId = uuidString
        draft.jobNumber = getJobNumber()
        draft.draftDescription = description
        let realm = try! Realm()
        try! realm.write {
            realm.add(draft,update:true)
        }
        
        self.dismiss(animated: true, completion: nil)
        
    
    }

    func createAssignment(){
        if uuidString.isBlank{
            uuidString = getUUIDString()
        }
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
        assignmentObject.time = getCurrentDate().formattedISO8601
        assignmentObject.status = CheckinType.Assigned.rawValue
        
        assignmentObject.assignmentDetails = [
            "mobile":phoneNumberTextfield.text!,
            "contactPerson":contactPersonTextfield.text!,
            "instructions":" ",
            "email":emailTextfield.text!,
            "jobNumber":getJobNumber()
            
        ]

        deleteDraft()
        
        
        let assignmentModel = AssignmentModel()
        assignmentModel.createAssignment(assignmentData: assignmentObject)
        assignmentModel.postdbAssignments()
        
        if let delegate = self.changeSegment {
            delegate.moveToSegment(CheckinType.Downloaded.rawValue)
        }
        self.dismiss(animated: true, completion: nil)
    }


    
    func deleteDraft(){
        if let draft = draftObject{
            let realm = try! Realm()
            try! realm.write {
                realm.delete(draft)
            }
        }
        
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
    
    
    //Textfield Alert
    func configurationTextField(_ textField: UITextField!)
    {
        print("configurat hire the TextField")
        
        if let tField = textField {
            
            self.alertTextfield = tField        //Save reference to the UITextField
            self.alertTextfield.placeholder = "Enter description"
        }
    }
    
    
    func handleCancel(_ alertView: UIAlertAction!)
    {
        print("User click Cancel button")
        print(self.alertTextfield.text!)
    }
    
    func showTextfieldAlert(){
        let alert = UIAlertController(title: "Enter Description", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField(configurationHandler: configurationTextField)
        
        alert.addAction(UIAlertAction(title: "Discard", style: UIAlertActionStyle.cancel, handler:handleCancel))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
            print("User click Ok button")
            print(self.alertTextfield.text!)
            if self.alertTextfield.text!.isBlank {
                
                
            }else {
                self.createDraft(description: self.alertTextfield.text!)
            }
            
        }))
        self.present(alert, animated: true, completion: {
            
            print("completion block")
        })
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
