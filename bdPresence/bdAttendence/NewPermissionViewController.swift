//
//  NewPermissionViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 03/07/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit
import CoreLocation

class NewPermissionViewController: UIViewController {


  
    @IBOutlet weak var detailMessageLabel: UILabel!
    
    
    
    @IBOutlet weak var locationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailMessageLabel.text = "Always enabling the location services will ensure that we are able to accurately mark your presence at your workplace"
        NotificationCenter.default.addObserver(self, selector: #selector(NewPermissionViewController.checkPermissionStatus(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.Background.rawValue), object: nil)
    
        
        locationButton.addTarget(self, action: #selector(openAppSetting), for: UIControlEvents.touchUpInside)
        
//        if CLLocationManager.locationServicesEnabled() {
//            switch(CLLocationManager.authorizationStatus()) {
//            case .notDetermined, .restricted, .denied:
//          currentSettingLabel.text = "CURRENT LOCATION SETTING Never access location "
//
//            case  .authorizedWhenInUse:
//               currentSettingLabel.text = "CURRENT LOCATION SETTING Allow access location while using the app "
//
//            case .authorizedAlways:
//                ProjectSingleton.sharedInstance.locationAvailable = true
//            }
//        }
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        updateLayout()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func checkPermissionStatus(sender:NSNotification){
        updateLayout()
    }
    
    func updateLayout(){
        if ProjectSingleton.sharedInstance.locationAvailable{
            locationButton.setImage(UIImage(named: "permission_location_enabled"), for: UIControlState.normal)
            locationButton.isUserInteractionEnabled = false
        }else{
            locationButton.isUserInteractionEnabled = true
            locationButton.setImage(UIImage(named: "permission_location_disabled"), for: UIControlState.normal)
        }
//        if ProjectSingleton.sharedInstance.bluetoothAvaliable{
//            bluetoothButton.isUserInteractionEnabled = false
//            bluetoothButton.setImage(UIImage(named: "permission_bluetooth_enabled"), for: UIControlState.normal)
//        }else{
//            bluetoothButton.isUserInteractionEnabled = true
//            bluetoothButton.setImage(UIImage(named: "permission_bluetooth_disabled"), for: UIControlState.normal)
//        }
        if  ProjectSingleton.sharedInstance.locationAvailable{
            self.dismiss(animated: true, completion: nil)
            
            
        }
    }
    
    func openBluetooth(){
        let url = URL(string: "App-Prefs:root=Bluetooth") //for bluetooth setting
        let app = UIApplication.shared
        app.openURL(url!)
    }
    func openAppSetting(){
        let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
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
