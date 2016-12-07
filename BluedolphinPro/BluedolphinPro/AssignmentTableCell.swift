//
//  AssignmentTableCell.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 07/12/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import UIKit

class AssignmentTableCell: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var jobNameLabel: UILabel!
    
    @IBOutlet weak var bookMarkButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureWithTask(_ task: RMCAssignmentObject) {
        print(task)
        
        if let assignmentdetail = task.assignmentDetails?.parseJSONString as? NSDictionary{
            if let address = assignmentdetail["address"] as? String{
                addressLabel.text = address
            }
            
        }
        if let startTime = task.time {
            startTimeLabel.text = startTime.asDate.formatted
        }
        if let endtime = task.assignmentDeadline {
            startTimeLabel.text =   startTimeLabel.text! + " to " + endtime.asDate.formatted
        }
        
    }
    
}
