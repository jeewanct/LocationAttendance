//
//  ProgressBar.swift
//  bdAttendence
//
//  Created by Raghvendra on 18/04/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import Foundation
import UIKit

public protocol UICircularProgressRingDelegate: class {
    /**
     Delegate call back, called when progress ring is done animating for current value
     
     - Parameter ring: The ring which finished animating
     
     */
    func finishedUpdatingProgress(forRing ring: UICircularProgressRingView)
}
private extension CGFloat {
    var toRads: CGFloat { return self * CGFloat.pi / 180 }
}

/**
 A private extension to UILabel, in order to cut down on code repeation.
 This function will update the value of the progress label, depending on the
 parameters sent.
 At the end sizeToFit() is called in order to ensure text gets drawn correctly
 */
private extension UILabel {
    func update(withValue value: CGFloat, valueIndicator: String, showsDecimal: Bool, decimalPlaces: Int) {
        if showsDecimal {
            self.text = String(format: "%.\(decimalPlaces)f", value) + "\(valueIndicator)"
        } else {
            self.text = "\(Int(value))\(valueIndicator)"
        }
        self.sizeToFit()
    }
}

/**
 The internal subclass for CAShapeLayer.
 This is the class that handles all the drawing and animation.
 This class is not interacted with, instead properties are set in UICircularProgressRingView
 and those are delegated to here.
 
 */
class UICircularProgressRingLayer: CAShapeLayer {
    
    // MARK: Properties
    
    /**
     The NSManaged properties for the layer.
     These properties are initialized in UICircularProgressRingView.
     They're also assigned by mutating UICircularProgressRingView.
     */
    @NSManaged var fullCircle: Bool
    
    @NSManaged var value: CGFloat
    @NSManaged var maxValue: CGFloat
    
    @NSManaged var viewStyle: Int
    @NSManaged var patternForDashes: [CGFloat]
    
    @NSManaged var startAngle: CGFloat
    @NSManaged var endAngle: CGFloat
    
    @NSManaged var outerRingWidth: CGFloat
    @NSManaged var outerRingColor: UIColor
    @NSManaged var outerCapStyle: CGLineCap
    
    @NSManaged var innerRingWidth: CGFloat
    @NSManaged var innerRingColor: UIColor
    @NSManaged var innerCapStyle: CGLineCap
    @NSManaged var innerRingSpacing: CGFloat
    
    @NSManaged var shouldShowValueText: Bool
    @NSManaged var fontColor: UIColor
    @NSManaged var font: UIFont
    @NSManaged var valueIndicator: String
    @NSManaged var showFloatingPoint: Bool
    @NSManaged var decimalPlaces: Int
    
    var animationDuration: TimeInterval = 1.0
    var animationStyle: String = CAMediaTimingFunctionName.easeInEaseOut.rawValue
    var animated = false
    
    // The value label which draws the text for the current value
    lazy private var valueLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    // MARK: Draw
    
    /**
     Overriden for custom drawing.
     Draws the outer ring, inner ring and value label.
     */
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        UIGraphicsPushContext(ctx)
        // Draw the rings
        drawOuterRing()
        drawInnerRing()
        // Draw the label
        drawValueLabel()
        UIGraphicsPopContext()
    }
    
    // MARK: Animation methods
    
    /**
     Watches for changes in the value property, and setNeedsDisplay accordingly
     */
    override class func needsDisplay(forKey key: String) -> Bool {
        if key == "value" {
            return true
        }
        
        return super.needsDisplay(forKey: key)
    }
    
    /**
     Creates animation when value property is changed
     */
    override func action(forKey event: String) -> CAAction? {
        if event == "value" && self.animated {
            let animation = CABasicAnimation(keyPath: "value")
            animation.fromValue = self.presentation()?.value(forKey: "value")
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName(rawValue: animationStyle))
            animation.duration = animationDuration
            return animation
        }
        
        return super.action(forKey: event)
    }
    
    
    // MARK: Helpers
    
    /**
     Draws the outer ring for the view.
     Sets path properties according to how the user has decided to customize the view.
     */
    private func drawOuterRing() {
        guard outerRingWidth > 0 else { return }
        
        let width = bounds.width
        let height = bounds.width
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let outerRadius = max(width, height)/2 - outerRingWidth/2
        let start = fullCircle ? 0 : startAngle.toRads
        let end = fullCircle ? CGFloat.pi*2 : endAngle.toRads
        
        let outerPath = UIBezierPath(arcCenter: center,
                                     radius: outerRadius,
                                     startAngle: start,
                                     endAngle: end,
                                     clockwise: true)
        
        outerPath.lineWidth = outerRingWidth
        outerPath.lineCapStyle = outerCapStyle
        
        // If the style is 3 or 4, make sure to draw either dashes or dotted path
        if viewStyle == 3 {
            outerPath.setLineDash(patternForDashes, count: patternForDashes.count, phase: 0.0)
        } else if viewStyle == 4 {
            outerPath.setLineDash([0, outerPath.lineWidth * 2], count: 2, phase: 0)
            outerPath.lineCapStyle = .round
        }
        
        outerRingColor.setStroke()
        outerPath.stroke()
    }
    
    /**
     Draws the inner ring for the view.
     Sets path properties according to how the user has decided to customize the view.
     */
    private func drawInnerRing() {
        guard innerRingWidth > 0 else { return }
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        var innerEndAngle: CGFloat = 0.0
        
        if fullCircle {
            innerEndAngle = (360.0 / CGFloat(maxValue)) * CGFloat(value) + startAngle
        } else {
            // Calculate the center difference between the end and start angle
            let angleDiff: CGFloat = endAngle - startAngle
            // Calculate how much we should draw depending on the value set
            let arcLenPerValue = angleDiff / CGFloat(maxValue)
            // The inner end angle some basic math is done
            innerEndAngle = arcLenPerValue * CGFloat(value) + startAngle
        }
        
        // The radius for style 1 is set below
        // The radius for style 1 is a bit less than the outer, this way it looks like its inside the circle
        var radiusIn = (max(bounds.width - outerRingWidth*2 - innerRingSpacing, bounds.height - outerRingWidth*2 - innerRingSpacing)/2) - innerRingWidth/2
        
        // If the style is different, mae the radius equal to the outerRadius
        if viewStyle >= 2 {
            radiusIn = (max(bounds.width, bounds.height)/2) - (outerRingWidth/2)
        }
        // Start drawing
        let innerPath = UIBezierPath(arcCenter: center,
                                     radius: radiusIn,
                                     startAngle: startAngle.toRads,
                                     endAngle: innerEndAngle.toRads,
                                     clockwise: true)
        innerPath.lineWidth = innerRingWidth
        innerPath.lineCapStyle = innerCapStyle
        innerRingColor.setStroke()
        innerPath.stroke()
    }
    
    /**
     Draws the value label for the view.
     Only drawn if shouldShowValueText = true
     */
    private func drawValueLabel() {
        guard shouldShowValueText else { return }
        
        // Draws the text field
        // Some basic label properties are set
        valueLabel.font = self.font
        valueLabel.textAlignment = .center
        valueLabel.textColor = fontColor
        
        valueLabel.update(withValue: value, valueIndicator: valueIndicator,
                          showsDecimal: showFloatingPoint, decimalPlaces: decimalPlaces)
        
        // Deterime what should be the center for the label
        valueLabel.center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        valueLabel.drawText(in: self.bounds)
    }
}






@IBDesignable open class UICircularProgressRingView: UIView {
    
    // MARK: Delegate
    /**
     The delegate for the UICircularProgressRingView
     
     ## Important ##
     When progress is done updating via UICircularProgressRingView.setValue(_:), the
     finishedUpdatingProgressFor(_ ring: UICircularProgressRingView) will be called.
     
     The ring will be passed to the delegate in order to keep track of multiple ring updates if needed.
     
     ## Author:
     Luis Padron
     */
    open weak var delegate: UICircularProgressRingDelegate?
    
    // MARK: Circle Properties
    
    /**
     Whether or not the progress ring should be a full circle.
     
     What this means is that the outer ring will always go from 0 - 360 degrees and the inner ring will be calculated accordingly depending on current value.
     
     ## Important ##
     Default = true
     
     When this property is true any value set for `endAngle` will be ignored.
     
     ## Author:
     Luis Padron
     
     */
    @IBInspectable open var fullCircle: Bool = true {
        didSet {
            self.ringLayer.fullCircle = self.fullCircle
        }
    }
    
    // MARK: Value Properties
    
    /**
     The value property for the progress ring. ex: (23)/100
     
     ## Important ##
     Default = 0
     
     This cannot be used to get the value while the ring is animating, to get current value while animating use `currentValue`
     
     The current value of the progress ring, use setProgress(value:) to alter the value with the option
     to animate and have a completion handler.
     
     ## Author:
     Luis Padron
     */
    @IBInspectable open var value: CGFloat = 0 {
        didSet {
            self.ringLayer.value = self.value
        }
    }
    
    /**
     The current value of the progress ring
     
     This will return the current value of the progress ring, if the ring is animating it will be updated in real time.
     If the ring is not currently animating then the value returned will be the `value` property of the ring
     
     ## Author:
     Luis Padron
     */
    open var currentValue: CGFloat? {
        get {
            if isAnimating {
                return self.layer.presentation()?.value(forKey: "value") as? CGFloat
            } else {
                return self.value
            }
        }
    }
    
    /**
     The max value for the progress ring. ex: 23/(100)
     Used to calculate amount of progress depending on self.value and self.maxValue
     
     ## Important ##
     Default = 100
     
     
     ## Author:
     Luis Padron
     */
    @IBInspectable open var maxValue: CGFloat = 100 {
        didSet {
            self.ringLayer.maxValue = self.maxValue
        }
    }
    
    // MARK: View Style
    
    /**
     Variable for the style of the progress ring.
     
     Range: [1,4]
     
     The four styles are
     
     - 1: Radius of the inner ring is smaller (inner ring inside outer ring)
     - 2: Radius of inner ring is equal to outer ring (both at same location)
     - 3: Radius of inner ring is equal to outer ring, and the outer ring is dashed
     - 4: Radius of inner ring is equal to outer ring, and the outer ring is dotted
     
     ## Important ##
     Default = 1
     
     
     ## Author:
     Luis Padron
     */
    @IBInspectable open var viewStyle: Int = 1 {
        didSet {
            self.ringLayer.viewStyle = self.viewStyle
        }
    }
    
    /**
     An array of CGFloats, used to calculate the dash length for viewStyle = 3
     
     ## Important ##
     Default = [7.0, 7.0]
     
     ## Author:
     Luis Padron
     */
    open var patternForDashes: [CGFloat] = [7.0, 7.0] {
        didSet {
            self.ringLayer.patternForDashes = self.patternForDashes
        }
    }
    
    /**
     The start angle for the entire progress ring view.
     
     Please note that Cocoa Touch uses a clockwise rotating unit circle.
     I.e: 90 degrees is at the bottom and 270 degrees is at the top
     
     ## Important ##
     Default = 0 (degrees)
     
     Values should be in degrees (they're converted to radians internally)
     
     ## Author:
     Luis Padron
     */
    @IBInspectable open var startAngle: CGFloat = 0 {
        didSet {
            self.ringLayer.startAngle = self.startAngle
        }
    }
    
    /**
     The end angle for the entire progress ring
     
     Please note that Cocoa Touch uses a clockwise rotating unit circle.
     I.e: 90 degrees is at the bottom and 270 degrees is at the top
     
     ## Important ##
     Default = 360 (degrees)
     
     Values should be in degrees (they're converted to radians internally)
     
     ## Author:
     Luis Padron
     */
    @IBInspectable open var endAngle: CGFloat = 360 {
        didSet {
            self.ringLayer.endAngle = self.endAngle
        }
    }
    
    // MARK: Outer Ring properties
    
    /**
     The width of the outer ring for the progres bar
     
     ## Important ##
     Default = 10.0
     
     ## Author:
     Luis Padron
     */
    @IBInspectable open var outerRingWidth: CGFloat = 10.0 {
        didSet {
            self.ringLayer.outerRingWidth = self.outerRingWidth
        }
    }
    
    /**
     The color for the outer ring
     
     ## Important ##
     Default = UIColor.gray
     
     ## Author:
     Luis Padron
     */
    @IBInspectable open var outerRingColor: UIColor = UIColor.gray {
        didSet {
            self.ringLayer.outerRingColor = self.outerRingColor
        }
    }
    
    /**
     The style for the outer ring end cap (how it is drawn on screen)
     Range [1,3]
     - 1: Line with a squared off end
     - 2: Line with a rounded off end
     - 3: Line with a square end
     - <1 & >3: Defaults to style 1
     
     ## Important ##
     Default = 1
     
     ## Author:
     Luis Padron
     */
    @IBInspectable open var outerRingCapStyle: Int = 1 {
        didSet {
            switch self.outerRingCapStyle{
            case 1:
                self.outStyle = .butt
                self.ringLayer.outerCapStyle = .butt
            case 2:
                self.outStyle = .round
                self.ringLayer.outerCapStyle = .round
            case 3:
                self.outStyle = .square
                self.ringLayer.outerCapStyle = .square
            default:
                self.outStyle = .butt
                self.ringLayer.outerCapStyle = .butt
            }
        }
    }
    
    /**
     
     A internal outerRingCapStyle variable, this is set whenever the
     IB compatible variable above is set.
     
     Basically in here because IB doesn't support CGLineCap selection.
     
     */
    internal var outStyle: CGLineCap = .butt
    
    // MARK: Inner Ring properties
    
    /**
     The width of the inner ring for the progres bar
     
     ## Important ##
     Default = 5.0
     
     ## Author:
     Luis Padron
     */
    @IBInspectable open var innerRingWidth: CGFloat = 5.0 {
        didSet {
            self.ringLayer.innerRingWidth = self.innerRingWidth
        }
    }
    
    /**
     The color of the inner ring for the progres bar
     
     ## Important ##
     Default = UIColor.blue
     
     ## Author:
     Luis Padron
     */
    @IBInspectable open var innerRingColor: UIColor = UIColor.blue {
        didSet {
            self.ringLayer.innerRingColor = self.innerRingColor
        }
    }
    
    /**
     The spacing between the outer ring and inner ring
     
     ## Important ##
     This only applies when using progressRingStyle = 1
     
     Default = 1
     
     ## Author:
     Luis Padron
     */
    @IBInspectable open var innerRingSpacing: CGFloat = 1 {
        didSet {
            self.ringLayer.innerRingSpacing = self.innerRingSpacing
        }
    }
    
    /**
     The style for the inner ring end cap (how it is drawn on screen)
     
     Range [1,3]
     
     - 1: Line with a squared off end
     - 2: Line with a rounded off end
     - 3: Line with a square end
     - <1 & >3: Defaults to style 2
     
     ## Important ##
     Default = 2
     
     
     
     ## Author:
     Luis Padron
     */
    @IBInspectable open var innerRingCapStyle: Int = 0 {
        didSet {
            switch self.innerRingCapStyle {
            case 1:
                self.inStyle = .butt
                self.ringLayer.innerCapStyle = .butt
            case 2:
                self.inStyle = .round
                self.ringLayer.innerCapStyle = .round
            case 3:
                self.inStyle = .square
                self.ringLayer.innerCapStyle = .square
                
            default:
                self.inStyle = .butt
                self.ringLayer.innerCapStyle = .butt
            }
        }
    }
    
    
    /**
     
     A internal innerRingCapStyle variable, this is set whenever the
     IB compatible variable above is set.
     
     Basically in here because IB doesn't support CGLineCap selection.
     
     */
    internal var inStyle: CGLineCap = .round
    
    // MARK: Label
    
    /**
     A toggle for showing or hiding the value label.
     If false the current value will not be shown.
     
     ## Important ##
     Default = true
     
     ## Author:
     Luis Padron
     */
    @IBInspectable open var shouldShowValueText: Bool = true {
        didSet {
            self.ringLayer.shouldShowValueText = self.shouldShowValueText
        }
    }
    
    /**
     The text color for the value label field
     
     ## Important ##
     Default = UIColor.black
     
     
     ## Author:
     Luis Padron
     */
    @IBInspectable open var fontColor: UIColor = UIColor.black {
        didSet {
            self.ringLayer.fontColor = self.fontColor
        }
    }
    
    /**
     The font to be used for the progress indicator.
     All font attributes are specified here except for font color, which is done using `fontColor`.
     
     
     ## Important ##
     Default = UIFont.systemFont(ofSize: 18)
     
     
     ## Author:
     Luis Padron
     */
    @IBInspectable open var font: UIFont = UIFont.systemFont(ofSize: 18) {
        didSet {
            self.ringLayer.font = self.font
        }
    }
    
    /**
     The name of the value indicator the value label will
     appened to the value
     Example: " GB" -> "100 GB"
     
     ## Important ##
     Default = "%"
     
     ## Author:
     Luis Padron
     */
    @IBInspectable open var valueIndicator: String = "%" {
        didSet {
            self.ringLayer.valueIndicator = self.valueIndicator
        }
    }
    
    /**
     A toggle for showing or hiding floating points from
     the value in the value label
     
     ## Important ##
     Default = false (dont show)
     
     To customize number of decmial places to show, assign a value to decimalPlaces.
     
     ## Author:
     Luis Padron
     */
    @IBInspectable open var showFloatingPoint: Bool = false {
        didSet {
            self.ringLayer.showFloatingPoint = self.showFloatingPoint
        }
    }
    
    /**
     The amount of decimal places to show in the value label
     
     ## Important ##
     Default = 2
     
     Only used when showFloatingPoint = true
     
     ## Author:
     Luis Padron
     */
    @IBInspectable open var decimalPlaces: Int = 2 {
        didSet {
            self.ringLayer.decimalPlaces = self.decimalPlaces
        }
    }
    
    // MARK: Animation properties
    
    /**
     The type of animation function the ring view will use
     
     ## Important ##
     Default = kCAMediaTimingFunctionEaseIn
     
     String should be from kCAMediaTimingFunction_____
     
     Only used when calling .setValue(animated: true)
     
     ## Author:
     Luis Padron
     */
    open var animationStyle: String = CAMediaTimingFunctionName.easeIn.rawValue {
        didSet {
            self.ringLayer.animationStyle = self.animationStyle
        }
    }
    
    /**
     This returns whether or not the ring is currently animating
     
     ## Important ##
     Get only property
     
     ## Author:
     Luis Padron
     */
    open var isAnimating: Bool {
        get { return (self.layer.animation(forKey: "value") != nil) ? true : false }
    }
    
    // MARK: Layer
    
    /**
     Set the ring layer to the default layer, cated as custom layer
     */
    internal var ringLayer: UICircularProgressRingLayer {
        return self.layer as! UICircularProgressRingLayer
    }
    
    /**
     Overrides the default layer with the custom UICircularProgressRingLayer class
     */
    override open class var layerClass: AnyClass {
        get {
            return UICircularProgressRingLayer.self
        }
    }
    
    // MARK: Methods
    
    /**
     Overriden public init to initialize the layer and view
     */
    override public init(frame: CGRect) {
        super.init(frame: frame)
        // Call the internal initializer
        initialize()
    }
    
    /**
     Overriden public init to initialize the layer and view
     */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Call the internal initializer
        initialize()
    }
    
    /**
     This method initializes the custom CALayer
     For some reason didSet doesnt get called during initializing, so
     has to be done manually in here or else nothing would be drawn.
     */
    internal func initialize() {
        // Helps with pixelation and blurriness on retina devices
        self.layer.contentsScale = UIScreen.main.scale
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale * 2
        self.ringLayer.fullCircle = fullCircle
        self.ringLayer.value = value
        self.ringLayer.maxValue = maxValue
        self.ringLayer.viewStyle = viewStyle
        self.ringLayer.patternForDashes = patternForDashes
        self.ringLayer.startAngle = startAngle
        self.ringLayer.endAngle = endAngle
        self.ringLayer.outerRingWidth = outerRingWidth
        self.ringLayer.outerRingColor = outerRingColor
        self.ringLayer.outerCapStyle = outStyle
        self.ringLayer.innerRingWidth = innerRingWidth
        self.ringLayer.innerRingColor = innerRingColor
        self.ringLayer.innerCapStyle = inStyle
        self.ringLayer.innerRingSpacing = innerRingSpacing
        self.ringLayer.shouldShowValueText = shouldShowValueText
        self.ringLayer.valueIndicator = valueIndicator
        self.ringLayer.fontColor = fontColor
        self.ringLayer.font = font
        self.ringLayer.showFloatingPoint = showFloatingPoint
        self.ringLayer.decimalPlaces = decimalPlaces
        
        // Sets background color to clear, this fixes a bug when placing view in tableview cells
        self.backgroundColor = UIColor.clear
        self.ringLayer.backgroundColor = UIColor.clear.cgColor
    }
    
    /**
     Overriden because of custom layer drawing in UICircularProgressRingLayer
     */
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    
    /**
     Typealias for the setProgress(:) method closure
     */
    public typealias ProgressCompletion = (() -> Void)
    
    /**
     Sets the current value for the progress ring, calling this method while ring is animating will cancel the previously set animation and start a new one.
     
     - Parameter newVal: The value to be set for the progress ring
     - Parameter animationDuration: The time interval duration for the animation
     - Parameter completion: The completion closure block that will be called when animtion is finished (also called when animationDuration = 0), default is nil
     
     ## Important ##
     Animatin duration = 0 will cause no animation to occur, and value will instantly be set
     
     ## Author:
     Luis Padron
     */
    open func setProgress(value: CGFloat, animationDuration: TimeInterval, completion: ProgressCompletion? = nil) {
        // Remove the current animation, so that new can be processed
        if isAnimating { self.layer.removeAnimation(forKey: "value") }
        // Only animate if duration sent is greater than zero
        self.ringLayer.animated = animationDuration > 0
        self.ringLayer.animationDuration = animationDuration
        // Create a transaction to be notified when animation is complete
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            // Call the closure block
            self.delegate?.finishedUpdatingProgress(forRing: self)
            completion?()
        }
        self.value = value
        self.ringLayer.value = value
        CATransaction.commit()
    }
}
