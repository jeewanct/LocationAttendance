//
//  SSRadioButton.swift
//  SampleProject
//
//  Created by Shamas on 18/05/2015.
//  Copyright (c) 2015 Al Shamas Tufail. All rights reserved.
//

import Foundation
import UIKit
//
//
//@IBDesignable
//public class SSRadioButton: UIButton {
//    // MARK: Circle properties
//    internal var circleLayer = CAShapeLayer()
//    internal var fillCircleLayer = CAShapeLayer()
//    
//    @IBInspectable public var circleColor: UIColor = UIColor.red {
//        didSet {
//            circleLayer.strokeColor = circleColor.cgColor
//        }
//    }
//    @IBInspectable public var fillCircleColor: UIColor = UIColor.green {
//        didSet {
//            loadFillCircleState()
//        }
//    }
//    
//    @IBInspectable public var circleLineWidth: CGFloat = 2.0 {
//        didSet {
//            layoutCircleLayers()
//        }
//    }
//    @IBInspectable public var fillCircleGap: CGFloat = 2.0 {
//        didSet {
//            layoutCircleLayers()
//        }
//    }
//    
//    internal var circleRadius: CGFloat {
//        let width = bounds.width
//        let height = bounds.height
//        
//        let length = width > height ? height : width
//        return (length - circleLineWidth) / 2
//    }
//    
//    private var circleFrame: CGRect {
//        let width = bounds.width
//        let height = bounds.height
//        
//        let radius = circleRadius
//        let x: CGFloat
//        let y: CGFloat
//        
//        if width > height {
//            y = circleLineWidth / 2
//            x = (width / 2) - radius
//        } else {
//            x = circleLineWidth / 2
//            y = (height / 2) - radius
//        }
//        
//        let diameter = 2 * radius
//        return CGRect(x: x, y: y, width: diameter, height: diameter)
//    }
//    
//    private var circlePath: UIBezierPath {
//        return UIBezierPath(ovalIn: circleFrame)
//    }
//    
//    private var fillCirclePath: UIBezierPath {
//        let trueGap = fillCircleGap + (circleLineWidth / 2)
//        return UIBezierPath(ovalIn: circleFrame.insetBy(dx: trueGap, dy: trueGap))
//    }
//    
//    // MARK: Initialization
//    required public init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        customInitialization()
//    }
//    
//    override public init(frame: CGRect) {
//        super.init(frame: frame)
//        customInitialization()
//    }
//    
//    private func customInitialization() {
//        circleLayer.frame = bounds
//        circleLayer.lineWidth = circleLineWidth
//        circleLayer.fillColor = UIColor.clear.cgColor
//        circleLayer.strokeColor = circleColor.cgColor
//        layer.addSublayer(circleLayer)
//        
//        fillCircleLayer.frame = bounds
//        fillCircleLayer.lineWidth = circleLineWidth
//        fillCircleLayer.fillColor = UIColor.clear.cgColor
//        fillCircleLayer.strokeColor = UIColor.clear.cgColor
//        layer.addSublayer(fillCircleLayer)
//        
//        loadFillCircleState()
//    }
//    
//    // MARK: Layout
//    override public func layoutSubviews() {
//        super.layoutSubviews()
//        
//        layoutCircleLayers()
//    }
//    
//    private func layoutCircleLayers() {
//        circleLayer.frame = bounds
//        circleLayer.lineWidth = circleLineWidth
//        circleLayer.path = circlePath.cgPath
//        
//        fillCircleLayer.frame = bounds
//        fillCircleLayer.lineWidth = circleLineWidth
//        fillCircleLayer.path = fillCirclePath.cgPath
//    }
//    
//    // MARK: Selection
//    override public var isSelected: Bool {
//        didSet {
//            loadFillCircleState()
//        }
//    }
//    
//    // MARK: Custom
//    private func loadFillCircleState() {
//        if self.isSelected {
//            fillCircleLayer.fillColor = fillCircleColor.cgColor
//        } else {
//            fillCircleLayer.fillColor = UIColor.clear.cgColor
//        }
//    }
//    
//    // MARK: Interface builder
//    override public func prepareForInterfaceBuilder() {
//        customInitialization()
//    }
//}
@IBDesignable
class SSRadioButton: UIButton {

    fileprivate var circleLayer = CAShapeLayer()
    fileprivate var fillCircleLayer = CAShapeLayer()
    override var isSelected: Bool {
        didSet {
            toggleButon()
        }
    }
    /**
        Color of the radio button circle. Default value is UIColor red.
    */
    @IBInspectable var circleColor: UIColor = UIColor.red {
        didSet {
            circleLayer.strokeColor = circleColor.cgColor
            self.toggleButon()
        }
    }
    /**
        Radius of RadioButton circle.
    */
    @IBInspectable var circleRadius: CGFloat = 5.0
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    fileprivate func circleFrame() -> CGRect {
        var circleFrame = CGRect(x: 0, y: 0, width: 2*circleRadius, height: 2*circleRadius)
        circleFrame.origin.x = 0 + circleLayer.lineWidth
        circleFrame.origin.y = bounds.height/2 - circleFrame.height/2
        return circleFrame
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    fileprivate func initialize() {
        circleLayer.frame = bounds
        circleLayer.lineWidth = 2
        circleLayer.fillColor = UIColor.clear.cgColor
        //circleLayer.strokeColor = circleColor.cgColor
        layer.addSublayer(circleLayer)
        fillCircleLayer.frame = bounds
        fillCircleLayer.lineWidth = 2
        fillCircleLayer.fillColor = UIColor.clear.cgColor
        //fillCircleLayer.strokeColor = UIColor.clear.cgColor
        layer.addSublayer(fillCircleLayer)
        self.titleEdgeInsets = UIEdgeInsetsMake(0, (4*circleRadius + 4*circleLayer.lineWidth), 0, 0)
        self.toggleButon()
    }
    /**
        Toggles selected state of the button.
    */
    func toggleButon() {
        if self.isSelected {
          
            fillCircleLayer.fillColor = circleColor.cgColor
        } else {
            fillCircleLayer.fillColor = UIColor.clear.cgColor
        }
    }

    fileprivate func circlePath() -> UIBezierPath {
        return UIBezierPath(ovalIn: circleFrame())
    }

    fileprivate func fillCirclePath() -> UIBezierPath {
        return UIBezierPath(ovalIn: circleFrame().insetBy(dx: 2, dy: 2))
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        circleLayer.frame = bounds
        circleLayer.path = circlePath().cgPath
        fillCircleLayer.frame = bounds
         fillCircleLayer.path = fillCirclePath().cgPath
        self.titleEdgeInsets = UIEdgeInsetsMake(0, (2*circleRadius + 4*circleLayer.lineWidth), 0, 0)
    }

    override func prepareForInterfaceBuilder() {
        initialize()
    }
}
