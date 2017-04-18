//
//  CustomButton.swift
//  bdAttendence
//
//  Created by Raghvendra on 17/04/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable
class FlatButton: UIButton  {
    
    @IBInspectable var cornerRadius: CGFloat = 5 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor = UIColor.blue{
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var buttonColor: UIColor = UIColor.blue{
        didSet {
       self.backgroundColor = buttonColor
        }
    }
    override init(frame: CGRect) {
        
        super.init(frame:frame)
        self.cornerRadius = 10
        self.buttonColor = UIColor.blue
        self.titleLabel?.textColor = UIColor.white
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}

@IBDesignable
class OvalButton: UIButton  {
    
    @IBInspectable var cornerRadius: CGFloat = 50 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor = UIColor.blue{
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var buttonColor: UIColor = UIColor.blue{
        didSet {
            self.backgroundColor = buttonColor
        }
    }
    override init(frame: CGRect) {
        
        super.init(frame:frame)
        self.cornerRadius = self.frame.width/2
        self.buttonColor = UIColor.blue
        self.titleLabel?.textColor = UIColor.white
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
