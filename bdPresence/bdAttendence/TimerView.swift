//
//  TimerView.swift
//  bdAttendence
//
//  Created by Raghvendra on 31/08/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit

class TimerView: UIView {

     let timeDuration = 10
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var timerView: UICircularProgressRingView!
    
     @IBOutlet weak var scanningLabel: UILabel!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func createView(){
        scanningLabel.text = "Scanning.."
        scanningLabel.font = APPFONT.BODYTEXT
        scanningLabel.numberOfLines = 0
        scanningLabel.textAlignment = .center
        self.cancelButton.layer.cornerRadius = 15.0
        self.cancelButton.applyGradient(isTopBottom: true, colorArray: [APPColor.BlueGradient,APPColor.GreenGradient])
        self.cancelButton.clipsToBounds = true
        self.cancelButton.titleLabel?.font = APPFONT.FOOTERBODY
        self.cancelButton.tintColor = UIColor.white
        self.cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: UIControlEvents.touchUpInside)
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
    }
    
    func cancelButtonAction() {
    
    }
    
    func moveToError(){
        
        
    }

}
