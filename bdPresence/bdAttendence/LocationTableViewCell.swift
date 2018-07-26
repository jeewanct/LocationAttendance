//
//  LocationTableViewCell.swift
//  bdPresence
//
//  Created by Jeevan Tiwari on 25/07/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import UIKit


class LocationTableViewCell: UITableViewCell{
   
    @IBOutlet weak var visualEffect: UIVisualEffectView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        visualEffect.applyGradient(isTopBottom: false, colorArray: [APPColor.BlueGradient,APPColor.GreenGradient])
        visualEffect.layer.masksToBounds = true
        
    }
}
