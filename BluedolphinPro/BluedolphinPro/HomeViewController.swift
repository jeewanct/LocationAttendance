//
//  HomeViewController.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 17/11/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import UIKit
import RealmSwift


class HomeViewController: UIViewController {
 
    var currentTextField = UITextField()
    @IBOutlet weak var signalView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var statusTextField: UITextField!
    
    @IBOutlet weak var organisationTextField: UITextField!
    
    @IBOutlet weak var mobileNumberTextfield: UITextField!
    
    @IBOutlet weak var totalHourTextfield: UITextField!
    @IBOutlet weak var fecodeTextField: UITextField!
    var statusOption = ["Online","Offline"]
    var organisationOption = ["New","BdLite","BdPro"]
    let pickerView = UIPickerView()
    var menuView: CustomNavigationDropdownMenu!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let deviceToken = UserDefaults.standard.value(forKey: UserDefaultsKeys.deviceToken.rawValue) as? String{
            print(deviceToken)
        }
            createNavView()
            createLayout()
        
      
        
//        let options = ViewPagerOptions(inView: self.view)
//        options.isEachTabEvenlyDistributed = true
//        options.isviewPagerHighlightAvailable = true
    
        
        //getUserData()
        //postCheckin()
        // Do any additional setup after loading the view.
        
        
        
    }
    
    func createLayout(){
        
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        //profileImageView.contentMode = .center
        profileImageView.clipsToBounds = true
        
        profileImageView.layer.borderColor = UIColor.gray.cgColor
        profileImageView.layer.borderWidth = 1.0
        signalView.layer.cornerRadius = signalView.frame.size.width/2
        signalView.clipsToBounds = true
        var dropdownImage = UIImage(named: "dropdown")
         dropdownImage =  dropdownImage?.imageWithInsets(insetDimen: 10)
        nameLabel.text = "Raghvendra"
        statusTextField.text = statusOption[0]
        statusTextField.inputView = pickerView
        statusTextField.delegate = self
        statusTextField.rightViewMode = .always;
        statusTextField.rightView = UIImageView(image: dropdownImage)
        
        organisationTextField.text = organisationOption[0]
        organisationTextField.inputView = pickerView
        organisationTextField.delegate = self
        organisationTextField.rightViewMode = .always;
        organisationTextField.rightView = UIImageView(image:dropdownImage )
        
        fecodeTextField.text = " FE Code: " + "Loream Ipsum"
        fecodeTextField.isUserInteractionEnabled = false
        fecodeTextField.leftViewMode = .always;
        fecodeTextField.leftView = UIImageView(image: UIImage(named: "code"))
        
        mobileNumberTextfield.text = " Mobile Number: " + "+919015620820"
        mobileNumberTextfield.isUserInteractionEnabled = false
        mobileNumberTextfield.leftViewMode = .always;
        mobileNumberTextfield.leftView = UIImageView(image: UIImage(named: "phone"))
        
        totalHourTextfield.text = " Total Hours: " + "10:20"
        totalHourTextfield.isUserInteractionEnabled = false
        totalHourTextfield.leftViewMode = .always;
        totalHourTextfield.leftView = UIImageView(image: UIImage(named: "clock"))
        
        let notificationButton = UIBarButtonItem(image: #imageLiteral(resourceName: "notifications"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(notificationAction(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0, green: 0.5694751143, blue: 1, alpha: 1)
        self.navigationItem.leftBarButtonItem = notificationButton
        
        
       
    }
    
    func notificationAction(_:Any){
        
    }
    
    
    func createNavView(){
        let items = ["My Dashboard", "Assignments", "Calendar", "Call History", "Profile"]
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        //UIColor(red: 0.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        
        menuView = CustomNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: "Profile", items: items as [AnyObject])
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        
        menuView.cellSelectionColor = UIColor.white
        //UIColor(red: 0.0/255.0, green:160.0/255.0, blue:195.0/255.0, alpha: 1.0)
        menuView.shouldKeepSelectedCellColor = true
        menuView.cellTextLabelColor = UIColor.black
        menuView.cellTextLabelFont = UIFont(name: "SourceSansPro-Regular", size: 17)
        menuView.cellTextLabelAlignment = .left // .Center // .Right // .Left
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.3
        menuView.maskBackgroundColor = UIColor.black
        menuView.maskBackgroundOpacity = 0.3
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
            
         self.menuChanger(segment: indexPath)
            
            
        }
        
        self.navigationItem.titleView = menuView
    }
    
    func menuChanger(segment:Int){
        switch segment {
        case 1:
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: LocalNotifcation.Assignment.rawValue) , object: nil)
            
        case 4:
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: LocalNotifcation.Profile.rawValue) , object: nil)
            
        default:
            break
        }
    }

    func postCheckin(){
        let checkin = CheckinHolder()
        checkin.accuracy = CurrentLocation.accuracy
        checkin.altitude = CurrentLocation.altitude
        checkin.latitude = String(CurrentLocation.coordinate.latitude)
        checkin.longitude = String(CurrentLocation.coordinate.longitude)
        checkin.checkinDetails = ["notes":"hello new note" as AnyObject]
        checkin.checkinCategory = CheckinCategory.Transient.rawValue
        checkin.checkinType = CheckinType.Location.rawValue
        checkin.organizationId = Singleton.sharedInstance.organizationId
        checkin.checkinId = UUID().uuidString
        checkin.time = Date().formattedISO8601
        let user = CheckinModel()
        user.createCheckin(checkinData: checkin)
        user.postCheckin()
        
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

extension HomeViewController:UIPickerViewDataSource, UIPickerViewDelegate{
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         if currentTextField == statusTextField {
          return statusOption.count
        }
        return organisationOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if currentTextField == statusTextField {
            return statusOption[row]
        }
        return organisationOption[row]
    }
  
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if currentTextField == statusTextField {
            updateStatus(data: statusOption[row])
  
        }
    updateOrganisation(data:  organisationOption[row])
    }
    
    func updateStatus(data:String){
        statusTextField.text = data
        switch data {
        case statusOption[0]:
            self.signalView.backgroundColor = UIColor.green
            
            case statusOption[1]:
            self.signalView.backgroundColor = UIColor.red
            
        default:
            break
        }
    }
    func updateOrganisation(data:String){
             organisationTextField.text  = data
    }
    
}
extension HomeViewController :UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
    }
}
    
    
