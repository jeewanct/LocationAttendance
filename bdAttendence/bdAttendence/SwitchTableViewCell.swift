//
//  SwitchTableViewCell.swift
//  bdAttendence
//
//  Created by Raghvendra on 16/08/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var switchLabel: UISwitch!
    @IBOutlet weak var headerLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
