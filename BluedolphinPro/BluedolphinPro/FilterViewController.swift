//
//  FilterViewController.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 18/01/17.
//  Copyright © 2017 raremediacompany. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    var tabView :ViewPagerControl!
    var activeTextfield = UITextField()
    
    @IBOutlet weak var startDateFrom: UITextField!
    
    @IBOutlet weak var startDateTo: UITextField!
    
    @IBOutlet weak var endDateFrom: UITextField!
    
    @IBOutlet weak var endDateTo: UITextField!
   
    @IBOutlet weak var selfButtton: SSRadioButton!
    
    
    @IBOutlet weak var startDateButton: UIButton!
    @IBOutlet weak var endDateButton: UIButton!
    @IBOutlet weak var assignedByButton: UIButton!
    @IBOutlet weak var managerButton: SSRadioButton!
     var radioButtonController: SSRadioButtonsController?
    override func viewDidLoad() {
        super.viewDidLoad()
        createTabbarView()
        setdelegate()
        self.navigationItem.title = "Filter by"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cancel"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(FilterViewController.cancelPressed(_:)))
            
        radioButtonController = SSRadioButtonsController(buttons: selfButtton, managerButton)
        radioButtonController!.delegate = self
        radioButtonController!.shouldLetDeSelect = true
        startDateButton.addTarget(self, action: #selector(startButtonPressed), for: UIControlEvents.touchUpInside)
        endDateButton.addTarget(self, action: #selector(endButtonPressed), for: UIControlEvents.touchUpInside)
        assignedByButton.addTarget(self, action: #selector(assignedByButtonPressed), for: UIControlEvents.touchUpInside)
        // Do any additional setup after loading the view.
    }
    func startButtonPressed(sender:UIButton){
        sender.isSelected = !sender.isSelected
        
    }
    func endButtonPressed(sender:UIButton){
        sender.isSelected = !sender.isSelected

    }
    func assignedByButtonPressed(sender:UIButton){
        sender.isSelected = !sender.isSelected

    }
    func setdelegate(){
        let datePicker = UIDatePicker()

        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChanged(sender:)), for: UIControlEvents.valueChanged)
        startDateFrom.inputView = datePicker
        startDateTo.inputView = datePicker
        endDateFrom.inputView = datePicker
        endDateTo.inputView = datePicker
        startDateFrom.delegate = self
        startDateTo.delegate = self
        endDateFrom.delegate = self
        endDateTo.delegate = self
    }
    
    func dateChanged(sender:UIDatePicker){
        activeTextfield.text = sender.date.formatted
//        switch activeTextfield {
//        case startDateTextfield:
//            assignmentStartdate = sender.date.formattedISO8601
//        case endDateTextfield:
//            assignmentEnddate = sender.date.formattedISO8601
//        default:
//            break
//        }
        
    }

    func createTabbarView(){
        let list = ["Clear All","Apply"]
        
        tabView = ViewPagerControl(items: list)
        //ViewPagerControl(items: data)
        tabView.type = .text
        tabView.frame = CGRect(x: 0, y: ScreenConstant.height - 40, width: ScreenConstant.width, height: 40)
        tabView.selectionIndicatorColor = UIColor.white
        //tabView.showSelectionIndication = false
        self.view.addSubview(tabView)
        
        tabView.indexChangedHandler = { index in
            
            self.tabChanger(segment: index)
            
        }
        
    }
    func cancelPressed(_:UIButton){
        self.dismiss(animated: true, completion: nil)
        
    }
    func tabChanger(segment:Int){
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
extension FilterViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextfield = textField
    }
}
extension FilterViewController:SSRadioButtonControllerDelegate{
    func didSelectButton(aButton: UIButton?) {
        
    }
}
