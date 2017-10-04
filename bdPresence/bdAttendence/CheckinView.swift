//
//  CheckinView.swift
//  bdAttendence
//
//  Created by Raghvendra on 11/07/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit
import BluedolphinCloudSdk

enum Screen:String{
    case Checkout
    case Checkin
    case Daycheckin
    case Timer
    case PayPal
}

protocol CheckinViewDelegate :class{
    
    func updateView(moveToView:Screen)
    
}

class CheckinView: UIView {

    @IBOutlet var customView: UIView!
  weak var delegate:CheckinViewDelegate?
    
    
    var nibName: String {
        return String(describing: type(of: self))
    }

    @IBOutlet weak var swipeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBAction func swipeAction(_ sender: Any) {
        delegate?.updateView(moveToView:.Timer)
    }
    
    
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
        customView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(customView)
    }
    
    
    func createView(name:String,quoteString:String,swipeString:String){
        quoteLabel.text = quoteString
        swipeLabel.text = swipeString
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.addGestureRecognizer(swipeUp)
        nameLabel.font = APPFONT.DAYHOUR
        nameLabel.text = "Hi " + name + ","
        quoteLabel.font = APPFONT.PERMISSIONBODY
        swipeLabel.font = APPFONT.FOOTERBODY
        
    }
    
    
    func handleGesture(sender:UIGestureRecognizer){
        
         delegate?.updateView(moveToView:.Timer)
//        BlueDolphinManager.manager.startScanning()
//        UserDefaults.standard.set("1", forKey: "AlreadyCheckin")
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.Dashboard.rawValue), object: self, userInfo: nil)
        //        let controller = self.storyboard?.instantiateViewController(withIdentifier: "newCheckout") as? UINavigationController
        //        self.present(controller!, animated: true, completion: nil)
        //self.show(controller!, sender: nil)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
