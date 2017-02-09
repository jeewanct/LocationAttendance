//
//  BottomBar.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 09/12/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation
import  UIKit

class TabView:UIView {
    var items: [String] = []
    var buttonImage:[String] = []
    var selectedButtonImage:[String] = []
    
    init(images:[String],selectedImage:[String]){
        self.items = images
        self.selectedButtonImage = selectedImage
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //self.items = []
        
        super.init(coder: aDecoder)
    }

    
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    func addButtons (forImage:[String],forselectImage:[String]){
        for (index, item) in forImage.enumerated() {
            let buttonView = button(forImage: item, atIndex: index)
            stackView.addArrangedSubview(buttonView)
        }
    }
    
    
    func button(forImage item: String, atIndex index: Int) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: item)
            , for: UIControlState.normal)
        button.setImage(UIImage(named: selectedButtonImage[index]) ,for: .selected)
        //button.addTarget(self, action: #selector(TabView.tapped(segmentButton:)), for: .touchUpInside)
        // TODO: Set button title text attributes to a dictionary property set by the developer
        button.tag = index
        return button
        
        
    }
    
    override func updateConstraints() {
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: widthAnchor),
            stackView.heightAnchor.constraint(equalTo: heightAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        
        super.updateConstraints()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        addSubview(stackView)
        
        addButtons(forImage:items,forselectImage:selectedButtonImage)
       
        self.layer.masksToBounds = false
        let shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 2)
        self.backgroundColor = UIColor.white
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1);
        self.layer.shadowOpacity = 0.3
        self.layer.shadowPath = shadowPath.cgPath
        
        
    }
    
//    func tapped(segmentButton sender: UIButton) {
//        let newIndex = sender.tag
//        let indexChanged: Bool = newIndex != selectedSegmentIndex
//        selectedSegmentIndex = newIndex
//        
//        if let indexChangedHandler = indexChangedHandler, indexChanged == true {
//            indexChangedHandler(selectedSegmentIndex)
//        }
//        
//        setSelectedSegmentIndex(newIndex, animated: true)
//    }
}



    
