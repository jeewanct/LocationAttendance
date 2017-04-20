//
//  CheckinErrorViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 18/04/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit
import BluedolphinCloudSdk

class CheckinErrorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    self.navigationController?.isNavigationBarHidden = true
     BlueDolphinManager.manager.startScanning()
        // Do any additional setup after loading the view.
    }

    @IBAction func checkinButton(_ sender: Any) {
        
        if BlueDolphinManager.manager.seanbeacons.count != 0 {
         self.sendCheckins()
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "successView") as? CheckinSuccessViewController
            self.show(controller!, sender: nil)
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
    func sendCheckins(){
        let checkin = CheckinHolder()
        
        checkin.checkinDetails = [AssignmentWork.AppVersion.rawValue:"1.0" as AnyObject,AssignmentWork.UserAgent.rawValue:"ios" as AnyObject, "status": "Checked-In" as AnyObject]
        checkin.checkinCategory = CheckinCategory.Data.rawValue
        checkin.checkinType = CheckinType.Data.rawValue
        //
        let checkinModelObject = CheckinModel()
        checkinModelObject.createCheckin(checkinData: checkin)
        if isInternetAvailable(){
            checkinModelObject.postCheckin()
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

}
