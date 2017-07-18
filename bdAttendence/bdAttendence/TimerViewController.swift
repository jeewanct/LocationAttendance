//
//  TimerViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 17/07/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit
import BluedolphinCloudSdk

class TimerViewController: UIViewController {

    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var timerView: UICircularProgressRingView!
    
    let major = 65535
    let powerValue = -10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailLabel.text = "Your device can now be discovered by receivers"
        detailLabel.font = APPFONT.BODYTEXT
        detailLabel.numberOfLines = 0
        detailLabel.textAlignment = .center
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        transmitBeacon()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
       
        
        
    }
    
    func transmitBeacon(){
        
        timerView.maxValue = 30.0
        timerView.innerRingColor = APPColor.newGreen
        timerView.shouldShowValueText = true
        timerView.showFloatingPoint = false
        timerView.font = APPFONT.DAYHOUR!
        timerView.valueIndicator = " secs"
        timerView.animationStyle = kCAMediaTimingFunctionLinear

        timerView.setProgress(value: CGFloat(30), animationDuration: 30.0) {
            self.timerView.value = 0.0
            
            self.moveToError()
            
        }
        
        
        IBeaconBroadcaster.sharedInstance.setBeacon(uuid: SDKSingleton.sharedInstance.userId, major: NSNumber(integerLiteral: major), minor: 65535, power:  NSNumber(floatLiteral: powerValue))
        print(IBeaconBroadcaster.sharedInstance.startBeacon())
        
       
        let delay = 30.0 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            print(IBeaconBroadcaster.sharedInstance.stopBeacon())
           
            
        })

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func moveToError(){
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "errorView") as? ErrorViewController
        self.present(controller!, animated: true, completion: nil)
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
