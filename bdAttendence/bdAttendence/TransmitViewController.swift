//
//  TransmitViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 10/07/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit
import BluedolphinCloudSdk
let quoteString = "The only way to do great work is to love what you do"
let swipeUpStartString = "Swipe up to start your day"
class TransmitViewController: UIViewController,CheckinViewDelegate {
    
   
    let major = 65535
    let powerValue = -10.0
    var checkinView :CheckinView!
    @IBAction func transmitAction(_ sender: Any) {
        //transmitAsBeacon()
        
    }
    
    
    func transmitAsBeacon(){
//        IBeaconBroadcaster.sharedInstance.setBeacon(uuid: SDKSingleton.sharedInstance.userId, major: NSNumber(integerLiteral: major), minor: 65535, power:  NSNumber(floatLiteral: powerValue))
//        print(IBeaconBroadcaster.sharedInstance.startBeacon())
//        AlertView.sharedInstance.setLabelText("Transmitting")
//        AlertView.sharedInstance.showActivityIndicator(self.view)
//        let delay = 30.0 * Double(NSEC_PER_SEC)
//        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
//        DispatchQueue.main.asyncAfter(deadline: time, execute: {
//            print(IBeaconBroadcaster.sharedInstance.stopBeacon())
//            AlertView.sharedInstance.hideActivityIndicator(self.view)
//        })
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "testView") as? TimerViewController
       self.present(controller!, animated: true, completion: nil)
        //self.navigationController?.show(controller!, sender: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(menuAction(sender:)))
        
        checkinView = CheckinView(frame: self.view.frame)
        self.view.addSubview(checkinView)
        checkinView.createView(name: SDKSingleton.sharedInstance.userName, quoteString: quoteString, swipeString: swipeUpStartString)
        checkinView.delegate = self
        
        // Do any additional setup after loading the view.
    }

    func menuAction(sender:UIBarButtonItem){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowSideMenu"), object: nil)
        
    }
    
    
    

    func updateView(moveToView:Screen){
        print("hello")
        switch moveToView {
        case .Timer:
            transmitAsBeacon()
        default:
            break
       
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
