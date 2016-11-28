//
//  DropDownButton.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 25/11/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation
import UIKit

class DropDown {
    let picker = UIImageView(image: UIImage(named: "picker"))
    
    func createPicker(items:[String])
    {
        picker.frame = CGRect(x: 50, y: 64, width: 200, height: 100)
        picker.alpha = 0
        picker.isHidden = true
        picker.isUserInteractionEnabled = true
        
        var offset = 21
        
        for (index, feeling) in items.enumerated()
        {
            let button = UIButton()
            button.frame = CGRect(x: 13, y: offset, width: 200, height: 43)
            button.setTitle(feeling, for: UIControlState())
            button.tag = index
            
            picker.addSubview(button)
            
            offset += 44
        }
        
        currenViewController().view.addSubview(picker)
    }
    
    
    func openPicker()
    {
        self.picker.isHidden = false
        
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.picker.frame = CGRect(x: 50, y: 64, width: 200, height: 100)
                        self.picker.alpha = 1
        })
    }
    
    func closePicker()
    {
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.picker.frame = CGRect(x: 50, y: 64, width: 200, height: 100)
                        self.picker.alpha = 0
        },
                       completion: { finished in
                        self.picker.isHidden = true
        }
        )
    }
    
    
}
