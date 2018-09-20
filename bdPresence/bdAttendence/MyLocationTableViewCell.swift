//
//  MyLocationTableViewCell.swift
//  bdPresence
//
//  Created by Raghvendra on 13/07/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import UIKit

class MyLocationTableViewCell: UITableViewCell{
    @IBOutlet weak var visualEffect: UIVisualEffectView!
    
    @IBOutlet weak var effectView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        selectionStyle = .none
        effectView.applyGradient(isTopBottom: false, colorArray: [APPColor.BlueGradient,APPColor.GreenGradient])
        effectView.layer.masksToBounds = true
        
    }
}
