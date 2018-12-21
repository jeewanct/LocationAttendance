//
//  NewPermissionViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 03/07/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit
import CoreLocation
import BluedolphinCloudSdk

class NewPermissionViewController: UIViewController {
    
    
 //   @IBOutlet weak var currentSettingLabel: UILabel!
    @IBOutlet weak var detailMessageLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let attributedString1 = NSAttributedString(string: "Always enabling the location services ", attributes:  [NSFontAttributeName : APPFONT.PERMISSIONBODY!
//            , NSForegroundColorAttributeName : APPColor.blue])
//        let attributedString2 = NSAttributedString(string: "will ensure that we are able to accurately mark your presence at your workplace", attributes:  [NSFontAttributeName : APPFONT.PERMISSIONBODY!])
//        let combinedString = NSMutableAttributedString()
//        combinedString.append(attributedString1)
//        combinedString.append(NSAttributedString(string: "\n"))
//        combinedString.append(attributedString2)
//        self.detailMessageLabel.attributedText = combinedString
//        self.currentSettingLabel.numberOfLines = 0
//        self.currentSettingLabel.lineBreakMode = .byWordWrapping
//        self.currentSettingLabel.adjustsFontSizeToFitWidth = true
//        self.currentSettingLabel.font = APPFONT.PERMISSIONBODY
        NotificationCenter.default.addObserver(self, selector: #selector(NewPermissionViewController.checkPermissionStatus(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.Background.rawValue), object: nil)
        
        
        locationButton.addTarget(self, action: #selector(openAppSetting), for: .touchUpInside)
        
        checkLocationStatus()
        
        // Do any additional setup after loading the view.
    }
    func checkLocationStatus(){
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("")
              //  currentSettingLabel.text = "CURRENT LOCATION SETTING \n Never access location "
                
            case  .authorizedWhenInUse:
                print("")
               // currentSettingLabel.text = "CURRENT LOCATION SETTING  \n Allow access location while using the app "
                
            case .authorizedAlways:
                ProjectSingleton.sharedInstance.locationAvailable = true
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        updateLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   @objc func checkPermissionStatus(sender:NSNotification){
        checkLocationStatus()
        updateLayout()
    }
    
    func updateLayout(){
        if ProjectSingleton.sharedInstance.locationAvailable{
            locationButton.setImage(UIImage(named: "Permission_enabled"), for: .normal)
            locationButton.isUserInteractionEnabled = false
        }else{
            locationButton.isUserInteractionEnabled = true
            locationButton.setImage(UIImage(named: "Permission_disabled"), for: .normal)
        }
        //        if ProjectSingleton.sharedInstance.bluetoothAvaliable{
        //            bluetoothButton.isUserInteractionEnabled = false
        //            bluetoothButton.setImage(UIImage(named: "permission_bluetooth_enabled"), for: UIControlState.normal)
        //        }else{
        //            bluetoothButton.isUserInteractionEnabled = true
        //            bluetoothButton.setImage(UIImage(named: "permission_bluetooth_disabled"), for: UIControlState.normal)
        //        }
        if  ProjectSingleton.sharedInstance.locationAvailable{
            /*
             @Sourabh - Since we have done this allready on SuperViewController so removing it from here
            */
            //postGpsStateDataCheckin()
            self.dismiss(animated: true, completion: nil)
            
            
        }
    }
    
    func postGpsStateDataCheckin(){
        let checkin = CheckinHolder()
        
        checkin.checkinDetails = [AssignmentWork.AppVersion.rawValue:APPVERSION as AnyObject,AssignmentWork.UserAgent.rawValue:"ios" as AnyObject,CheckinDetailKeys.gpsStatus.rawValue:ProjectSingleton.sharedInstance.locationAvailable as AnyObject]
        checkin.checkinCategory = CheckinCategory.Data.rawValue
        checkin.checkinType = CheckinType.Data.rawValue
        //
        
        CheckinModel.createCheckin(checkinData: checkin)
        
        
        //Changes for location creation
        
        
        
        
        
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.RMCPlacesFetched.rawValue), object: nil, userInfo: nil)
        
        
        if isInternetAvailable(){
            CheckinModel.postCheckin()
        }
    }
    

   @objc func openAppSetting(){
    let settingsUrl = NSURL(string: UIApplication.openSettingsURLString)
        if let url = settingsUrl {
            UIApplication.shared.openURL(url as URL)
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

