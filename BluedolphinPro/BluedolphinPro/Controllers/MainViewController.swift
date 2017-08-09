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
      
        OauthModel.updateToken()
        Singleton.sharedInstance.sortBy = SortEnum.ClearSort.rawValue
        setObservers()
        BlueDolphinManager.manager.getNearByBeacons { (value) in
        
        }
        postdbAssignment()
        DynamicObjectManager.getDObjecct { (value) in
        
        }
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
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.ShowController(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.Attendance.rawValue), object: nil)
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
            BlueDolphinManager.manager.stopScanning()
            
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
            
             BlueDolphinManager.manager.startScanning()
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
        case LocalNotifcation.Attendance.rawValue:
            
            
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
            let destVc = self.storyboard?.instantiateViewController(withIdentifier: "markAttendance") as! UINavigationController
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
    
    
   
    
    
    
    
//    func sendNotification(id:String) {
//        var address = String()
//        let beacon = VicinityManager.fetchBeaconsFromDb(uuid: id)
//        for data in beacon{
//            address = data.address!
//        }
//        
//        if #available(iOS 10.0, *) {
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,
//                                                            repeats: false)
//        } else {
//            // Fallback on earlier versions
//        }
//        
//        if #available(iOS 10.0, *) {
//            let content = UNMutableNotificationContent()
//        } else {
//            // Fallback on earlier versions
//        }
//        content.title = "Bluedolphin Alert"
//        content.subtitle = ""
//        content.body = "Your entered a location \(address)"
//        content.badge = 0
//        
//        if #available(iOS 10.0, *) {
//            content.sound = UNNotificationSound.default()
//        } else {
//            // Fallback on earlier versions
//        }
//        
//        if #available(iOS 10.0, *) {
//            let request = UNNotificationRequest(identifier: "textNotification", content: content, trigger: trigger)
//        } else {
//            // Fallback on earlier versions
//        }
//        
//        //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//        if #available(iOS 10.0, *) {
//            UNUserNotificationCenter.current().add(request) {(error) in
//                if let error = error {
//                    print("Uh oh! We had an error: \(error)")
//                }
//            }
//        } else {
//            // Fallback on earlier versions
//        }
//    }
    /**Called when the beacons are ranged*/
   
}
