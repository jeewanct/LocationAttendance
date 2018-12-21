//
//  ErrorScanView.swift
//  bdAttendence
//
//  Created by Raghvendra on 31/08/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit

class ErrorScanView: UIView {

    @IBOutlet weak var tryLater: UIButton!
    @IBOutlet var customView: UIView!
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    weak var delegate:CheckinViewDelegate?
    var nibName: String {
        return String(describing: type(of: self))
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    func xibSetup() {
        customView = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?[0]  as! UIView
        
        // use bounds not frame or it'll be offset
        customView.frame = bounds
        
        // Make the view stretch with containing view
        customView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(customView)
    }
    
    
    func createView(){
        errorMessageLabel.text = "No Beacons could be detected around you . You can try scanning again"
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.lineBreakMode = .byWordWrapping
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.font = APPFONT.FOOTERBODY
        self.tryAgainButton.layer.cornerRadius = 15.0
        self.tryAgainButton.applyGradient(isTopBottom: true, colorArray: [APPColor.BlueGradient,APPColor.GreenGradient])
        self.tryAgainButton.clipsToBounds = true
        self.tryAgainButton.titleLabel?.font = APPFONT.FOOTERBODY
        self.tryAgainButton.tintColor = UIColor.white
        tryAgainButton.addTarget(self, action: #selector(scanAgain), for: .touchUpInside)
        self.tryLater.layer.cornerRadius = 15.0
        self.tryLater.applyGradient(isTopBottom: true, colorArray: [APPColor.BlueGradient,APPColor.GreenGradient])
        self.tryLater.clipsToBounds = true
        self.tryLater.titleLabel?.font = APPFONT.FOOTERBODY
        self.tryLater.tintColor = UIColor.white
        tryLater.addTarget(self, action: #selector(tryLaterAction), for: .touchUpInside)
        
    }
    
    
  @objc  func scanAgain(){
        
        delegate?.updateView(moveToView: .Timer)
        
        
    }
  @objc  func tryLaterAction(){
        delegate?.updateView(moveToView: .Checkin)
        
        
    }

}
