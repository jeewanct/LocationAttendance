//
//  TabView.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 24/11/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import UIKit


class ViewPagerControl: UIControl {
    enum SelectionIndicatorPosition {
        case top
        case bottom
    }
    
    enum SelectionIndicatorWidthStyle {
        case dynamic // Selection indicator is equal to the segment's label width.
        case fixed // Selection indicator is equal to the full width of the segment.
    }
    enum ViewPagerType{
        case text
        case image
        case textImage
    }
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    lazy var selectionIndicator: UIView = {
        let selectionIndicator = UIView()
        selectionIndicator.backgroundColor = self.selectionIndicatorColor
        selectionIndicator.translatesAutoresizingMaskIntoConstraints = false
        return selectionIndicator
    }()
    
    var selectionIndicatorLeadingConstraint: NSLayoutConstraint?
    var selectionIndicatorWidthConstraint: NSLayoutConstraint?
    var items: [String] = []
    var buttonImage:[String] = []
    var selectedButtonImage:[String] = []
    var showSelectionIndication = true
    
    /// Height of the selection indicator stripe.
    var selectionIndicatorHeight: CGFloat = 5.0
    
    var selectionIndicatorWidthStyle: SelectionIndicatorWidthStyle = .fixed
    
    /// Position of the selection indicator stripe.
    var selectionIndicatorPosition: SelectionIndicatorPosition = .bottom
    
    var type:ViewPagerType = .text
    
    /// Color of the selection indicator stripe.
    var selectionIndicatorColor: UIColor = .black {
        didSet {
            self.selectionIndicator.backgroundColor = selectionIndicatorColor
        }
    }
    
    /// Text attributes to apply to labels of the unselected segments
    var titleTextAttributes: [String:AnyObject]? {
        didSet {
            if let titleTextAttributes = titleTextAttributes {
                set(titleAttributes: titleTextAttributes, forControlState: .normal)
            }
        }
    }
    
    /// Text attributes to apply to labels of the selected segments
    var selectedTitleTextAttributes: [String:AnyObject]? {
        didSet {
            if let selectedTitleTextAttributes = selectedTitleTextAttributes {
                set(titleAttributes: selectedTitleTextAttributes, forControlState: .selected)
            }
        }
    }
    
    var indexChangedHandler: ((_ index: Int) -> (Void))?
    fileprivate(set) var selectedSegmentIndex: Int = 0 {
        didSet {
            for button in stackView.arrangedSubviews {
                if let button = button as? UIButton {
                    button.isSelected = false
                }
            }
            
            let selectedButton = stackView.arrangedSubviews[selectedSegmentIndex] as! UIButton
            selectedButton.isSelected = true
        }
    }
    
    init(items: [String]) {
        self.items = items
        self.type = ViewPagerType.text
        
        super.init(frame: CGRect.zero)
    }
    
    init(images:[String],selectedImage:[String]){
        self.items = images
        self.selectedButtonImage = selectedImage
        self.type = ViewPagerType.text
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //self.items = []
        
        super.init(coder: aDecoder)
    }
    
    override func updateConstraints() {
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: widthAnchor),
            stackView.heightAnchor.constraint(equalTo: heightAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        
        
        let selectionIndicatorPositionConstraint: NSLayoutConstraint
        
        if selectionIndicatorPosition == .top {
            selectionIndicatorPositionConstraint = selectionIndicator.topAnchor.constraint(equalTo: stackView.topAnchor)
        } else {
            selectionIndicatorPositionConstraint = selectionIndicator.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        }
        
        if selectionIndicatorWidthStyle == .dynamic {
            let button = stackView.arrangedSubviews[selectedSegmentIndex] as? UIButton
            
            if let titleLabel = button?.titleLabel {
                selectionIndicatorLeadingConstraint = selectionIndicator.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
                selectionIndicatorWidthConstraint = selectionIndicator.widthAnchor.constraint(equalTo: titleLabel.widthAnchor)
            }
        } else {
            selectionIndicatorLeadingConstraint = selectionIndicator.leadingAnchor.constraint(equalTo: stackView.leadingAnchor)
            selectionIndicatorWidthConstraint = selectionIndicator.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0 / CGFloat(items.count))
        }
        
        NSLayoutConstraint.activate([
            selectionIndicatorWidthConstraint!,
            selectionIndicator.heightAnchor.constraint(equalToConstant: selectionIndicatorHeight),
            selectionIndicatorPositionConstraint,
            selectionIndicatorLeadingConstraint!
            ])
        
        super.updateConstraints()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        addSubview(stackView)
        if showSelectionIndication{
            addSubview(selectionIndicator)
        }
        
        bringSubview(toFront: selectionIndicator)
        switch type {
        case .text:
            addButtons(forItems: items)
            
        case .image:
            addButtons(forImage:items,forselectImage:selectedButtonImage)
        case .textImage:
            break
        }
        self.layer.masksToBounds = false
        let shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 2)
        self.backgroundColor = UIColor.white
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1);
        self.layer.shadowOpacity = 0.3
        self.layer.shadowPath = shadowPath.cgPath

        
    }
    
    func addButtons(forItems items: [String]) {
        for (index, item) in items.enumerated() {
            let buttonView = button(forItem: item, atIndex: index)
            stackView.addArrangedSubview(buttonView)
        }
    }
    
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
        button.addTarget(self, action: #selector(ViewPagerControl.tapped(segmentButton:)), for: .touchUpInside)
        // TODO: Set button title text attributes to a dictionary property set by the developer
        button.tag = index
        return button
        
        
    }
    
    
    
    func button(forItem item: String, atIndex index: Int) -> UIButton {
        let button = UIButton()
        button.setTitle(item, for: .normal)
        button.addTarget(self, action: #selector(ViewPagerControl.tapped(segmentButton:)), for: .touchUpInside)
        // TODO: Set button title text attributes to a dictionary property set by the developer
        
        if let titleTextAttributes = titleTextAttributes {
            let attributedTitle = NSAttributedString(string: item, attributes: titleTextAttributes)
            button.setAttributedTitle(attributedTitle, for: .normal)
        } else {
            button.setTitleColor(.black, for: .normal)
        }
        
        if let selectedTitleTextAttributes = selectedTitleTextAttributes {
            let attributedTitle = NSAttributedString(string: item, attributes: selectedTitleTextAttributes)
            button.setAttributedTitle(attributedTitle, for: .selected)
        }
        
        button.tag = index
        return button
    }
    
    func tapped(segmentButton sender: UIButton) {
        let newIndex = sender.tag
        //let indexChanged: Bool = newIndex != selectedSegmentIndex
        selectedSegmentIndex = newIndex
        
        if let indexChangedHandler = indexChangedHandler
            /*, indexChanged == true */{
            indexChangedHandler(selectedSegmentIndex)
        }
        
        setSelectedSegmentIndex(newIndex, animated: true)
    }
    
    func set(titleAttributes attributes: [String:AnyObject], forControlState state: UIControlState) {
        for button in stackView.arrangedSubviews {
            if let button = button as? UIButton, let title = button.title(for: state) {
                let attributedTitle = NSAttributedString(string: title, attributes: attributes)
                button.setAttributedTitle(attributedTitle, for: state)
            }
        }
    }
    
    open func setButtonImage(_ index: Int,image:UIImage){
        assert(index < items.count, "Attempting to set index to a segment that does not exist.")
        
        
        if  let button = stackView.arrangedSubviews[index] as? UIButton {
            button.setImage(image, for: UIControlState.selected)
        }
        
    }
    
    /**
     
     
     Changes the currently selected segment index.
     
     - parameter index: Index of the segment to select.
     - parameter animated: A boolean to specify whether the change should be animated or not
     */
    open func setSelectedSegmentIndex(_ index: Int, animated: Bool) {
        assert(index < items.count, "Attempting to set index to a segment that does not exist.")
        
        selectedSegmentIndex = index
        
        if selectionIndicatorWidthStyle == .dynamic {
            let button = stackView.arrangedSubviews[selectedSegmentIndex] as? UIButton
            
            if let titleLabel = button?.titleLabel {
                removeConstraints([selectionIndicatorWidthConstraint!, selectionIndicatorLeadingConstraint!])
                
                selectionIndicatorLeadingConstraint = selectionIndicator.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
                selectionIndicatorWidthConstraint = selectionIndicator.widthAnchor.constraint(equalTo: titleLabel.widthAnchor)
                
                NSLayoutConstraint.activate([selectionIndicatorWidthConstraint!, selectionIndicatorLeadingConstraint!])
            }
        } else {
            let segmentWidth = stackView.frame.size.width / CGFloat(items.count)
            selectionIndicatorLeadingConstraint?.constant = segmentWidth * CGFloat(index)
        }
        
        if animated {
            UIView.animate(withDuration: 0.25, animations: {
                self.layoutIfNeeded()
            })
        } else {
            self.layoutIfNeeded()
        }
    }
    
}

