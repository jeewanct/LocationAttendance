//
//  NewCheckinViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 22/06/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit
import BluedolphinCloudSdk
import SwiftGifOrigin

class NewCheckinViewController: UIViewController {

    @IBOutlet weak var swipeLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkInImageView: UIImageView!
    @IBOutlet weak var statusChangeView: UIView!
    @IBOutlet weak var syncButton: UIBarButtonItem!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var unavailableUntilLbl: UILabel!
    var activityIndicator : ActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.isTranslucent = true
        navigationController?.removeTransparency()
        
        
       self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu")?.withRenderingMode(.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(menuAction(sender:)))
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        nameLabel.font = APPFONT.DAYHOUR
        nameLabel.text = "Hi " + SDKSingleton.sharedInstance.userName.capitalized + ","
        quoteLabel.font = APPFONT.PERMISSIONBODY
        swipeLabel.font = APPFONT.FOOTERBODY
        
        // Do any additional setup after loading the view.
        checkInImageView.loadGif(name: "swipeUp")
    }
    override func viewDidAppear(_ animated: Bool) {
        statusOfUser()
    }
    
    @IBAction func syncTapped(_ sender: Any) {
        self.syncButton.isEnabled = false
        //"&status=" + AssignmentStatus.Assigned.rawValue
        let queryStr = "&assignmentStartTime=" + ((Calendar.current.date(byAdding: .day, value: -15, to: Date()))?.formattedISO8601)!
        activityIndicator = ActivityIndicatorView()
        self.statusChangeView.showActivityIndicator(activityIndicator: activityIndicator!)
        AssignmentModel.getAssignmentsForDesiredTime(query: queryStr) { (completionStatus) in
            self.statusChangeView.removeActivityIndicator(activityIndicator: self.activityIndicator!)
            UI {
                print("completionstatus = \(completionStatus)")
                if completionStatus == "Success" {
                    UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.LastAssignmentFetched.rawValue)
                }
                if AssignmentModel.statusOfUser() {
                    // Here i have to swipe down the user screen to stop mobitoring
                    self.statusChangeView.isHidden = false
                    self.syncButton.isEnabled = true
                    //if let screenFlag = UserDefaults.standard.value(forKeyPath: "AlreadyCheckin") as? String {
                        //if screenFlag == "1" {
                            //UserDefaults.standard.set(false, forKey: UserDefaultsKeys.ManualSwipeDown.rawValue)
                            
                            UI {
                                //UserDefaults.standard.set("2", forKey: "AlreadyCheckin")
                                // New change on 20/06/2018 to create one checkin
                                if isInternetAvailable(){
                                    CheckinModel.postCheckin()
                                }
                                bdCloudStopMonitoring()
                                
                               
                            }
                        //}
                    //}
                } else {
                    self.statusChangeView.isHidden = true
                    self.syncButton.isEnabled = false
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.CheckoutScreen.rawValue), object: self, userInfo: ["check":true])
//                    let superController = SuperViewController()
//                    superController.wakeUpCall(notify: NotifyingFrom.Normal)
                }
            }
        }
        
    }
    
    func statusOfUser(){
        if AssignmentModel.statusOfUser() {
            //            if let screenFlag = UserDefaults.standard.value(forKeyPath: "AlreadyCheckin") as? String {
            //                if screenFlag == "1" {
            //                   // UserDefaults.standard.set(false, forKey: UserDefaultsKeys.ManualSwipeDown.rawValue)
            //
            //                    UI {
            ////                        UserDefaults.standard.set("2", forKey: "AlreadyCheckin")
            ////                        // New change on 20/06/2018 to create one checkin
            ////                        if isInternetAvailable(){
            ////                            CheckinModel.postCheckin()
            ////                        }
            //                        bdCloudStopMonitoring()
            //
            //                        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.CheckinScreen.rawValue), object: self, userInfo: ["check":true])
            //
            //                    }
            //                }
            //            }
            bdCloudStopMonitoring()
            self.dateLabel.text = Date().formattedWith(format: "MMM dd, yyyy")
            self.unavailableUntilLbl.text = "Unavailable till \((SDKSingleton.sharedInstance.toTimeStampForStatusChange?.formattedWith(format: "MMM dd, yyyy hh:mm a"))!)"
            self.statusChangeView.isHidden = false
            self.syncButton.isEnabled = true
            self.syncButton.tintColor = APPColor.BlueGradient
            
        } else {
            self.statusChangeView.isHidden = true
            self.syncButton.isEnabled = false
            self.syncButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            if let screenFlag = UserDefaults.standard.value(forKeyPath: "AlreadyCheckin") as? String {
                if screenFlag == "2" {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.CheckoutScreen.rawValue), object: self, userInfo: ["check":true])
                }
            }
        }
    }
    
    
    func handleGesture(sender:UIGestureRecognizer){
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.ManualSwipe.rawValue)
        UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.ManualSwipedDate.rawValue)
        UserDefaults.standard.set("1", forKey: "AlreadyCheckin")
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.ManualSwipeDown.rawValue)

        UserDefaults.standard.synchronize()
        print("In handleGesture NewCheckinViewController")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.CheckoutScreen.rawValue), object: self, userInfo: nil)
//        if isAppAlreadyLaunchedOnce() {
//            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.ManualSwipe.rawValue)
//            UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.ManualSwipedDate.rawValue)
//            UserDefaults.standard.set("1", forKey: "AlreadyCheckin")
//            UserDefaults.standard.synchronize()
//
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.CheckoutScreen.rawValue), object: self, userInfo: nil)
//        } else {
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
//                UserDefaults.standard.set(true, forKey: UserDefaultsKeys.ManualSwipe.rawValue)
//                UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.ManualSwipedDate.rawValue)
//                UserDefaults.standard.set("1", forKey: "AlreadyCheckin")
//                UserDefaults.standard.synchronize()
//
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.CheckoutScreen.rawValue), object: self, userInfo: nil)
//            }
//        }
        
        
        
//       let controller = self.storyboard?.instantiateViewController(withIdentifier: "newCheckout") as? UINavigationController
//       self.present(controller!, animated: true) {
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.Dashboard.rawValue), object: self, userInfo: nil)
//        }
        //self.show(controller!, sender: nil)
        
        
    }
    
    func menuAction(sender:UIBarButtonItem){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowSideMenu"), object: nil)
    
    }
    
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.'
        
        
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
