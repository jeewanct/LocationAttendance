//
//  SuperViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 22/06/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit
import BluedolphinCloudSdk
import CoreLocation


class SuperViewController: UIViewController {
    var window: UIWindow?
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var sideMenuContainer: UIView!
    
    @IBOutlet weak var menuLeadingSpace: NSLayoutConstraint!
    
    @IBOutlet weak var mainContainer: UIView!
    
    
    var visualEffectView = UIVisualEffectView()
    var bool = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blurView.alpha = 0
        //println(self.childViewControllers)
        menuLeadingSpace.constant = -sideMenuContainer.bounds.size.width
        
        self.navigationController?.isNavigationBarHidden = true
        UIApplication.shared.isStatusBarHidden = true
        
        let leftSwipeOnTransparentView =  UISwipeGestureRecognizer(target: self, action: #selector(SuperViewController.handleSwipes(sender:)))
        let leftSwipeOnContainerView = UISwipeGestureRecognizer(target: self, action: #selector(SuperViewController.handleSwipes(sender:)))
        leftSwipeOnTransparentView.direction = .left
        leftSwipeOnContainerView.direction = .left
        
        sideMenuContainer.addGestureRecognizer(leftSwipeOnContainerView)
        blurView.addGestureRecognizer(leftSwipeOnTransparentView)
        //blurView.applyGradient(isTopBottom: true, colorArray: [APPColor.BlueGradient,APPColor.GreenGradient])
        
        if self.window != nil {
            self.window!.rootViewController = self
        }
        
         checkDeviceStatus()
         checkShiftStatus()
    
    
    }
    func handleLeftGesture() {
      
        self.showMenuView()
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
        setObservers()
       
        BlueDolphinManager.manager.getNearByBeacons(completion: { (value) in
            if let screenFlag = UserDefaults.standard.value(forKeyPath: "AlreadyCheckin") as? String{
                if screenFlag == "1"{
                    BlueDolphinManager.manager.stopScanning()
                    BlueDolphinManager.manager.startScanning()
                }
                
            }
        })
        checkBlockerScreen()
        updateTask()
    }
    
    func setObservers(){
         NotificationCenter.default.removeObserver(self)
         NotificationCenter.default.addObserver(self, selector: #selector(SuperViewController.ShowSideMenu(sender:)), name: NSNotification.Name(rawValue: "ShowSideMenu"), object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(SuperViewController.ShowSideMenu(sender:)), name: NSNotification.Name(rawValue: "HideSideMen"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SuperViewController.ShowController(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.Dashboard.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SuperViewController.ShowController(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.SystemDetail.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SuperViewController.ShowController(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.VirtualBeacon.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SuperViewController.ShowController(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.ThisWeek.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SuperViewController.ShowController(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.ContactUs.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SuperViewController.ShowController(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.Profile.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SuperViewController.pushNotificationReceived(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.Pushreceived.rawValue), object: nil)
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(SuperViewController.checkPermissionStatus(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.Background.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SuperViewController.firstCheckin(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.FirstBeaconCheckin.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(bluetoothDisabled), name: NSNotification.Name(rawValue: iBeaconNotifications.iBeaconDisabled.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(bluetoothEnabled), name: NSNotification.Name(rawValue: iBeaconNotifications.iBeaconEnabled.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(shiftHandling), name: NSNotification.Name(rawValue: LocalNotifcation.ShiftEnded.rawValue), object: nil)
        
        
    }
    
    func shiftHandling(){
        UserDefaults.standard.set("2", forKey: "AlreadyCheckin")
        UserDefaults.standard.synchronize()
        BlueDolphinManager.manager.stopScanning()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.CheckinScreen.rawValue), object: self, userInfo: nil)
        
        
    }
    
    @IBAction func invisibleButtonAction(_ sender: Any) {
        self.slideMenuViewToLeft()
    }
 
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        
        if (sender.direction == .left) {
            //////////println("Swipe Left")
            self.slideMenuViewToLeft()
        }
        if (sender.direction == .right) {
            //////////println("Swipe Right")
        }
    }
    
    func slideMenuViewToLeft() {
        
        self.menuLeadingSpace.constant = -sideMenuContainer.bounds.size.width
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.blurView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { (Bool) -> Void in
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showMenuView () {
        
        menuLeadingSpace.constant = 0
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            
            self.view.layoutIfNeeded()
            self.blurView.alpha = 0.9
        }, completion: { (Bool) -> Void in
            
        })
    }
    func ShowSideMenu(sender : NSNotification) {
       
        self.showMenuView()
        
    }
    
    
    
    
}

extension SuperViewController{
    
    func pushNotificationReceived(sender:NSNotification){
        let result: NSDictionary = sender.userInfo! as NSDictionary
        let type =  result ["notificationType"] as! String
        switch type {
        case NotificationType.Welcome.rawValue:
            break
        case NotificationType.NewAssignment.rawValue , NotificationType.FirstCheckin.rawValue:
            //self.showLocalNotification(userInfo)
            break
        case NotificationType.UpdatedAssignment.rawValue,NotificationType.NoCheckin.rawValue,NotificationType.testNotification.rawValue:
            
            break;
        case NotificationType.AttendanceMarked.rawValue:
           break
        case NotificationType.MultipleLogout.rawValue:
            deleteAllData()
            moveToFirstScreen()
            BlueDolphinManager.manager.stopScanning()
            
            
        default:
            break
            
            
            
        }
        
    }
    func updateTask(){
        if isInternetAvailable() {
           //self.showLoader()
            BlueDolphinManager.manager.updateToken()
        }
        if let screenFlag = UserDefaults.standard.value(forKeyPath: "AlreadyCheckin") as? String{
            if screenFlag == "1"{
                BlueDolphinManager.manager.stopScanning()
                BlueDolphinManager.manager.startScanning()
            }
            
        }
        
    }
    
    
    func firstCheckin(sender:NSNotification){
        let state = UIApplication.shared.applicationState
        if state == .background {
            let notification = UILocalNotification()
            notification.fireDate = NSDate(timeIntervalSinceNow: 10) as Date
            notification.alertBody = NotificationMessage.AttendanceMarked.rawValue + "\(Date().formatted)"
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.userInfo = ["notificationType": "FirstCheckin"]
            UIApplication.shared.scheduleLocalNotification(notification)
        }else if state == .active{
//            let notification = UILocalNotification()
//            notification.fireDate = NSDate(timeIntervalSinceNow: 30) as Date
//            notification.alertBody = NotificationMessage.AttendanceMarked.rawValue + "\(Date().formatted)"
//            notification.soundName = UILocalNotificationDefaultSoundName
//            notification.userInfo = ["notificationType": "FirstCheckin"]
//            UIApplication.shared.scheduleLocalNotification(notification)
            let message = NotificationMessage.AttendanceMarked.rawValue + "\(Date().formatted)"
            self.showAlert(message )
//            
        }
        
        
    }
    
    func bluetoothEnabled(){
        ProjectSingleton.sharedInstance.bluetoothAvaliable = true
        postBluetoothStateDataCheckin()
        
    }
    func bluetoothDisabled(){
        ProjectSingleton.sharedInstance.bluetoothAvaliable = false
        postBluetoothStateDataCheckin()
    }
    
    func postBluetoothStateDataCheckin(){
        let checkin = CheckinHolder()
        
        checkin.checkinDetails = [AssignmentWork.AppVersion.rawValue:APPVERSION as AnyObject,AssignmentWork.UserAgent.rawValue:"ios" as AnyObject,CheckinDetailKeys.bluetoothStatus.rawValue:ProjectSingleton.sharedInstance.bluetoothAvaliable as AnyObject]
        checkin.checkinCategory = CheckinCategory.Data.rawValue
        checkin.checkinType = CheckinType.Data.rawValue
        //
        
        CheckinModel.createCheckin(checkinData: checkin)
        
        if isInternetAvailable(){
            CheckinModel.postCheckin()
        }
    }
    
    func postGpsStateDataCheckin(){
        let checkin = CheckinHolder()
        
        checkin.checkinDetails = [AssignmentWork.AppVersion.rawValue:APPVERSION as AnyObject,AssignmentWork.UserAgent.rawValue:"ios" as AnyObject,CheckinDetailKeys.gpsStatus.rawValue:ProjectSingleton.sharedInstance.locationAvailable as AnyObject]
        checkin.checkinCategory = CheckinCategory.Data.rawValue
        checkin.checkinType = CheckinType.Data.rawValue
        //
        
        CheckinModel.createCheckin(checkinData: checkin)
        
        if isInternetAvailable(){
            CheckinModel.postCheckin()
        }
    }
    
    func checkPermissionStatus(sender:NSNotification){
        updateTask()
        checkBlockerScreen()
        
    }
    
    func checkBlockerScreen(){
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                ProjectSingleton.sharedInstance.locationAvailable = false
                
            case .authorizedAlways, .authorizedWhenInUse:
                ProjectSingleton.sharedInstance.locationAvailable = true
            }
            postGpsStateDataCheckin()
        } else {
            ProjectSingleton.sharedInstance.locationAvailable = false
            postGpsStateDataCheckin()
        }
        
        print("Location enabled \(ProjectSingleton.sharedInstance.locationAvailable)")
        print("Bluetooth enabled \(ProjectSingleton.sharedInstance.bluetoothAvaliable)")
        if (ProjectSingleton.sharedInstance.locationAvailable && ProjectSingleton.sharedInstance.bluetoothAvaliable) == false{
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "permission") as! NewPermissionViewController
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    
    
    
    func locationCheckin(sender:NSNotification){
        if let screenFlag = UserDefaults.standard.value(forKeyPath: "AlreadyCheckin") as? String{
            if screenFlag == "1"{
                if SDKSingleton.sharedInstance.locationTracking {
                    if let lastLocationCheckin = UserDefaults.standard.value(forKeyPath: "lastLocationCheckin") as? Date {
                        print( "Difference last \(lastLocationCheckin.minuteFrom(Date()))")
                        if Date().secondsFrom(lastLocationCheckin) > 300{
                            let checkin = CheckinHolder()
                            
                            checkin.checkinDetails = [AssignmentWork.AppVersion.rawValue:APPVERSION as AnyObject,AssignmentWork.UserAgent.rawValue:"ios" as AnyObject]
                            checkin.checkinCategory = CheckinCategory.Transient.rawValue
                            checkin.checkinType = CheckinType.Location.rawValue
                            //
                            
                            CheckinModel.createCheckin(checkinData: checkin)
                            UserDefaults.standard.set(Date(), forKey: "lastLocationCheckin")
                            UserDefaults.standard.synchronize()
                            if isInternetAvailable(){
                                CheckinModel.postCheckin()
                            }
                        }
                    } else{
                        UserDefaults.standard.set(Date(), forKey: "lastLocationCheckin")
                        UserDefaults.standard.synchronize()
                    }
                }
            }
        }
        
        
        
        
    }
    
    func checkDeviceStatus(){
        UserDeviceModel.getDeviceStatus { (status, id) in
            switch (status){
            case APIResult.Success.rawValue:
                print(SDKSingleton.sharedInstance.DeviceUDID)
                print(id)
                if id != SDKSingleton.sharedInstance.DeviceUDID{
                    deleteAllData()
                    moveToFirstScreen()
                    BlueDolphinManager.manager.stopScanning()
                }
            case APIResult.InvalidCredentials.rawValue:
                break
                //self.showAlert(ErrorMessage.UserNotFound.rawValue)
                
            case APIResult.InternalServer.rawValue:
                break
                //self.showAlert(ErrorMessage.InternalServer.rawValue)
                
                
            case APIResult.InvalidData.rawValue:
                break
                //self.showAlert(ErrorMessage.NotValidData.rawValue)
            default:
                break
                
            }
        }
    }
    func checkShiftStatus(){
      
            UserDeviceModel.getDObjectsShift { (status) in
                switch (status){
                case APIResult.Success.rawValue:
                    let shiftDetails = ShiftHandling.getShiftDetail()
                    officeEndHour = shiftDetails.2
                    officeStartHour = shiftDetails.0
                    officeStartMin = shiftDetails.1
                    officeEndMin = shiftDetails.3
                    
                    if let value = UserDefaults.standard.value(forKey: UserDefaultsKeys.BDShiftId.rawValue) as? String{
                        SDKSingleton.sharedInstance.shiftId = value
                    }
                    break
                   
                case APIResult.InvalidCredentials.rawValue:
                    break
                    //self.showAlert(ErrorMessage.UserNotFound.rawValue)
                    
                case APIResult.InternalServer.rawValue:
                    break
                    //self.showAlert(ErrorMessage.InternalServer.rawValue)
                    
                    
                case APIResult.InvalidData.rawValue:
                    break
                //self.showAlert(ErrorMessage.NotValidData.rawValue)
                default:
                    break
                    
                }
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
}




extension SuperViewController {
    func ShowController (sender : NSNotification) {
        self.slideMenuViewToLeft()
        switch (sender.name.rawValue) {
            
        case LocalNotifcation.Dashboard.rawValue:
            changeChildController(identifier: .dashboard)
        case LocalNotifcation.SystemDetail.rawValue:
            changeChildController(identifier: .systemDetail)
        case LocalNotifcation.VirtualBeacon.rawValue:
          changeChildController(identifier: .VirtualBeacon)
        case LocalNotifcation.ThisWeek.rawValue:
            changeChildController(identifier: .history)
        case LocalNotifcation.ContactUs.rawValue:
            changeChildController(identifier: .contactUs)
        case LocalNotifcation.Profile.rawValue:
            changeChildController(identifier: .myprofile)
    
        default:
            print("")
        }
    }
    
    func changeChildController(identifier:StoryboardIdentifier){
        var lastController: AnyObject?
        
        if let controller =  self.childViewControllers.first as? UINavigationController {
            lastController = controller
        } else {
            lastController = self.childViewControllers.last as! UINavigationController
        }
        for views in self.mainContainer.subviews {
            views.removeFromSuperview()
        }
        lastController?.willMove(toParentViewController: nil)
        
        lastController?.removeFromParentViewController()
        let destVc = self.storyboard?.instantiateViewController(withIdentifier: identifier.rawValue) as! UINavigationController
        
        
        self.addChildViewController(destVc)
        destVc.view.frame = self.mainContainer.frame
        self.mainContainer.addSubview(destVc.view)
        destVc.didMove(toParentViewController: self)
    }
    
    
}





