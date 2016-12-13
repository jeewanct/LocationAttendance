//
//  SelfAssignmentViewController.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 12/12/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import UIKit
import XLForm

class SelfAssignmentViewController:XLFormViewController  {

    fileprivate struct Tags {
        static let StartDate = "startDate"
        static let EndDate = "endDate"
        static let StartTime = "startTime"
        static let EndTime = "endTime"
        static let Name = "name"
        static let Email = "email"
        static let Twitter = "twitter"
        static let Number = "number"
        static let Integer = "integer"
        static let Decimal = "decimal"
        static let Password = "password"
        static let Phone = "phone"
        static let Url = "url"
        static let ZipCode = "zipCode"
        static let TextView = "textView"
        static let Notes = "notes"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Create Assignments"
         navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(SelfAssignmentViewController.cancelPressed(_:)))
         navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(SelfAssignmentViewController.savePressed(_:)))

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
        
    }
    func initializeForm() {
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        form = XLFormDescriptor()
        form.assignFirstResponderOnShow = true
        section = XLFormSectionDescriptor()
        
      
        
        row = XLFormRowDescriptor(tag: Tags.Name, rowType: XLFormRowDescriptorTypeText, title: "Name")
        row.isRequired = true
        section.addFormRow(row)
        row = XLFormRowDescriptor(tag: Tags.Email, rowType: XLFormRowDescriptorTypeSelectorPush, title: "Address")
        row.value = "New delhi CP"
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.Name, rowType: XLFormRowDescriptorTypeText, title: "Contact Person")
        row.isRequired = true
        section.addFormRow(row)
        row = XLFormRowDescriptor(tag: Tags.Name, rowType: XLFormRowDescriptorTypePhone, title: "Phone Number")
        row.isRequired = true
        section.addFormRow(row)
        row = XLFormRowDescriptor(tag: Tags.Email, rowType: XLFormRowDescriptorTypeEmail, title: "Email")
        // validate the email
        //row.addValidator(XLFormValidator.email())
        section.addFormRow(row)
        // Date
        row = XLFormRowDescriptor(tag: Tags.StartDate, rowType: XLFormRowDescriptorTypeDate, title:"Start Date")
        row.value = Date()
        section.addFormRow(row)
        row = XLFormRowDescriptor(tag: Tags.EndDate, rowType: XLFormRowDescriptorTypeDate, title:"End Date")
        row.value = Date()
        section.addFormRow(row)
        
        // Time
        row = XLFormRowDescriptor(tag: Tags.StartTime, rowType: XLFormRowDescriptorTypeTime, title: "From")
        row.value = Date()

        section.addFormRow(row)
        row = XLFormRowDescriptor(tag: Tags.EndTime, rowType: XLFormRowDescriptorTypeTime, title: "To")
        row.value = Date()
        section.addFormRow(row)
        
        
        form.addFormSection(section)
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
        return 70.0
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
