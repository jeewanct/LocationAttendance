//
//  AppDelegate.swift
//  bdAttendence
//
//  Created by Raghvendra on 17/04/17.

//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit
import BluedolphinCloudSdk
import IQKeyboardManagerSwift
import UserNotifications
import RealmSwift
import Fabric
import Crashlytics
import CoreLocation

/* Change on 10 July '18 New Design */
import GoogleMaps
import GooglePlaces


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        /*
         Don't config until the location is on
        */
        
        
        
        
        appIdentifier = Bundle.main.bundleIdentifier!
        APPVERSION = Bundle.main.releaseVersionNumber! + "." +  Bundle.main.buildVersionNumber!
        ConfigurationModel.setBundleId(id: appIdentifier)
        ConfigurationModel.setAppVersion(appVersion: APPVERSION)
        ConfigurationModel.setCheckinInteral(val: 600)
        // Update the SDK because i have added one function there
        ConfigurationModel.setAppName(name: "BDPresence")
        print("appversion = \(APPVERSION)")
        switch(ReleaseType.currentConfiguration()) {
        case .Debug:
            ConfigurationModel.stopDebugging(flag: false)
            print("In Debug")

            //ConfigurationModel.setAPIURL(url: "https://ariuyux3uj.execute-api.ap-southeast-1.amazonaws.com/bd/dev/")
            ConfigurationModel.setAPIURL(url: "https://dqxr67yajg.execute-api.ap-southeast-1.amazonaws.com/bd/staging/")
        case .Alpha:
            ConfigurationModel.stopDebugging(flag: false)
            print("In Alpha")
            ConfigurationModel.setAPIURL(url: "https://ariuyux3uj.execute-api.ap-southeast-1.amazonaws.com/bd/dev/")
            Fabric.with([Crashlytics.self])
        case .Release:
            print("In Release")
            ConfigurationModel.stopDebugging(flag: true)
            ConfigurationModel.setAPIURL(url: "https://dqxr67yajg.execute-api.ap-southeast-1.amazonaws.com/bd/staging/")
            Fabric.with([Crashlytics.self])
        case .Unknown:
            print("In unknown")
            break
        }
        
        BlueDolphinManager.manager.setConfig(secretKey: "hhhh", organizationId: "af39bc69-1938-4149-b9f7-f101fd9baf73")
        
        
        //setAPIURL(url: "https://bp6po2fed3.execute-api.ap-southeast-1.amazonaws.com/BD/staging/")
        //https://bp6po2fed3.execute-api.ap-southeast-1.amazonaws.com/BD/staging/
//        #if DEBUG
//            ConfigurationModel.setAPIURL(url: "https://dqxr67yajg.execute-api.ap-southeast-1.amazonaws.com/bd/staging/")
//            //ConfigurationModel.setAPIURL(url: "https://ariuyux3uj.execute-api.ap-southeast-1.amazonaws.com/bd/dev/")
//
//        #else
//            ConfigurationModel.setAPIURL(url: "https://dqxr67yajg.execute-api.ap-southeast-1.amazonaws.com/bd/staging/")
//            print("https://dqxr67yajg.execute-api.ap-southeast-1.amazonaws.com/bd/staging/")
//            Fabric.with([Crashlytics.self])
//
//        #endif
        
//        #if DEBUG
//            setAPIURL(url: "https://kxjakkoxj3.execute-api.ap-southeast-1.amazonaws.com/bd/dev/")
//        #endif
      
        IQKeyboardManager.sharedManager().enable = true
        UIDevice.current.isBatteryMonitoringEnabled = true
        registerForRemoteNotification()
        updateRealmConfiguration()
        
        //Adding a Defaults value which will show gpsCheckinSendStatus
        // And it should be set here on first launch of app
        if !SDKSingleton.sharedInstance.userId.isBlank {
            
            
            
            
            if launchOptions?[UIApplicationLaunchOptionsKey.location] != nil {
                BackgroundDebug().write(string: "UIApplicationLaunchOptionsLocationKey-Location")
                // Here check whether the shift is runing or not then only start location monitoring
                let notifier = RMCNotifier.shared
                if notifier.getShiftRunningStatus() {
                    BlueDolphinManager.manager.startLocationMonitoring()
                }
//                if SDKSingleton.sharedInstance.isShiftRunning {
//                    BlueDolphinManager.manager.startLocationMonitoring()
//                }
            }

        }
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        GMSServices.provideAPIKey(GoogleMaps.GOOGLEMAPSAPI)
        GMSPlacesClient.provideAPIKey(GoogleMaps.GOOGLEMAPSAPI)
        
        startUpTask()
        
        if !SDKSingleton.sharedInstance.userId.isBlank {
            
            if isInternetAvailable() {
                // Adding data to download assignment for status change feature if internet is there and meanwhile
                // I will start work to check the data from database and act accordingly for STATUS CHANGE FEATURE.
                
                let superController = SuperViewController()
                superController.geoTagPermission()
                superController.getPlacesAfterTenMinutes()
                
                
                if let lastAssignmentFetched = UserDefaults.standard.value(forKey: UserDefaultsKeys.LastAssignmentFetched.rawValue) as? Date {
                    let interval = Date().timeIntervalSince(lastAssignmentFetched)
                    print(interval)
                    if interval > 600 {
                        //let queryStr = "&status=" + AssignmentStatus.Assigned.rawValue + "&assignmentStartTime=" + ((Calendar.current.date(byAdding: .day, value: -15, to: Date()))?.formattedISO8601)!
                        let queryStr = "&assignmentStartTime=" + ((Calendar.current.date(byAdding: .day, value: -15, to: Date()))?.formattedISO8601)!

                        AssignmentModel.getAssignmentsForDesiredTime(query: queryStr) { (completionStatus) in
                            print("completionstatus = \(completionStatus)")
                            if completionStatus == "Success" {
                                UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.LastAssignmentFetched.rawValue)
                            }
                            print(AssignmentModel.statusOfUser())
                            
                        }
                    } else {
                        print(AssignmentModel.statusOfUser())
                        
                    }
                }else {
                    let queryStr = "&assignmentStartTime=" + ((Calendar.current.date(byAdding: .day, value: -15, to: Date()))?.formattedISO8601)!
                    AssignmentModel.getAssignmentsForDesiredTime(query: queryStr) { (completionStatus) in
                        print("completionstatus = \(completionStatus)")
                        if completionStatus == "Success" {
                            UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.LastAssignmentFetched.rawValue)
                        }
                        print(AssignmentModel.statusOfUser())
                    }
                }
            }
        }
        
        
        return true
    }
    
    
    /*
     Function Name   : isAppAlreadyLaunchedOnce
     Functionality   : Checks whether app is launched first time or allready launched
    */
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

        //NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.defaultsChanged), name: UserDefaults.didChangeNotification, object: nil)
//        window?.rootViewController?.beginAppearanceTransition(false, animated: false)
//        window?.rootViewController?.endAppearanceTransition()
        if !SDKSingleton.sharedInstance.userId.isBlank{
            if isInternetAvailable() {
                CheckinModel.postCheckin()
            }
            
        }
        
    }
    
//    func defaultsChanged(notification:NSNotification){
//        print("defaults Changed")
//        if let defaults = notification.object as? UserDefaults {
//            //get the value for key here
//        }
//    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
//        window?.rootViewController?.beginAppearanceTransition(true, animated: false)
//        window?.rootViewController?.endAppearanceTransition()
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        if !SDKSingleton.sharedInstance.userId.isBlank{

            if isInternetAvailable()  {
                
                let superController = SuperViewController()
                superController.geoTagPermission()
                
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.RMCPlaceWakeUpCall.rawValue), object: self, userInfo: nil)
                CheckinModel.postCheckin()
                // Adding data to download assignment for status change feature if internet is there and meanwhile
                // I will start work to check the data from database and act accordingly for STATUS CHANGE FEATURE.
                if let lastAssignmentFetched = UserDefaults.standard.value(forKey: UserDefaultsKeys.LastAssignmentFetched.rawValue) as? Date {
                    let interval = Date().timeIntervalSince(lastAssignmentFetched)
                    print(interval)
                    if interval > 600 {
                        let queryStr = "&assignmentStartTime=" + ((Calendar.current.date(byAdding: .day, value: -15, to: Date()))?.formattedISO8601)!
                        AssignmentModel.getAssignmentsForDesiredTime(query: queryStr) { (completionStatus) in
                            print("completionstatus = \(completionStatus)")
                            if completionStatus == "Success" {
                                UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.LastAssignmentFetched.rawValue)
                            }
                            //print(AssignmentModel.statusOfUser())
                            
                        }
                    } else {
                        //print(AssignmentModel.statusOfUser())
                        
                    }
                }else {
                    let queryStr = "&assignmentStartTime=" + ((Calendar.current.date(byAdding: .day, value: -15, to: Date()))?.formattedISO8601)!
                    AssignmentModel.getAssignmentsForDesiredTime(query: queryStr) { (completionStatus) in
                        print("completionstatus = \(completionStatus)")
                        if completionStatus == "Success" {
                            UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.LastAssignmentFetched.rawValue)
                        }
                        //print(AssignmentModel.statusOfUser())
                    }
                }
            }
        }
    }
    

    func applicationDidBecomeActive(_ application: UIApplication) {
        if !SDKSingleton.sharedInstance.userId.isBlank{
            let screenFlag = UserDefaults.standard.value(forKeyPath: "AlreadyCheckin") as? String
            
            if isInternetAvailable() && screenFlag == "1" {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.Background.rawValue), object: self, userInfo: nil)

            }
        }
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        BlueDolphinManager.manager.gpsAuthorizationStatus { (newStatus) in
//            print("newStatus = \(newStatus.rawValue)")
//        }
        
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        if !SDKSingleton.sharedInstance.userId.isBlank{
            postDataCheckin(userInteraction: CheckinDetailKeys.AppTerminated)
            
        }
       
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let defaultDeviceToken: String = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        
        print("defaultDeviceToken: \(defaultDeviceToken)")
        if defaultDeviceToken != "" {
            UserDefaults.standard.setValue(defaultDeviceToken, forKey: UserDefaultsKeys.deviceToken.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    func application( _ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error ) {
        UserDefaults.standard.setValue("3273a5f0598cd8e9518ccf07c67fbdd1ebb079d2a95aa890e259a4b70ecad57e", forKey:UserDefaultsKeys.deviceToken.rawValue )
        UserDefaults.standard.synchronize()
        //println( error.localizedDescription )
    }
    
    func startUpTask(){
        getDeviceID()
        checkLogin()
        if let deviceToken = UserDefaults.standard.value(forKey: UserDefaultsKeys.deviceToken.rawValue) as? String{
            print(deviceToken)
        }
    }
    
    func getDeviceID(){
       
        print("ID = \(UIDevice.current.identifierForVendor?.uuidString)")
//        let kcs = KeychainService()
//        if let recoveredId = kcs.load(name:"UniqueId") {
//
//           // SDKSingleton.sharedInstance.DeviceUDID = recoveredId
//            _ = kcs.save(name: "RMCIMEI", value:recoveredId as NSString)
//        }
//        if let recoveredId = kcs.load(name:"RMCIMEI") {
//
//            SDKSingleton.sharedInstance.DeviceUDID = recoveredId
//        }
//        else {
//
//            SDKSingleton.sharedInstance.DeviceUDID = DeviceUDID!
//            _ = kcs.save(name: "RMCIMEI", value: SDKSingleton.sharedInstance.DeviceUDID as NSString)
//
//        }
        if let deviceIMEID = UserDefaults.standard.value(forKey: "RMCIMEI") as? String{
            SDKSingleton.sharedInstance.DeviceUDID = deviceIMEID
        }else{
             let DeviceUDID = UIDevice.current.identifierForVendor?.uuidString
            SDKSingleton.sharedInstance.DeviceUDID = DeviceUDID!
            UserDefaults.standard.set(DeviceUDID, forKey: "RMCIMEI")
        }
        print("IMEIID" + SDKSingleton.sharedInstance.DeviceUDID)
    }
    
    
    func checkLogin(){
        getUserData()

        
        if !SDKSingleton.sharedInstance.userId.isBlank{
            
            let storyboard = UIStoryboard(name: "NewDesign", bundle: nil)
            let destVC = storyboard.instantiateViewController(withIdentifier: "Main") as! UINavigationController
            if self.window != nil {
                self.window?.rootViewController = destVC
            }
            
        }else if (UserDefaults.standard.value(forKey: UserDefaultsKeys.FeCode.rawValue) as? String) != nil {
            let storyboard = UIStoryboard(name: "NewDesign", bundle: nil)
            let destVC = storyboard.instantiateViewController(withIdentifier: "orgList") as! UINavigationController
            if self.window != nil {
                self.window?.rootViewController = destVC
            }
            
        }
        
    }
    
    func toShowLocalNotification (message : String ) {
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent()
            content.title = APPNAME
            content.body = message
            //content.badge = 1
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,
                                                            repeats: false)
            
            let requestIdentifier = "demoNotification"
            let request = UNNotificationRequest(identifier: requestIdentifier,
                                                content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request,
                                                   withCompletionHandler: { (error) in
                                                    // Handle error
                                                    print("error in notification = \(String(describing: error?.localizedDescription))")
            })
        } else {
            
        }
        
        
        
        //        DispatchQueue.main.async {
        //            let notification = UILocalNotification()
        //            notification.fireDate = NSDate(timeIntervalSinceNow: 1) as Date
        //            notification.alertBody = message
        //            notification.soundName = UILocalNotificationDefaultSoundName
        //            notification.userInfo = ["notificationType": "DoNothing"]
        //            UIApplication.shared.scheduleLocalNotification(notification)
        //        }
        
    }
    
    
    
    
    func updateRealmConfiguration(){
        let config =     Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 7,

            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in

                if oldSchemaVersion < 7 {
//                    migration.enumerateObjects(ofType: RMCBeacon.className()) { oldObject, newObject in
//
//                    }
                    migration.enumerateObjects(ofType: AccessTokenObject.className()) { oldObject, newObject in
                    }
                    migration.enumerateObjects(ofType: RMCAssignmentObject.className()) { oldObject, newObject in
                    
                    }

                }
                // Here we know app is being update so we have to call RMCPlaces
                
              //  UserDefaults.standard.setValue(false, forKey: "oldData")
                
                
                RMCPlacesManager.getPlaces()
        }

        )
        Realm.Configuration.defaultConfiguration = config
    }
}


extension AppDelegate:UNUserNotificationCenterDelegate{
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("userInfo sourabh = \(userInfo)")
        //BackgroundDebug().write(string: "didReceiveRemoteNotification- SilentPush")

        let state: UIApplicationState = application.applicationState
       
        UI {
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
        }
        
        
        /*
         @sourabh - Added new code to check whether push invoke this function in background or not.
         Ideally this function is invoked in background
        */
        //BlueDolphinManager.manager.startLocationMonitoring()
//        if let screenFlag = UserDefaults.standard.value(forKeyPath: "AlreadyCheckin") as? String{
//            if screenFlag == "1"{
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.Background.rawValue), object: self, userInfo: nil)
//            }
//
//        }
        

//        let notification = UILocalNotification()
//        notification.fireDate = NSDate(timeIntervalSinceNow: 1) as Date
//        notification.alertBody = NotificationMessage.AttendanceMarked.rawValue + "\(Date().formatted)"
//        notification.soundName = UILocalNotificationDefaultSoundName
//        notification.userInfo = ["notificationType": "FirstCheckin"]
//        UIApplication.shared.scheduleLocalNotification(notification)
//        DispatchQueue.main.async {
//            UserDefaults.standard.set(true, forKey: "AppOpenedFromAPNS")
//            UserDefaults.standard.synchronize()
//            UIApplication.shared.applicationIconBadgeNumber += 1
//        }

//        if (state == UIApplicationState.background) || (state == UIApplicationState.inactive && !appIsStarting!) {
//            // Function is called
//            UserDefaults.standard.set(true, forKey: "AppOpenedFromAPNS")
//            //call completion handler
//            //completionHandler(UIBackgroundFetchResult.newData)
//        } else if state == UIApplicationState.inactive && appIsStarting! {
//            print("User tapped notification")
//            completionHandler(UIBackgroundFetchResult.newData)
//        } else {
//            //app is active
//            print("app is active")
//            completionHandler(UIBackgroundFetchResult.noData)
//        }
        
        // Till here the new code is written .
        if state != UIApplicationState.active {
            
            //        println("json of push \(userInfo)")
            //       println(userInfo["aps"])
            UI {
                if !SDKSingleton.sharedInstance.userId.isBlank{
                    //if !SDKSingleton.sharedInstance.userId.isBlank {
                        // changed new GPSStatus checkin
                        BlueDolphinManager.manager.toSendGPSStateCheckins(currentStatus: ProjectSingleton.sharedInstance.locationAvailable)
                    //}

                    if let lastScannedTime = UserDefaults.standard.value(forKey: "LastLocationUpdate") as? Date {
                        if Date().secondsFrom(lastScannedTime) > 420 {
                            let superControllerObj = SuperViewController()
                            superControllerObj.wakeUpCall(notify: NotifyingFrom.SilentPush)
                            //NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.WakeUpCall.rawValue), object: self, userInfo: nil)
                            // Adding post checkin on arrival of wakeupcall too
                            if isInternetAvailable(){
                                CheckinModel.postCheckin()
                            }
                        } else {
                            // Dont Scan
                            print("Dont scan before 7 minutes")
                        }
                        
                    } else {
                        UserDefaults.standard.set(Date(), forKey: "LastLocationUpdate")
                        print("Location update Started")
                        let superControllerObj = SuperViewController()
                        superControllerObj.wakeUpCall(notify: NotifyingFrom.SilentPush)
                        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.WakeUpCall.rawValue), object: self, userInfo: nil)
                        // Adding post checkin on arrival of wakeupcall too
                        if isInternetAvailable(){
                            CheckinModel.postCheckin()
                        }
                        
                    }
                    
                    completionHandler(.newData)
//                     NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.WakeUpCall.rawValue), object: self, userInfo: userInfo)
//                    completionHandler(.newData)

                }
            }
            
           
            
            
        } else {
            let result: NSDictionary = userInfo as NSDictionary
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
                pushAlertView(userInfo: result)
            case NotificationType.MultipleLogout.rawValue:
            
                deleteAllData()
                moveToFirstScreen()
                bdCloudStopMonitoring()
                
            
                
            default:
                break
                
                
                
            }
            //
            completionHandler(UIBackgroundFetchResult.newData)

            
        }
        
        
    }

    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // perform fetch handler
        
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("User Info ddd= ",notification.request.content.userInfo)
        completionHandler([.alert, .badge, .sound])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response)
        print(response.actionIdentifier)
        print(response.notification)
        print(response.notification.request)
        print(response.notification.request.content)
        
        print("User Info = ",response.notification.request.content.userInfo.values)
        completionHandler()
    }
    
    func registerForRemoteNotification() {
        // iOS 10 support
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            UIApplication.shared.registerForRemoteNotifications()
        }
             //iOS 9 support
                    else if #available(iOS 9, *) {
                        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
                        UIApplication.shared.registerForRemoteNotifications()
                    }
            //            // iOS 8 support
            //        else if #available(iOS 8, *) {
            //            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            //            UIApplication.shared.registerForRemoteNotifications()
            //        }
            // iOS 7 support
        else {
            UIApplication.shared.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }
        //}
    }
    
    func pushAlertView(userInfo:NSDictionary) {
        var alertMessage = ""
        let result = userInfo ["aps"] as AnyObject
        alertMessage = result["alert"]! as! String
        
        let alert2 = UIAlertController(title: "Message", message:alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        //    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { action in
        //      //pushReceived = false
        //
        //    })
        //    alert2.addAction(cancelAction)
        alert2.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.Pushreceived.rawValue), object: self, userInfo: userInfo as? [AnyHashable : Any])
        }))
        
        
        self.window?.rootViewController?.present(alert2, animated: true, completion: nil)
        
    }
    
    
    
    func postDataCheckin(userInteraction:CheckinDetailKeys){
        let checkin = CheckinHolder()
        
        checkin.checkinDetails = [AssignmentWork.AppVersion.rawValue:APPVERSION as AnyObject,AssignmentWork.UserAgent.rawValue:"ios" as AnyObject,CheckinDetailKeys.userInteraction.rawValue:userInteraction.rawValue as AnyObject]
        checkin.checkinCategory = CheckinCategory.Data.rawValue
        checkin.checkinType = CheckinType.Data.rawValue
        //
        
        CheckinModel.createCheckin(checkinData: checkin)
        
        if isInternetAvailable(){
            CheckinModel.postCheckin()
        }
    }
}

extension UIApplication{
    var topViewController: UIViewController?{
        if keyWindow?.rootViewController == nil{
            return keyWindow?.rootViewController
        }
        
        var pointedViewController = keyWindow?.rootViewController
        
        while  pointedViewController?.presentedViewController != nil {
            switch pointedViewController?.presentedViewController {
            case let navagationController as UINavigationController:
                pointedViewController = navagationController.viewControllers.last
            case let tabBarController as UITabBarController:
                pointedViewController = tabBarController.selectedViewController
            default:
                pointedViewController = pointedViewController?.presentedViewController
            }
        }
        return pointedViewController
        
    }
}
