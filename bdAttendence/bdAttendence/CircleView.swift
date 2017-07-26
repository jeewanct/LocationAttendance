//
//  CircleView.swift
//  bdAttendence
//
//  Created by Raghvendra on 26/07/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit

class CircleView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    init(frame: CGRect, fillColor color: UIColor) {
        super.init(frame: frame)
        self.applyGradient(isTopBottom: true, colorArray: [APPColor.BlueGradient,APPColor.GreenGradient])
        self.clipsToBounds = true
        self.layer.cornerRadius = frame.height/2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   

}

