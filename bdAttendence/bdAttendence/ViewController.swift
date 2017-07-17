//
//  ViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 17/04/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit
import BluedolphinCloudSdk


class ViewController: UIViewController {
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    let major = 65535
    let powerValue = -10.0
    override func viewDidLoad() {
        super.viewDidLoad()
        label.center = self.view.center
        self.view.addSubview(label)
        label.text = "Transmitting"
        
        IBeaconBroadcaster.sharedInstance.setBeacon(uuid: SDKSingleton.sharedInstance.userId, major: NSNumber(integerLiteral: major), minor: 65535, power:  NSNumber(floatLiteral: powerValue))
        print(IBeaconBroadcaster.sharedInstance.startBeacon())
//        AlertView.sharedInstance.setLabelText("Transmitting")
//        AlertView.sharedInstance.showActivityIndicator(self.view)
        let delay = 30.0 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            print(IBeaconBroadcaster.sharedInstance.stopBeacon())
            self.label.text = "We have marked your attendance."
//            AlertView.sharedInstance.hideActivityIndicator(self.view)
        })
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

