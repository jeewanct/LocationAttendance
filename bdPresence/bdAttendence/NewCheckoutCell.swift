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
    
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var geoTagButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var timeBottomConstraint: NSLayoutConstraint!
    
    var currentIndex: Int?
    var delegate: GeoTagLocationDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

        geoTagButton.titleLabel?.sizeToFit()
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//        addressLabel.addGestureRecognizer(tapGesture)
//        geoTagLabel.textColor = UIColor.white

    }
    
    @IBAction func handleGeoTag(_ sender: Any) {
        if let index = currentIndex{
            delegate?.handleTap(currentIndex: index)
        }
        
    }
    
    
    
    //    @objc func handleTap(){
    //
    //        if let index = currentIndex{
    //            delegate?.handleTap(currentIndex: index)
    //        }
    //    }
    
    
    
}
