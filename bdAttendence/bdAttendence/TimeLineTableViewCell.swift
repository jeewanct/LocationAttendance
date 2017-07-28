//
//  TimeLineTableViewCell.swift
//  bdAttendence
//
//  Created by Raghvendra on 27/07/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit

class TimeLineTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var numberOfBeaconLabel: UILabel!
    @IBOutlet weak var topLineView: UIView!
    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var beaconLabel: UILabel!
    @IBOutlet weak var cardView: CardView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
