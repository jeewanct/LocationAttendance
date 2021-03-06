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
    let rmcNotifier = RMCNotifier.shared
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.isTranslucent = true
        navigationController?.removeTransparency()
        
        
       self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(menuAction(sender:)))
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
       // statusOfUser()
    }
    
    @IBAction func syncTapped(_ sender: Any) {
        activityIndicator = ActivityIndicatorView()
        
        self.view.showActivityIndicator(activityIndicator: activityIndicator!)
        let queryStr = "&assignmentStartTime=" + ((Calendar.current.date(byAdding: .day, value: -15, to: Date()))?.formattedISO8601)! +  AppConstants.AssignmentUrls.query
        
        AssignmentModel.getAssignmentsForDesiredTime(query: queryStr) { (completionStatus) in
            self.view.removeActivityIndicator(activityIndicator: self.activityIndicator!)
            UI {
                print("completionstatus = \(completionStatus)")
                if completionStatus == "Success" {
                    UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.LastAssignmentFetched.rawValue)
                }
                
                if AssignmentModel.statusOfUser() {
                    
                    bdCloudStopMonitoring()
                    //                    self.shiftSyncBarBtn.isEnabled = true
                    //                    self.shiftSyncBarBtn.tintColor = APPColor.BlueGradient
                    UserDefaults.standard.set("2", forKey: "AlreadyCheckin")
                    UI {
                        if isInternetAvailable(){
                            CheckinModel.postCheckin()
                        }
                        
                    }
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.Dashboard.rawValue), object: self, userInfo: nil)
                    
                } else {
                    
                    bdCloudStartMonitoring()
                    UserDefaults.standard.set("1", forKey: "AlreadyCheckin")
                    //                    self.shiftSyncBarBtn.isEnabled = false
                    //                    self.shiftSyncBarBtn.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    
                }
            }
        }
        
    }
    
    
    
    
   @objc func handleGesture(sender:UIGestureRecognizer){
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
    
   @objc func menuAction(sender:UIBarButtonItem){
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
