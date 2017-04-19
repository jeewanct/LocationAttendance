//
//  WelcomeViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 17/04/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit
import BluedolphinCloudSdk

class WelcomeViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBAction func checkinAction(_ sender: Any) {
        if BlueDolphinManager.manager.seanbeacons.count != 0 {
            BlueDolphinManager.manager.sendCheckins()
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "successView") as? CheckinSuccessViewController
            self.show(controller!, sender: nil)
        }else{
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "errorView") as? CheckinErrorViewController
            
            self.show(controller!, sender: nil)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        if isInternetAvailable() {
            BlueDolphinManager.manager.updateToken()
            BlueDolphinManager.manager.getNearByBeacons()
        }
       
        BlueDolphinManager.manager.startScanning()
        nameLabel.text  =  "Hi \(SDKSingleton.sharedInstance.userName.capitalized)"
        // Do any additional setup after loading the view.
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

}
