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


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

            
            BlueDolphinManager.manager.setConfig(secretKey: "hhhh", organizationId: "af39bc69-1938-4149-b9f7-f101fd9baf73")
    
        setAppVersion(appVersion: APPVERSION)
        //setAPIURL(url: "https://kxjakkoxj3.execute-api.ap-southeast-1.amazonaws.com/bd/dev/")
        
        Fabric.with([Crashlytics.self])

        IQKeyboardManager.sharedManager().enable = true
         UIDevice.current.isBatteryMonitoringEnabled = true
        registerForRemoteNotification()
        updateRealmConfiguration()
        startUpTask()
       
        
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.Background.rawValue), object: self, userInfo: nil)        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let defaultDeviceToken: String = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        
        // println("defaultDeviceToken: \(defaultDeviceToken)")
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
        
    }
    
    func getDeviceID(){
        let DeviceUDID = UIDevice.current.identifierForVendor?.uuidString
        print(DeviceUDID ?? "")
        let kcs = KeychainService()
        if let recoveredId = kcs.load(name:"UniqueId") {
            SDKSingleton.sharedInstance.DeviceUDID = recoveredId
        }
        else {
            
            SDKSingleton.sharedInstance.DeviceUDID = DeviceUDID!
            _ = kcs.save(name: "UniqueId", value: SDKSingleton.sharedInstance.DeviceUDID as NSString)
        }
    }
    func checkLogin(){
        getUserData()
        
        
        if !SDKSingleton.sharedInstance.userId.isBlank{
            
            if let screenFlag = UserDefaults.standard.value(forKeyPath: "AlreadyCheckin") as? String{
                if screenFlag == "true"{
                    let storyboard = UIStoryboard(name: "NewDesign", bundle: nil)
                    let destVC = storyboard.instantiateViewController(withIdentifier: "home") as! UINavigationController
                    if self.window != nil {
                        self.window?.rootViewController = destVC
                    }
                }
                else{
                    let storyboard = UIStoryboard(name: "NewDesign", bundle: nil)
                    let destVC = storyboard.instantiateViewController(withIdentifier: "Main") as! UINavigationController
                    if self.window != nil {
                        self.window?.rootViewController = destVC
                    }
                }
            }else{
                let storyboard = UIStoryboard(name: "NewDesign", bundle: nil)
                let destVC = storyboard.instantiateViewController(withIdentifier: "Main") as! UINavigationController
                if self.window != nil {
                    self.window?.rootViewController = destVC
                }
            }
           
        }
        
    }
   
    func updateRealmConfiguration(){
        let config =     Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                
                if oldSchemaVersion < 1 {
                    migration.enumerateObjects(ofType: RMCBeacon.className()) { oldObject, newObject in
                        
                    }    }
        }
            
        )
        Realm.Configuration.defaultConfiguration = config
    }
    
    



}

extension AppDelegate:UNUserNotificationCenterDelegate{
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        let state: UIApplicationState = application.applicationState
        if state != UIApplicationState.active {
            
            //        println("json of push \(userInfo)")
            //       println(userInfo["aps"])
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.Pushreceived.rawValue), object: self, userInfo: userInfo)
            
            
        } else {
            let result: NSDictionary = userInfo as NSDictionary
            let type:NotificationType = NotificationType(rawValue: result ["notificationType"] as! String)!
            switch type {
            case .Welcome:
                break
            case .NewAssignment,.FirstCheckin:
                //self.showLocalNotification(userInfo)
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.Pushreceived.rawValue), object: self, userInfo: userInfo)
            case .UpdatedAssignment,.NoCheckin:
                break;
                
            
                
            }
            //
            
        }
        completionHandler(UIBackgroundFetchResult.noData)
        
        
    }
    // MARK: UNUserNotificationCenter Delegate // >= iOS 10
    
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
            // iOS 9 support
            //        else if #available(iOS 9, *) {
            //            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            //            UIApplication.shared.registerForRemoteNotifications()
            //        }
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
    
    
    
    
   
    
    
   
    
    
    
}

