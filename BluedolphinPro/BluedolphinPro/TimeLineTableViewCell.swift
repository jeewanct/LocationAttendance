//
//  TimeLineTableViewCell.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 30/11/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import UIKit

class TimeLineTableViewCell: UITableViewCell {

    @IBOutlet weak var taskTimeLabel: UILabel!
    @IBOutlet weak var taskImageView: UIImageView!
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var downLineView: UIView!
    @IBOutlet weak var upLineView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        taskImageView.layer.cornerRadius = 25
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
