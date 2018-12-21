//
//  NoShiftByManager.swift
//  bdPresence
//
//  Created by Jeevan Tiwari on 10/09/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import UIKit
import BluedolphinCloudSdk
class NoShiftByMananger: UIViewController{
    
    
    @IBOutlet weak var syncBarBtn: UIBarButtonItem!
//        {
//        didSet {
//            let icon = #imageLiteral(resourceName: "sync")
//            let iconSize = CGRect(origin: .zero, size: icon.size)
//            let iconButton = UIButton(frame: iconSize)
//            iconButton.setBackgroundImage(icon, for: .normal)
//            syncBarBtn.customView = iconButton
//            iconButton.addTarget(self, action: #selector(handleSync(_:)), for: .touchUpInside)
//        }
//    }
    
    
    @IBOutlet weak var todayDateLbl: UILabel!
    @IBOutlet weak var bottomLbl: UILabel!
    @IBOutlet weak var unavailableTillLbl: UILabel!
    
    var activityIndicator: ActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setData()
    }
    
    func setData(){
        self.todayDateLbl.text = Date().formattedWith(format: "MMM dd, yyyy")
        self.unavailableTillLbl.text = "Unavailable till \((SDKSingleton.sharedInstance.toTimeStampForStatusChange?.formattedWith(format: "MMM dd, yyyy hh:mm a"))!)"
        self.syncBarBtn.isEnabled = true
        self.syncBarBtn.tintColor = APPColor.BlueGradient
    }
    
    @IBAction func handleSync(_ sender: Any) {
        
        //animateSyncBtn()
        activityIndicator = ActivityIndicatorView()
        self.view.showActivityIndicator(activityIndicator: activityIndicator)
        let queryStr = "&assignmentStartTime=" + ((Calendar.current.date(byAdding: .day, value: -15, to: Date()))?.formattedISO8601)!

        AssignmentModel.getAssignmentsForDesiredTime(query: queryStr) { (completionStatus) in
            self.view.removeActivityIndicator(activityIndicator: self.activityIndicator)
            UI {
                print("completionstatus = \(completionStatus)")
                if completionStatus == "Success" {
                    UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.LastAssignmentFetched.rawValue)
                }

                if AssignmentModel.statusOfUser() {
                    self.syncBarBtn.isEnabled = true
                    self.syncBarBtn.tintColor = APPColor.BlueGradient
                    UserDefaults.standard.set("2", forKey: "AlreadyCheckin")
                    UI {
                        if isInternetAvailable(){
                            CheckinModel.postCheckin()
                        }
                        bdCloudStopMonitoring()
                    }
                } else {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.Dashboard.rawValue), object: self, userInfo: nil)
                    bdCloudStartMonitoring()
                    UserDefaults.standard.set("1", forKey: "AlreadyCheckin")
                    self.syncBarBtn.isEnabled = false
                    self.syncBarBtn.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
               
                }
            }
        }
    
    }
    
    func animateSyncBtn(){
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: {
            
            self.syncBarBtn.customView?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 0.5))
            
        }) { (value) in
            
           // self.syncBarBtn.customView?.transform = .identity
            
            self.animateSyncBtn()
            
        }
    
    }
    
    
}

extension NoShiftByMananger{
    
    func setupNavigation(){
        navigationController?.removeTransparency()
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: APPFONT.DAYHEADER!]
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(menuAction(sender:)))
    }
    
   @objc func menuAction(sender:UIBarButtonItem){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowSideMenu"), object: nil)
        
    }
}
