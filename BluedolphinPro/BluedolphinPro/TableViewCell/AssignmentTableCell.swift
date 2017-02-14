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
        
        if let assignmentdetail = task.assignmentDetails?.parseJSONString as? NSDictionary{
                        if let jobNumber = assignmentdetail["jobNumber"] as? String{
                jobNameLabel.text = jobNumber
            }

            
        }
        if let address = task.assignmentAddress{
            addressLabel.text = address.capitalized
        }

        
        if let startTime = task.assignmentStartTime {
            startTimeLabel.text = startTime.formatted
        }
        if let endtime = task.assignmentDeadline {
            startTimeLabel.text =   startTimeLabel.text! + " to " + endtime.formatted
        }
        bookMarkButton.setImage(#imageLiteral(resourceName: "inactive ribbon"), for: UIControlState.normal)
    }
    
}
