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

    @IBOutlet weak var cancelButton: UIButton!
    let timeDuration = 10
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var timerView: UICircularProgressRingView!
    
    let major = 65535
    let powerValue = -10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailLabel.text = "Connecting..."
        detailLabel.font = APPFONT.BODYTEXT
        detailLabel.numberOfLines = 0
        detailLabel.textAlignment = .center
        self.cancelButton.layer.cornerRadius = 15.0
        self.cancelButton.applyGradient(isTopBottom: true, colorArray: [APPColor.BlueGradient,APPColor.GreenGradient])
        self.cancelButton.clipsToBounds = true
        self.cancelButton.titleLabel?.font = APPFONT.FOOTERBODY
        self.cancelButton.tintColor = UIColor.white
        self.cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: UIControlEvents.touchUpInside)
            
           // UIBarButtonItem(image: UIImage(named:"menu"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(menuAction(sender:)))
        // Do any additional setup after loading the view.
    }

    
     func cancelButtonAction() {
         self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        transmitBeacon()
        
    }
    
    
    func transmitBeacon(){
        
        timerView.maxValue = CGFloat(timeDuration)
        timerView.innerRingColor = APPColor.newGreen
        timerView.shouldShowValueText = true
        timerView.showFloatingPoint = false
        timerView.font = APPFONT.DAYHOUR!
        timerView.valueIndicator = " secs"
        timerView.animationStyle = kCAMediaTimingFunctionLinear

        timerView.setProgress(value: CGFloat(timeDuration), animationDuration: TimeInterval(timeDuration)) {
            self.timerView.value = 0.0
            
            self.moveToError()
            
        }
        
        
        IBeaconBroadcaster.sharedInstance.setBeacon(uuid: SDKSingleton.sharedInstance.userId, major: NSNumber(integerLiteral: major), minor: 65535, power:  NSNumber(floatLiteral: powerValue))
        print(IBeaconBroadcaster.sharedInstance.startBeacon())
        
       
        let delay = Double(timeDuration) * Double(NSEC_PER_SEC)
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
