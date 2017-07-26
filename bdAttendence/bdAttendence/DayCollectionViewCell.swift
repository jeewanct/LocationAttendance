//
//  DayCollectionViewCell.swift
//  bdAttendence
//
//  Created by Raghvendra on 25/07/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {
    var highligtedBackgroundId = 1001
    var highlightedColour = UIColor.red
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cellLabel: UILabel!
    
    
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
            let selectionMarker = CircleView(frame: dateLabel.frame, fillColor: highlightColor)
            selectionMarker.tag = backgroundId;
            insertSubview(selectionMarker, at:0)
        }
    }
    
    fileprivate func removeSelectedBackground(_ backgroundId: Int) {
        viewWithTag(backgroundId)?.removeFromSuperview()
    }
}
