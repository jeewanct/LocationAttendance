//
//  WeekCollectionViewCell.swift
//  bdAttendence
//
//  Created by Raghvendra on 18/08/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit

class WeekCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellLabel: UILabel!

    @IBOutlet weak var dateLabel: UILabel!
    
    
    var highligtedBackgroundId = 1001
    var highlightedColour = UIColor.red
    func highlight() {
        dateLabel.textColor = UIColor.white
        insertSelectedBackground(highlightedColour, backgroundId: highligtedBackgroundId)
    }
    
    func unhighlight() {
        dateLabel.textColor = UIColor.black
        removeSelectedBackground(highligtedBackgroundId)
    }
    
    fileprivate func insertSelectedBackground(_ highlightColor: UIColor, backgroundId: Int) {
        if viewWithTag(backgroundId) == nil {
            print(self.frame)
            print(cellLabel.frame)
            print(dateLabel.frame)
            
            
            
            
            
            let selectionMarker = CircleView(frame: dateLabel.frame, fillColor: highlightColor)
            selectionMarker.tag = backgroundId;
            insertSubview(selectionMarker, at:0)
        }
    }
    
    fileprivate func removeSelectedBackground(_ backgroundId: Int) {
        viewWithTag(backgroundId)?.removeFromSuperview()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
