//
//  NewPermissionViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 03/07/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit

class NewPermissionViewController: UIViewController {

    @IBOutlet weak var bluetoothButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewPermissionViewController.checkPermissionStatus(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.Background.rawValue), object: nil)
        bluetoothButton.addTarget(self, action: #selector(openBluetooth), for: UIControlEvents.touchUpInside)
        locationButton.addTarget(self, action: #selector(openAppSetting), for: UIControlEvents.touchUpInside)
        
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
        if ProjectSingleton.sharedInstance.bluetoothAvaliable{
            bluetoothButton.isUserInteractionEnabled = false
            bluetoothButton.setImage(UIImage(named: "permission_bluetooth_enabled"), for: UIControlState.normal)
        }else{
            bluetoothButton.isUserInteractionEnabled = true
            bluetoothButton.setImage(UIImage(named: "permission_bluetooth_disabled"), for: UIControlState.normal)
        }
        if ProjectSingleton.sharedInstance.bluetoothAvaliable && ProjectSingleton.sharedInstance.locationAvailable{
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
