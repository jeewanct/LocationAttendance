//
//  ErrorCheckinView.swift
//  bdAttendence
//
//  Created by Raghvendra on 17/04/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit

class ErrorCheckinView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        
        super.init(frame:frame)
        self.backgroundColor = UIColor.white
        let yaxis = 100
        let errorButton = OvalButton(frame: CGRect(x: 100, y: yaxis, width: 100, height: 100))
        errorButton.setTitle("Oops", for: UIControlState.normal)
        errorButton.buttonColor = UIColor.red
        //errorButton.center = self.center
        addSubview(errorButton)
        let errorLabel = UILabel(frame: CGRect(x: 100, y: yaxis + 100 + 50, width: 200, height: 30))
        errorLabel.text = "You are not in office premisis"
        addSubview(errorLabel)
        let checkinButton = FlatButton(frame: CGRect(x: 100, y: yaxis + 100 + 50 + 30 + 30, width: 100, height: 30))
        checkinButton.setTitle("Check-in", for: UIControlState.normal)
         checkinButton.buttonColor = UIColor.blue
        addSubview(checkinButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
