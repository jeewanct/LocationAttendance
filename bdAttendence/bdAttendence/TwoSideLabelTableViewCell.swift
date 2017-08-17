//
//  TwoSideLabelTableViewCell.swift
//  bdAttendence
//
//  Created by Raghvendra on 16/08/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit

class TwoSideLabelTableViewCell: UITableViewCell {

    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
