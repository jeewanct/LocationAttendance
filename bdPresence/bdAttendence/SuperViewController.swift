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
        
        //06/06/2018 - Sourabh
//        if isInternetAvailable(){
//            checkShiftStatus()
//            
//        }
        
        //setObservers()
        //Adding Check blocker to solve a bug when permission is denied at first time
        checkBlockerScreen()
        updateTask()
        
        wakeUpCall(notify: NotifyingFrom.Normal)

    
    }
    func handleLeftGesture() {
      
        self.showMenuView()
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         setObservers()
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    
    func setObservers(){
         NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(SuperViewController.wakeUp(sender:)), name: NSNotification.Name(LocalNotifcation.WakeUpCall.rawValue), object: nil)

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

        NotificationCenter.default.addObserver(self, selector: #selector(shiftHandling), name: NSNotification.Name(rawValue: LocalNotifcation.ShiftEnded.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(locationCheckin(sender:)), name: NSNotification.Name(rawValue: iBeaconNotifications.Location.rawValue), object: nil)
        
    }
    
    func wakeUp (sender : NSNotification) {
        self.wakeUpCall(notify: NotifyingFrom.SilentPush)
    }
    
    func wakeUpCall (notify: NotifyingFrom) {
        let rmcNotifier = RMCNotifier.shared
        print(notify)
        
        rmcNotifier.notifyUserForStartScanning(notifying: notify, completion:{ (notifier) in
            print("notify response = \(notifier)")
            print(UserDefaults.standard.value(forKey: "AlreadyCheckin") as? String)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let tempNotifier = notifier as [String : AnyObject]
            if tempNotifier["status"] as! Bool {
                UI {
                    if let screenFlag = UserDefaults.standard.value(forKeyPath: "AlreadyCheckin") as? String {
                        print("screenflag = \(screenFlag)")
                        
                        if screenFlag == "1" {
                            // Already swipedup
                            //start scanning
                            bdCloudStartMonitoring()
                        } else if screenFlag == "2" {
                            // automatic checkin function
                            appDelegate.postDataCheckin(userInteraction: .swipeUpAuto)
                            //then set defaults value to 1
                            // sending userinfo which will tell dashboard to work accordingly
                            // with the userinfo will tell which type of chekin to be sent and do not check for blocker screen
                            UserDefaults.standard.set("1", forKey: "AlreadyCheckin")
                            appDelegate.toShowLocalNotification(message: "We are now trying to mark your presence")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.CheckoutScreen.rawValue), object: self, userInfo: ["check":true])
                        }
                    } else {
                        appDelegate.postDataCheckin(userInteraction: .swipeUpAuto)
                        UserDefaults.standard.set("1", forKey: "AlreadyCheckin")
                        appDelegate.toShowLocalNotification(message: "We are now trying to mark your presence")
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.CheckoutScreen.rawValue), object: self, userInfo: ["check":true])
                        
                    }
                }
                
            } else {
                // Swipe down code
                if tempNotifier["message"] as! String == notifyUserResponse.swipeDownAndStopScanning.rawValue {
                    
                    if let screenFlag = UserDefaults.standard.value(forKeyPath: "AlreadyCheckin") as? String {
                        if screenFlag == "1" {
                            appDelegate.postDataCheckin(userInteraction: .swipeDownAuto)
                            
                            UI {
                                UserDefaults.standard.set("2", forKey: "AlreadyCheckin")
                                
                                bdCloudStopMonitoring()
                                appDelegate.toShowLocalNotification(message: "Looks like you're out of office. Time to relax!")
                                
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.CheckinScreen.rawValue), object: self, userInfo: ["check":true])
                                
                                //                                createLocalNotification(message: "Looks like you're out of office. Time to relax!")
                            }
                        }
                    }
                } else if tempNotifier["message"] as! String == notifyUserResponse.shiftEnded.rawValue {
                    print("shift ended")
                    
                } else if tempNotifier["message"] as! String == notifyUserResponse.noShiftToday.rawValue {
                    print("noshifttoday")
                    // In any case if this calls then i have to show no shift today and stop monitorig
                    bdCloudStopMonitoring()
                    
                } else if tempNotifier["message"] as! String == notifyUserResponse.manualSwipeStateChangedToday.rawValue {
                    print("Do nothing")
                }
                
            }
            
        })
    }

    
    
    
    func shiftHandling(){
        UserDefaults.standard.set("2", forKey: "AlreadyCheckin")
        UserDefaults.standard.synchronize()
        bdCloudStopMonitoring()
        
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
            bdCloudStopMonitoring()
         
            
            
        default:
            break
            
            
            
        }
        
    }
    func updateTask(){
        //Changing as per new change for same organisation
        checkForceUpdate()
        if isInternetAvailable() {
           //self.showLoader()
            BlueDolphinManager.manager.updateToken()
        }
        if let screenFlag = UserDefaults.standard.value(forKeyPath: "AlreadyCheckin") as? String{
            if screenFlag == "1"{
                
                bdCloudStartMonitoring()
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
    
    
    // SOurabh- Removing this function because it's allready done in SDK
    /*
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
 */
    
    func checkPermissionStatus(sender:NSNotification){
        updateTask()
        checkBlockerScreen()
        if isInternetAvailable(){
           checkDeviceStatus()
        }
        
        
    }
    
    func checkForceUpdate(){
        if !SDKSingleton.sharedInstance.iosAPPVersion.isBlank {
            let storeVersion = SDKSingleton.sharedInstance.iosAPPVersion
            if storeVersion.compare(APPVERSION, options: .numeric) == .orderedDescending {
                forceupdatePopup()
            }

        }
    }
    
    func checkBlockerScreen() {
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                ProjectSingleton.sharedInstance.locationAvailable = false
                
            case  .authorizedWhenInUse:
                ProjectSingleton.sharedInstance.locationAvailable = false
                
            case .authorizedAlways:
                ProjectSingleton.sharedInstance.locationAvailable = true
            }
            
        } else {
            ProjectSingleton.sharedInstance.locationAvailable = false
           
        }
        
        if (ProjectSingleton.sharedInstance.locationAvailable == false ){
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "permission") as! NewPermissionViewController
            self.present(controller, animated: true, completion: nil)
        }
        
        // changed new GPSStatus checkin
        BlueDolphinManager.manager.toSendGPSStateCheckins(currentStatus: ProjectSingleton.sharedInstance.locationAvailable)
        
        /*
        var previousGpsStatus : Bool! 
        if let tempGpsStatus = UserDefaults.standard.value(forKey: PREVIOUSGPSSTATUS) as? Bool  {
           previousGpsStatus = tempGpsStatus
        }
        
        print("Location enabled \(ProjectSingleton.sharedInstance.locationAvailable)")

        if previousGpsStatus != nil {
            
        } else {
            UserDefaults.standard.set(ProjectSingleton.sharedInstance.locationAvailable, forKey: PREVIOUSGPSSTATUS)
            previousGpsStatus = ProjectSingleton.sharedInstance.locationAvailable
            postGpsStateDataCheckin()
            if !ProjectSingleton.sharedInstance.locationAvailable {
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "permission") as! NewPermissionViewController
                self.present(controller, animated: true, completion: nil)
            }
        }

        if ProjectSingleton.sharedInstance.locationAvailable && !previousGpsStatus {
            UserDefaults.standard.set(ProjectSingleton.sharedInstance.locationAvailable, forKey: PREVIOUSGPSSTATUS)
            
            postGpsStateDataCheckin()
        } else if (ProjectSingleton.sharedInstance.locationAvailable && previousGpsStatus) {
            //don't send checkin and dont update data
        } else if (!ProjectSingleton.sharedInstance.locationAvailable && previousGpsStatus) {
            UserDefaults.standard.set(ProjectSingleton.sharedInstance.locationAvailable, forKey: PREVIOUSGPSSTATUS)
            postGpsStateDataCheckin()
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "permission") as! NewPermissionViewController
            self.present(controller, animated: true, completion: nil)

        } else if (!ProjectSingleton.sharedInstance.locationAvailable && !previousGpsStatus) {
            //do nothing
        }
        
        UserDefaults.standard.synchronize()
        
        */
//        if ProjectSingleton.sharedInstance.locationAvailable == false && previousGpsStatus{
//            //Here we should have a callback which will ensure the correct app flow
//            postGpsStateDataCheckin()
//            UserDefaults.standard.set(<#T##value: Bool##Bool#>, forKey: <#T##String#>)
//            let controller = self.storyboard?.instantiateViewController(withIdentifier: "permission") as! NewPermissionViewController
//            self.present(controller, animated: true, completion: nil)
//        } else if ProjectSingleton.sharedInstance.locationAvailable == false && previousGpsStatus {
//            postGpsStateDataCheckin()
//            let controller = self.storyboard?.instantiateViewController(withIdentifier: "permission") as! NewPermissionViewController
//            self.present(controller, animated: true, completion: nil)
//
//        }else if ProjectSingleton.sharedInstance.locationAvailable == true && !previousGpsStatus {
//            postGpsStateDataCheckin()
//        }

    }
    
    //Assigning the GPSSENDCHECKINSTATUS value when sucessfull checkin is send to server
    //UserDefaults.standard.set("true", forKey: GPSSENDCHECKINSTATUS)
    
    
    func locationCheckin(sender:NSNotification){
        
        
        if let screenFlag = UserDefaults.standard.value(forKeyPath: "AlreadyCheckin") as? String{
            if screenFlag == "1"{
               
                    if let lastLocationCheckin = UserDefaults.standard.value(forKeyPath: UserDefaultsKeys.LastLocationCheckinTime.rawValue) as? Date {
                        print( "Difference last \(lastLocationCheckin.minuteFrom(Date()))")
                        if Date().secondsFrom(lastLocationCheckin) > CONFIG.CHECKININTERVAL{
                            let checkin = CheckinHolder()
                            
                            checkin.checkinDetails = [AssignmentWork.AppVersion.rawValue:APPVERSION as AnyObject,AssignmentWork.UserAgent.rawValue:"ios" as AnyObject]
                            checkin.checkinCategory = CheckinCategory.Transient.rawValue
                            checkin.checkinType = CheckinType.Location.rawValue
                            //
                            
                            CheckinModel.createCheckin(checkinData: checkin)
                          
                            if isInternetAvailable(){
                                CheckinModel.postCheckin()
                            }
                        }
                    } else{
                        //this will executed once
                        let checkin = CheckinHolder()
                        
                        checkin.checkinDetails = [AssignmentWork.AppVersion.rawValue:APPVERSION as AnyObject,AssignmentWork.UserAgent.rawValue:"ios" as AnyObject]
                        checkin.checkinCategory = CheckinCategory.Transient.rawValue
                        checkin.checkinType = CheckinType.Location.rawValue
                        //
                        
                        CheckinModel.createCheckin(checkinData: checkin)
                       
                        if isInternetAvailable(){
                            CheckinModel.postCheckin()
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
                if !SDKSingleton.sharedInstance.DeviceUDID.isBlank && !id.isBlank{
                    if id.capitalized != SDKSingleton.sharedInstance.DeviceUDID.capitalized{
                        deleteAllData()
                        moveToFirstScreen()
                        bdCloudStopMonitoring()
                    }
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
    
    
    
    func showAlert(_ message : String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (action) in
            return        }
        alertController.addAction(OkAction)
        self.present(alertController, animated: true) {
        }
    }
    
    func forceupdatePopup(){
        let actionSheetController: UIAlertController = UIAlertController(title: "BDAttendance", message: "New version is available! Please update your app from the App Store", preferredStyle: .alert)
        let nextAction: UIAlertAction = UIAlertAction(title: "Update", style: .default) { action -> Void in
            
            let application:UIApplication = UIApplication.shared
            let storeUrl = URL(string: AppstoreURL)
            if (application.canOpenURL(storeUrl!)) {
                application.openURL(storeUrl!);
            }
            else {
                self.showAlert( "Unable to open AppStore.")
            }
        }
        actionSheetController.addAction(nextAction)
        self.present(actionSheetController, animated: true, completion: nil)
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





