//
//  ContactTableViewCell.swift
//  bdAttendence
//
//  Created by Raghvendra on 11/08/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var contactImageView: UIImageView!
    
    @IBOutlet weak var contactButton: UILabel!
    //@IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //contactButton.titleLabel?.numberOfLines = 0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
