//
//  SystemSettingsCell.swift
//  bdPresence
//
//  Created by Raghvendra on 13/07/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import UIKit



class SystemSettingsCell: UITableViewCell {
    
   
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var valueImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
