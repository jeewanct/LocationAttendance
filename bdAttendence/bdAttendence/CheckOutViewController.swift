//
//  CheckOutViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 18/04/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit
import BluedolphinCloudSdk

class CheckOutViewController: UIViewController {

    @IBOutlet weak var lastCheckinLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressBar: UICircularProgressRingView!
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationController?.isNavigationBarHidden = true
        
        updateTask()
        // Do any additional setup after loading the view.
    }
    func updateTask(){
        if isInternetAvailable() {
            BlueDolphinManager.manager.updateToken()
            BlueDolphinManager.manager.getNearByBeacons()
        }
        
        BlueDolphinManager.manager.startScanning()
        
        self.lastCheckinLabel.text = "Your last check in \(currentTime())"
        self.welcomeLabel.text = "Hi \(SDKSingleton.sharedInstance.userName.capitalized) How's it going"
        progressBar.maxValue = 540
        let value = 220
        progressBar.setProgress(value: CGFloat(value), animationDuration: 5.0) {
            self.progressLabel.text = "\(value/60) hours"
        }
    }

    @IBAction func checkoutAction(_ sender: Any) {
        if BlueDolphinManager.manager.seanbeacons.count != 0{
            moveToWelcome()
            BlueDolphinManager.manager.sendCheckins()
            UserDefaults.standard.set("false", forKey: "AlreadyCheckin")
        }else{
            self.showAlert("Please make sure you are in office premises")
        }
        
    }
    
    func showAlert(_ message : String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (action) in
            return        }
        alertController.addAction(OkAction)
        self.present(alertController, animated: true) {
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func currentTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        return "\(hour):\(minutes)"
    }

    func moveToWelcome(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = storyboard.instantiateViewController(withIdentifier: "Main") as! UINavigationController
        if UIApplication.shared.keyWindow != nil {
           UIApplication.shared.keyWindow?.rootViewController = destVC
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
