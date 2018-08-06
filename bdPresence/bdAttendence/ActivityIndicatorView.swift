//
//  ActivityIndicatorView.swift
//  NewMontCalm
//
//  Created by Jeevan chandra on 05/12/17.
//  Copyright © 2017 Jeevan chandra. All rights reserved.
//

import UIKit


class ActivityIndicatorView: UIView {
    
    var cardViewHeight: NSLayoutConstraint?
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addViews()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func draw(_ rect: CGRect) {
        cardViewHeight?.constant = 48 + activityIndicator.frame.height + loadingLabel.frame.height
        animateCardView()
    }
    
    func animateCardView(){
        
        cardView.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)
        UIView.animate(withDuration: 0.9, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseIn, animations: {
            self.cardView.transform = .identity
        }, completion: nil)
    }
    
    func close(){
        
        UIView.animate(withDuration: 0.9, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseIn, animations: {
            self.cardView.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)
        }, completion:{ (value) in
            self.activityIndicator.stopAnimating()
            self.removeFromSuperview()
        })
        
        
    }
    
    func addViews(){
        
        // cardView.backgroundColor = Constants.Appearance.SECONDARYCOLOR
        addSubview(cardView)
        cardView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        cardView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        cardViewHeight = cardView.heightAnchor.constraint(equalToConstant: 50)
        cardViewHeight?.isActive = true
        cardView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.35).isActive = true
        
        
        cardView.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        activityIndicator.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16).isActive = true
        
        cardView.addSubview(loadingLabel)
        
        loadingLabel.leftAnchor.constraint(equalTo: cardView.leftAnchor, constant: 16).isActive = true
        loadingLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16).isActive = true
        loadingLabel.rightAnchor.constraint(equalTo: cardView.rightAnchor, constant: -16).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView()
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.activityIndicatorViewStyle = .whiteLarge
        activityView.color =  #colorLiteral(red: 0.4235294118, green: 0.7294117647, blue: 0.8156862745, alpha: 1)
        activityView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        return activityView
    }()
    
    let loadingLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.1
        lbl.text = "Loading..."
        lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        return lbl
    }()
    let cardView: ActivityCardView = {
        let cv = ActivityCardView()
        cv.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    
}


extension UIView{
    func showActivityIndicator(activityIndicator: ActivityIndicatorView){
        
        if let window = UIApplication.shared.keyWindow{
            activityIndicator.activityIndicator.startAnimating()
            window.addSubview(activityIndicator)
            
            activityIndicator.topAnchor.constraint(equalTo: window.topAnchor).isActive = true
             activityIndicator.leftAnchor.constraint(equalTo: window.leftAnchor).isActive = true
             activityIndicator.rightAnchor.constraint(equalTo: window.rightAnchor).isActive = true
             activityIndicator.bottomAnchor.constraint(equalTo: window.bottomAnchor).isActive = true
            
        }
    }
    
    func removeActivityIndicator(activityIndicator: ActivityIndicatorView){
        activityIndicator.close()
    }
    
}



//
//  CardView.swift
//  CameraApp
//
//  Created by JEEVAN TIWARI on 08/04/18.
//  Copyright © 2018 JEEVAN TIWARI. All rights reserved.
//

import UIKit

@IBDesignable
class ActivityCardView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 10
    
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 0
    @IBInspectable var shadowColor: UIColor? = UIColor.gray
    @IBInspectable var shadowOpacity: Float = 0.5
    
    override func layoutSubviews() {
        
        // backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
    
}



