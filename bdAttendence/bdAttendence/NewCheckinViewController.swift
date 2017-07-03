//
//  NewCheckinViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 22/06/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit
import BluedolphinCloudSdk
import CoreLocation
import  RealmSwift

class NewCheckinViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(menuAction(sender:)))
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        updateTask()
       
        // Do any additional setup after loading the view.
    }

    func handleGesture(sender:UIGestureRecognizer){
        UserDefaults.standard.set("1", forKey: "AlreadyCheckin")
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "checkout") as? NewCheckoutViewController
        self.show(controller!, sender: nil)
    }
    
    func menuAction(sender:UIBarButtonItem){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowSideMenu"), object: nil)
    
    }
    
    func updateTask(){
        if isInternetAvailable() {
            self.showLoader()
            BlueDolphinManager.manager.updateToken()
            BlueDolphinManager.manager.getNearByBeacons()
        }
        
        //BlueDolphinManager.manager.startScanning()
        NotificationCenter.default.removeObserver(self)
        //NotificationCenter.default.addObserver(self, selector: #selector(locationCheckin), name: NSNotification.Name(rawValue: iBeaconNotifications.Location.rawValue), object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.updateLocation(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.LocationUpdate.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewCheckinViewController.checkPermissionStatus(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.Background.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewCheckinViewController.firstCheckin(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.FirstBeaconCheckin.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(bluetoothDisabled), name: NSNotification.Name(rawValue: iBeaconNotifications.iBeaconDisabled.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(bluetoothEnabled), name: NSNotification.Name(rawValue: iBeaconNotifications.iBeaconEnabled.rawValue), object: nil)
        
      
       
        
        
        
    }
    
    
    func firstCheckin(sender:NSNotification){
        let state = UIApplication.shared.applicationState
        if state == .background {
            let notification = UILocalNotification()
            notification.fireDate = NSDate(timeIntervalSinceNow: 10) as Date
            notification.alertBody = NotificationMessage.AttendanceMarked.rawValue
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.userInfo = ["notificationType": "FirstCheckin"]
            UIApplication.shared.scheduleLocalNotification(notification)
        }else if state == .active{
            delayWithSeconds(3, completion: {
                self.showAlert(NotificationMessage.AttendanceMarked.rawValue)
            })
            
        }
        
        
    }
    
    func bluetoothEnabled(){
        ProjectSingleton.sharedInstance.bluetoothAvaliable = true
    }
    func bluetoothDisabled(){
        ProjectSingleton.sharedInstance.bluetoothAvaliable = false
    }
    func checkPermissionStatus(sender:NSNotification){
        updateTask()
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                ProjectSingleton.sharedInstance.locationAvailable = false
            case .authorizedAlways, .authorizedWhenInUse:
                ProjectSingleton.sharedInstance.locationAvailable = true
            }
        } else {
            ProjectSingleton.sharedInstance.locationAvailable = false
        }
        
        print("Location enabled \(ProjectSingleton.sharedInstance.locationAvailable)")
        print("Bluetooth enabled \(ProjectSingleton.sharedInstance.bluetoothAvaliable)")
        if (ProjectSingleton.sharedInstance.locationAvailable && ProjectSingleton.sharedInstance.bluetoothAvaliable) == false{
//            let controller = self.storyboard?.instantiateViewController(withIdentifier: "permission") as! PermissionViewController
//            self.present(controller, animated: true, completion: nil)
        }
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
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    func timeText(_ s: Int) -> String {
        return s < 10 ? "0\(s)" : "\(s)"
    }
    func showLoader(text:String = "Updating your details" ){
        AlertView.sharedInstance.setLabelText(text)
        AlertView.sharedInstance.showActivityIndicator(self.view)
        let delay = 3.0 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            AlertView.sharedInstance.hideActivityIndicator(self.view)
            BlueDolphinManager.manager.startScanning()
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
