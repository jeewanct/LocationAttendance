//
//  VirtualViewController.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 22/02/17.
//  Copyright © 2017 raremediacompany. All rights reserved.
//

import UIKit

class VirtualViewController: UIViewController {
   
    
    @IBOutlet weak var powerStepper: UIStepper!
   // @IBOutlet weak var powerSlider: UISlider!
    var major  = 65535
    @IBOutlet weak var powerLabel: UILabel!
    var powerValue = -10.0
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavView(controller: self, title: "Virtual")
//        powerStepper.value = -78.0
//        powerStepper.maximumValue = -10.0
//    
//        powerStepper.minimumValue = -127.0
//        powerStepper.isHidden = true
//        powerLabel.text = "Power(dBm) \(powerStepper.value)"
        // Do any additional setup after loading the view.
    }
    @IBAction func broadcastBeacon(_ sender: UIButton) {
//        if sender.isSelected{
//        
//            sender.setImage(#imageLiteral(resourceName: "submitted"), for: UIControlState.normal)
//        }else{
//            
//            IBeaconBroadcaster.sharedInstance.setBeacon(uuid: SDKSingleton.sharedInstance.userId, major: NSNumber(integerLiteral: major), minor: 65535, power:  NSNumber(floatLiteral: powerStepper.value))
//            print(IBeaconBroadcaster.sharedInstance.startBeacon())
//            sender.setImage(#imageLiteral(resourceName: "signature-placeholder"), for: UIControlState.normal)
//        
//
//        }
//        
//       sender.isSelected = !sender.isSelected
    
        IBeaconBroadcaster.sharedInstance.setBeacon(uuid: SDKSingleton.sharedInstance.userId, major: NSNumber(integerLiteral: major), minor: 65535, power:  NSNumber(floatLiteral: powerValue))
        print(IBeaconBroadcaster.sharedInstance.startBeacon())
        
        let delay = 1.0 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
        print(IBeaconBroadcaster.sharedInstance.stopBeacon())
        })
        
    }
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            major = 65535
        case 1:
            major = 65534
        case 2:
            major = 65533
        case 3:
            major = 65532
        default:
            major = 65535
        }
        
    }
    
    
//    @IBAction func power(_ sender: UISlider) {
//        powerLabel.text = "Power(dBm) \(sender.value)"
//        
//        
//    }

    @IBAction func power(_ sender: UIStepper) {
        
        powerLabel.text = "Power(dBm) \(sender.value)"
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
