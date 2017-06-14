//
//  CheckOutViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 18/04/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit
import BluedolphinCloudSdk

class CheckOutViewController: UIViewController {

    @IBOutlet weak var lastCheckinLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressBar: UICircularProgressRingView!
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationController?.isNavigationBarHidden = true
        updateTask()
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(CheckOutViewController.updateDate(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.Background.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(locationCheckin), name: NSNotification.Name(rawValue: iBeaconNotifications.Location.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(bluetoothDisabled), name: NSNotification.Name(rawValue: iBeaconNotifications.iBeaconDisabled.rawValue), object: nil)
        
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
    func locationCheckin(sender:NSNotification){
        if let lastLocationCheckin = UserDefaults.standard.value(forKeyPath: "lastLocationCheckin") as? Date {
            print( "Difference last \(lastLocationCheckin.minuteFrom(Date()))")
            if Date().minuteFrom(lastLocationCheckin) > 2{
                let checkin = CheckinHolder()
                
                checkin.checkinDetails = [AssignmentWork.AppVersion.rawValue:APPVERSION as AnyObject,AssignmentWork.UserAgent.rawValue:"ios" as AnyObject]
                checkin.checkinCategory = CheckinCategory.Transient.rawValue
                checkin.checkinType = CheckinType.Location.rawValue
                //
                CheckinModel.createCheckin(checkinData: checkin)
                UserDefaults.standard.set(Date(), forKey: "lastLocationCheckin")
                if isInternetAvailable(){
                    CheckinModel.postCheckin()
                }
            }
        } else{
            UserDefaults.standard.set(Date(), forKey: "lastLocationCheckin")
        }
        
        
        
    }
    func updateTask(){
        if isInternetAvailable() {
            BlueDolphinManager.manager.updateToken()
            BlueDolphinManager.manager.getNearByBeacons()
        }
        
        BlueDolphinManager.manager.startScanning()
        
        self.lastCheckinLabel.text = "Your last check in \(currentTime())"
        self.welcomeLabel.text = "Hi \(SDKSingleton.sharedInstance.userName.capitalized.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)), How's it going"
        progressBar.maxValue = 540
        let value = 220
        progressBar.setProgress(value: CGFloat(value), animationDuration: 5.0) {
            self.progressLabel.text = "\(value/60) hours"
        }
    }
    func updateDate(sender:Notification){
        self.lastCheckinLabel.text = "Your last check in \(currentTime())"
    }
    @IBAction func checkoutAction(_ sender: Any) {
        //if BlueDolphinManager.manager.seanbeacons.count != 0{
            //BlueDolphinManager.manager.stopScanning()
            moveToWelcome()
            BlueDolphinManager.manager.sendCheckins()
            UserDefaults.standard.set("false", forKey: "AlreadyCheckin")
//        }else{
//            self.showAlert("Please make sure you are in office premises")
//        }
        
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
    
    func sendCheckins(){
        let checkin = CheckinHolder()
        
        checkin.checkinDetails = [AssignmentWork.AppVersion.rawValue:APPVERSION as AnyObject,AssignmentWork.UserAgent.rawValue:"ios" as AnyObject, "status": "Checked-Out" as AnyObject]
        checkin.checkinCategory = CheckinCategory.Data.rawValue
        checkin.checkinType = CheckinType.Data.rawValue
        //

        CheckinModel.createCheckin(checkinData: checkin)
        if isInternetAvailable(){
            CheckinModel.postCheckin()
        }
    }

    func currentTime() -> String {
        var date = Date()
        if let value = UserDefaults.standard.value(forKey: "LastCheckinTime") as? Date {
            date = value
        }
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        return "\(hour):\(minutes)"
    }

    func moveToWelcome(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = storyboard.instantiateViewController(withIdentifier: "Main") as! UINavigationController
        if UIApplication.shared.keyWindow != nil {
           UIApplication.shared.keyWindow?.rootViewController = destVC
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
