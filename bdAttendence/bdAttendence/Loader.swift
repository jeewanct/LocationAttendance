//
//  Loader.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 01/12/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation
import UIKit

class AlertView: UIView {
    
    //MARK: Shared Instance
    
    static let sharedInstance: AlertView = AlertView()
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var label: UILabel = UILabel()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    /*
     Show customized activity indicator,
     actually add activity indicator to passing view
     
     @param uiView - add activity indicator to this view
     */
    func setLabelText(_ text:String){
        label.frame = CGRect(x: 50, y: 10, width: 200, height: 60)
        let pleaseWaitText = "Please wait"
        let attributedString = NSMutableAttributedString(string:"\(text)\n\(pleaseWaitText)")
        attributedString.addAttribute(NSFontAttributeName, value:  UIFont.systemFont(ofSize: 20), range:NSRange(location: 0, length:text.characters.count))
        
        label.attributedText = attributedString
        label.numberOfLines = 3
        label.textColor = UIColor.white
        //label.backgroundColor = UIColor.brownColor()
    }
    func showActivityIndicator(_ uiView: UIView) {
        //AlertView().showActivityIndicator(self.view)
        
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        //UIColorFromHex(0xd3d3d3, alpha: 0.1)
        
        loadingView.frame = CGRect(x: 0, y: 0, width: container.frame.size.width-100, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        
        
        activityIndicator.frame = CGRect(x: 0.0, y: 20.0, width: 40.0, height: 40.0);
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        //activityIndicator.center = CGPointMake(loadingView.frame.size.width / 2, (loadingView.frame.size.height / 2) - 40);
        
        loadingView.addSubview(label)
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
         uiView.addSubview(container)
        container.tag = 1000000
        activityIndicator.startAnimating()
        container.tag = 10000;
    }
    
    /*
     Hide activity indicator
     Actually remove activity indicator from its super view
     
     @param uiView - remove activity indicator from this view
     */
    func hideActivityIndicator(_ uiView: UIView) {
        
        
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            if let viewWithTag = uiView.viewWithTag(10000) {
                viewWithTag.removeFromSuperview()
            }
            self.label .removeFromSuperview()
            self.loadingView .removeFromSuperview()
            self.container.removeFromSuperview()
        };
    }
    
    /*
     Define UIColor from hex value
     
     @param rgbValue - hex color value
     @param alpha - transparency level
     */
    func UIColorFromHex(_ rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    
}
