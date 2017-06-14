//
//  WelcomeViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 17/04/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit
import BluedolphinCloudSdk

class WelcomeViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBAction func checkinAction(_ sender: Any) {
  
        
           //BlueDolphinManager.manager.startScanning()
            sendCheckins()
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "successView") as? CheckinSuccessViewController
            self.show(controller!, sender: nil)

        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        if isInternetAvailable() {
             showLoader()
            BlueDolphinManager.manager.updateToken()
            BlueDolphinManager.manager.getNearByBeacons()
        }
            else{
           
        }
       
       
        nameLabel.text  =  "Hi \(SDKSingleton.sharedInstance.userName.capitalized.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)),"
        
        //NotificationCenter.default.addObserver(self, selector: #selector(locationCheckin), name: NSNotification.Name(rawValue: iBeaconNotifications.Location.rawValue), object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(bluetoothDisabled), name: NSNotification.Name(rawValue: iBeaconNotifications.iBeaconDisabled.rawValue), object: nil)
        
        // Do any additional setup after loading the view.
    }
    func bluetoothDisabled(sender:NSNotification){
        let checkin = CheckinHolder()
        
        checkin.checkinDetails = [AssignmentWork.AppVersion.rawValue:APPVERSION as AnyObject,AssignmentWork.UserAgent.rawValue:"ios" as AnyObject,"deviceStatus":"Bluetooth is off" as AnyObject]
        checkin.checkinCategory = CheckinCategory.Transient.rawValue
        checkin.checkinType = CheckinType.Location.rawValue
        //
   
        CheckinModel.createCheckin(checkinData: checkin)
        if isInternetAvailable(){
            CheckinModel.postCheckin()
        }
        self.showAlert("Please enable bluetooth for indoor location monitoring")
        
    }
//    func locationCheckin(sender:NSNotification){
//        let checkin = CheckinHolder()
//        
//        checkin.checkinDetails = [AssignmentWork.AppVersion.rawValue:APPVERSION as AnyObject,AssignmentWork.UserAgent.rawValue:"ios" as AnyObject]
//        checkin.checkinCategory = CheckinCategory.Transient.rawValue
//        checkin.checkinType = CheckinType.Location.rawValue
//        //
//        let checkinModelObject = CheckinModel()
//        checkinModelObject.createCheckin(checkinData: checkin)
//        if isInternetAvailable(){
//            checkinModelObject.postCheckin()
//        }
//        
//    }
    
    func sendCheckins(){
        let checkin = CheckinHolder()
        
        checkin.checkinDetails = [AssignmentWork.AppVersion.rawValue:APPVERSION as AnyObject,AssignmentWork.UserAgent.rawValue:"ios" as AnyObject, "status": "Checked-In" as AnyObject]
        checkin.checkinCategory = CheckinCategory.Data.rawValue
        checkin.checkinType = CheckinType.Data.rawValue
                     //
        CheckinModel.createCheckin(checkinData: checkin)
        if isInternetAvailable(){
            CheckinModel.postCheckin()
        }
    }
    
    func showLoader(text:String = "Updating User data" ){
        AlertView.sharedInstance.setLabelText(text)
        AlertView.sharedInstance.showActivityIndicator(self.view)
        let delay = 3.0 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            AlertView.sharedInstance.hideActivityIndicator(self.view)
            BlueDolphinManager.manager.startScanning()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showAlert(_ message : String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (action) in
            return        }
        alertController.addAction(OkAction)
        self.present(alertController, animated: true) {
        }
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
