//
//  MainViewController.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 01/12/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class MainViewController: UIViewController {
    @IBOutlet weak var mainContainerView: UIView!
    var seanbeacons = NSMutableDictionary()
    var beaconSentflag = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let oauth = OauthModel()
        oauth.updateToken()
        Singleton.sharedInstance.sortBy = SortEnum.ClearSort.rawValue
        setObservers()
        getNearByBeacons()
        postdbAssignment()
       
        //        postTransientCheckin()
        // Do any additional setup after loading the view.
    }
    func setObservers(){
        NotificationCenter.default .removeObserver(self, name: NSNotification.Name(rawValue: LocalNotifcation.Pushreceived.rawValue), object: nil)
        NotificationCenter.default .addObserver(self, selector: #selector(MainViewController.methodOfReceivedNotification(notification:)), name: NSNotification.Name(rawValue: LocalNotifcation.Pushreceived.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.ShowController(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.Assignment.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.ShowController(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.Profile.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.ShowController(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.VirtualBeacon.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.ShowController(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.Draft.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.ShowController(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.BaseAnalytics.rawValue), object: nil)
    }
    
    func getNearByBeacons(){
        let vicinityManager = VicinityManager()
        if isInternetAvailable() {
            vicinityManager.getNearByBeacons { (value) in
                switch value {
                case .StartScanning:
                    self.startScanning()
                case .Failure,.NoScanning:
                    break;
                    
                }
            }
        }
        
    }
    func postdbAssignment(){
        let assignmentModel = AssignmentModel()
        if isInternetAvailable() {
            assignmentModel.postdbAssignments()
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
    
    func showAlertView(alertMessage:String) {
        //let result: AnyObject? = userInfo ["aps"]
        
        
        let alert = UIAlertController(title: "Message", message:alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
            
            
            
            
        })
        alert.addAction(cancelAction)
        //        alert2.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
        //
        //        }))
        //
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    func updateNewAssignmentData(id:String){
        let model = AssignmentModel()
        if model.getAssignmentFromDb(assignmentId: id).count == 0 {
            if isInternetAvailable() {
                model.getAssignments(assignmentId: id) { (success) in
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.NewAssignment.rawValue), object: self, userInfo: nil)
                    self.pushAlertView(alertMessage: "New Assignment received Do you want to see ?")
                }
            }
            
        }
        
    }
    
    
    func pushAlertView(alertMessage:String) {
        let alert2 = UIAlertController(title: "Alert", message:alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { action in
            //pushReceived = false
            
        })
        alert2.addAction(cancelAction)
        
        
        alert2.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.Assignment.rawValue), object: self, userInfo: nil)
        }))
        
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alert2, animated: true, completion: nil)
        
    }
    
    
    
    
}


extension MainViewController {
    func ShowController (sender : NSNotification) {
        switch (sender.name.rawValue) {
        case LocalNotifcation.Profile.rawValue:
            
            //      for views in mainContainer.subviews {
            //        views.removeFromSuperview()
            //      }
            //println(self.childViewControllers.count)
            var lastController: AnyObject?
            
            if let controller =  self.childViewControllers.first as? UINavigationController {
                lastController = controller
            } else {
                lastController = self.childViewControllers.last as! UINavigationController
            }
            for views in self.mainContainerView.subviews {
                views.removeFromSuperview()
            }
            
            lastController?.willMove(toParentViewController: nil)
            //lastController?.willMoveToParentViewController(toSuperview: nil)
            lastController?.removeFromParentViewController()
            let destVc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileScene") as! UINavigationController
            //println(self.childViewControllers)
            self.addChildViewController(destVc)
            destVc.view.frame = self.mainContainerView.frame
            
            self.mainContainerView.addSubview(destVc.view)
            destVc.didMove(toParentViewController: self)
            
            
        case LocalNotifcation.Assignment.rawValue:
            
            
            var lastController: AnyObject?
            
            if let controller =  self.childViewControllers.first as? UINavigationController {
                lastController = controller
            } else {
                lastController = self.childViewControllers.last as! UINavigationController
            }
            for views in self.mainContainerView.subviews {
                views.removeFromSuperview()
            }
            lastController?.willMove(toParentViewController: nil)
            
            lastController?.removeFromParentViewController()
            let destVc = self.storyboard?.instantiateViewController(withIdentifier: "AssignmentScene") as! UINavigationController
            self.addChildViewController(destVc)
            destVc.view.frame = self.mainContainerView.frame
            self.mainContainerView.addSubview(destVc.view)
            destVc.didMove(toParentViewController: self)
        case LocalNotifcation.VirtualBeacon.rawValue:
            
            
            var lastController: AnyObject?
            
            if let controller =  self.childViewControllers.first as? UINavigationController {
                lastController = controller
            } else {
                lastController = self.childViewControllers.last as! UINavigationController
            }
            for views in self.mainContainerView.subviews {
                views.removeFromSuperview()
            }
            lastController?.willMove(toParentViewController: nil)
            
            lastController?.removeFromParentViewController()
            let destVc = self.storyboard?.instantiateViewController(withIdentifier: "VirtualBeacon") as! UINavigationController
            self.addChildViewController(destVc)
            destVc.view.frame = self.mainContainerView.frame
            self.mainContainerView.addSubview(destVc.view)
            destVc.didMove(toParentViewController: self)
        case LocalNotifcation.Draft.rawValue:
            
            
            var lastController: AnyObject?
            
            if let controller =  self.childViewControllers.first as? UINavigationController {
                lastController = controller
            } else {
                lastController = self.childViewControllers.last as! UINavigationController
            }
            for views in self.mainContainerView.subviews {
                views.removeFromSuperview()
            }
            lastController?.willMove(toParentViewController: nil)
            
            lastController?.removeFromParentViewController()
            let destVc = self.storyboard?.instantiateViewController(withIdentifier: "draftNav") as! UINavigationController
            self.addChildViewController(destVc)
            destVc.view.frame = self.mainContainerView.frame
            self.mainContainerView.addSubview(destVc.view)
            destVc.didMove(toParentViewController: self)
        case LocalNotifcation.BaseAnalytics.rawValue:
            
            
            var lastController: AnyObject?
            
            if let controller =  self.childViewControllers.first as? UINavigationController {
                lastController = controller
            } else {
                lastController = self.childViewControllers.last as! UINavigationController
            }
            for views in self.mainContainerView.subviews {
                views.removeFromSuperview()
            }
            lastController?.willMove(toParentViewController: nil)
            
            lastController?.removeFromParentViewController()
            let destVc = self.storyboard?.instantiateViewController(withIdentifier: "baseNav") as! UINavigationController
            self.addChildViewController(destVc)
            destVc.view.frame = self.mainContainerView.frame
            self.mainContainerView.addSubview(destVc.view)
            destVc.didMove(toParentViewController: self)
            
        default:
            /* let destVc = self.storyboard?.instantiateViewControllerWithIdentifier("blue") as! UINavigationController
             self.addChildViewController(destVc)
             destVc.view.frame = self.mainContainer.frame
             self.mainContainer.addSubview(destVc.view)
             destVc.didMoveToParentViewController(self)*/
            print("")
        }
    }
    
    func methodOfReceivedNotification(notification: NSNotification){
        let result: NSDictionary = notification.userInfo! as NSDictionary
        let type:NotificationType = NotificationType(rawValue: result ["notificationType"] as! String)!
        switch type {
        case .Welcome:
            showAlertView(alertMessage: "Welcome to BlueDolphin Cloud")
            break
        case .NewAssignment,.UpdatedAssignment:
            if let assignmentId = result["assignmentId"] as? String{
                
                
                updateNewAssignmentData(id: assignmentId)
            }
            
        }
        
        
        
        
        
        // //println(notification)
        
        //    self.goToScreen(status,info: result)
    }
    
    func goToScreen(flag:Int,info:NSDictionary){
        //switch flag {}
        
    }
    
}

extension MainViewController {
    
    
    func startScanning(){
        let beaconManager = IBeaconManager()
        var beaconArray = [iBeacon]()
        //        let estimoteBeacon1 = iBeacon(minor: 10010, major: 24361, proximityId: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")
        //        let estimoteBeacon2 = iBeacon(minor: 10858, major: 27403, proximityId: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")
        //        let estimoteBeacon3 = iBeacon(minor: 21481, major: 21826, proximityId: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")
        let vicinityManager = VicinityManager()
        
        let beaconsData = vicinityManager.fetchBeaconsFromDb()
        for beaconObject in beaconsData{
            let ibeacon =
                iBeacon(minor: beaconObject.minor, major: beaconObject.major, proximityId: beaconObject.uuid!, id: beaconObject.beaconId!)
            beaconArray.append(ibeacon)
        }
        
        beaconManager.registerBeacons(beaconArray)
        //        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: iBeaconNotifications.BeaconProximity.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(beaconsRanged(notification:)), name: NSNotification.Name(rawValue: iBeaconNotifications.BeaconProximity.rawValue), object: nil)
        
        beaconManager.startMonitoring({
            
        }) { (messages) in
            print("Error Messages \(messages)")
        }
    }
    
   
    
    
    func sendNotification() {
       
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,
                                                        repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "Bluedolphin ALert"
        content.subtitle = ""
        content.body = "Your attendance has been marked"
        content.badge = 0
   
        content.sound = UNNotificationSound.default()
        
        let request = UNNotificationRequest(identifier: "textNotification", content: content, trigger: trigger)
        
        //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("Uh oh! We had an error: \(error)")
            }
        }
    }
    /**Called when the beacons are ranged*/
    func beaconsRanged(notification:NSNotification){
        if let visibleIbeacons = notification.object as? [iBeacon]{
            
            
            for beacon in visibleIbeacons{
                /// Do something with the iBeacon
                
                let dict = [
                    "uuid" : beacon.UUID ,
                    "major": String(describing: beacon.major!),
                    "minor" : String(describing: beacon.minor!),
                    //"proximity" :  String(describing: beacon.proximity),
                    "rssi" : beacon.rssi,
                    "distance" :beacon.accuracy,
                    "lastseen" : getCurrentDate().formattedISO8601
                    
                ]
                seanbeacons.addEntries(from: [beacon.major! :dict])
                print(dict)
            }
            if beaconSentflag {
                beaconSentflag = false
                sendNotification()
                let delay = 60.0 * Double(NSEC_PER_SEC)
                let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: time, execute: {
                    self.beaconSentflag = true
                    
                    if self.seanbeacons.count != 0 {
                        
                        let checkin = CheckinHolder()
                        var beaconArray = Array<Any>()
                        for (_,value) in self.seanbeacons {
                            beaconArray.append(value)
                        }
                        checkin.beaconProximities = beaconArray
                        checkin.checkinDetails = [AssignmentWork.AppVersion.rawValue:AppVersion as AnyObject,AssignmentWork.UserAgent.rawValue:deviceType as AnyObject]
                        checkin.checkinCategory = CheckinCategory.Transient.rawValue
                        checkin.checkinType = CheckinType.Beacon.rawValue
                        self.seanbeacons = NSMutableDictionary()                //        checkin.imageName = imageName + Date().formattedISO8601
                        //        checkin.relativeUrl = imageId
                        let checkinModelObject = CheckinModel()
                        checkinModelObject.createCheckin(checkinData: checkin)
                                                if isInternetAvailable(){
                                                    checkinModelObject.postCheckin()
                                                }
                        
                    }
                })
            }
            
            
            
        }
    }
}
