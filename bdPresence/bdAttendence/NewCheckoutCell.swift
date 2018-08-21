//
//  NewCheckoutCell.swift
//  bdPresence
//
//  Created by Jeevan Tiwari on 25/07/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import UIKit


class NewCheckoutCell: UITableViewCell{
    
    @IBOutlet weak var locationDetailLabel: UILabel!
    @IBOutlet weak var geoTagLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var currentIndex: Int?
    var delegate: GeoTagLocationDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addressLabel.addGestureRecognizer(tapGesture)
      //  geoTagLabel.textColor = UIColor.white
    }
    
    @objc func handleTap(){
        
        if let index = currentIndex{
            delegate?.handleTap(currentIndex: index)
        }
    }
    
  
    
}
