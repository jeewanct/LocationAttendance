//
//  DayCheckoutViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 03/07/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit
import BluedolphinCloudSdk
import SwiftGifOrigin

class DayCheckoutViewController: UIViewController {
    @IBOutlet weak var swipeLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var syncButton: UIBarButtonItem!
    
    /* Changes made from 10th July '18 */
    
    @IBOutlet weak var checkInImageView: UIImageView!
    
    
    @IBOutlet weak var statusChangeView: UIView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var unavailableUntilLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        navigationController?.removeTransparency()
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.isTranslucent = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        statusOfUser()
    }
    
    func setupView(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu")?.withRenderingMode(.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(menuAction(sender:)))
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        nameLabel.font = APPFONT.DAYHOUR
        nameLabel.text = "Hi " + SDKSingleton.sharedInstance.userName + ","
        quoteLabel.font = APPFONT.PERMISSIONBODY
        swipeLabel.font = APPFONT.FOOTERBODY
        
        
        checkInImageView.loadGif(name: "swipeUp")
    }
    
    
    func handleGesture(sender:UIGestureRecognizer){
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.ManualSwipe.rawValue)
        UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.ManualSwipedDate.rawValue)
        UserDefaults.standard.set("1", forKey: "AlreadyCheckin")
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.ManualSwipeDown.rawValue)

        UserDefaults.standard.synchronize()
       
        //self.dismiss(animated: true, completion: nil)
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.CheckoutScreen.rawValue), object: self, userInfo: nil)
      
    }
    
    func menuAction(sender:UIBarButtonItem){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowSideMenu"), object: nil)
        
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func syncTapped(_ sender: Any) {
        self.syncButton.isEnabled = false
        //"&status=" + AssignmentStatus.Assigned.rawValue
        let queryStr = "&assignmentStartTime=" + ((Calendar.current.date(byAdding: .day, value: -15, to: Date()))?.formattedISO8601)!
        AssignmentModel.getAssignmentsForDesiredTime(query: queryStr) { (completionStatus) in
            UI {
                print("completionstatus = \(completionStatus)")
                if completionStatus == "Success" {
                    UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.LastAssignmentFetched.rawValue)
                }
                if AssignmentModel.statusOfUser() {
                    // Here i have to swipe down the user screen to stop mobitoring
                    self.statusChangeView.isHidden = false
                    self.syncButton.isEnabled = true
                   // if let screenFlag = UserDefaults.standard.value(forKeyPath: "AlreadyCheckin") as? String {
                       // if screenFlag == "1" {
                            UserDefaults.standard.set(false, forKey: UserDefaultsKeys.ManualSwipeDown.rawValue)
                            
                            UI {
                                UserDefaults.standard.set("2", forKey: "AlreadyCheckin")
                                // New change on 20/06/2018 to create one checkin
                                if isInternetAvailable(){
                                    CheckinModel.postCheckin()
                                }
                                bdCloudStopMonitoring()
                                
                              //  NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.CheckinScreen.rawValue), object: self, userInfo: ["check":true])
                                
                                //                                createLocalNotification(message: "Looks like you're out of office. Time to relax!")
                            }
                       // }
                    //}
                } else {
                    self.statusChangeView.isHidden = true
                    self.syncButton.isEnabled = false
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
            self.statusChangeView.isHidden = false
            self.syncButton.isEnabled = true
            self.syncButton.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        } else {
            self.statusChangeView.isHidden = true
            self.syncButton.isEnabled = false
            self.syncButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
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
