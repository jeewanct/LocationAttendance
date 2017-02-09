//
//  ScratchPad.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 13/12/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import UIKit
@IBDesignable
class ScratchPad: UIView {

    
    weak var delegate: ScratchPadDelegate!
    
    // MARK: - Public properties
    @IBInspectable  var strokeWidth: CGFloat = 2.0 {
        didSet {
            self.path.lineWidth = strokeWidth
        }
    }
    
    @IBInspectable  var strokeColor: UIColor = UIColor.black {
        didSet {
            self.strokeColor.setStroke()
        }
    }
    
    @IBInspectable open var signatureBackgroundColor: UIColor = UIColor.white {
        didSet {
            self.backgroundColor = signatureBackgroundColor
        }
    }
    
    // Computed Property returns true if the view actually contains a signature
    open var containsSignature: Bool {
        get {
            if self.path.isEmpty {
                return false
            } else {
                return true
            }
        }
    }
    
    // MARK: - Private properties
    fileprivate var path = UIBezierPath()
    fileprivate var pts = [CGPoint](repeating: CGPoint(), count: 5)
    fileprivate var ctr = 0
    
    // MARK: - Init
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = self.signatureBackgroundColor
        self.path.lineWidth = self.strokeWidth
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = self.signatureBackgroundColor
        self.path.lineWidth = self.strokeWidth
    }
    
    // MARK: - Draw
    override open func draw(_ rect: CGRect) {
        self.strokeColor.setStroke()
        self.path.stroke()
    }
    
    // MARK: - Touch handling functions
    override open func touchesBegan(_ touches: Set <UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let touchPoint = firstTouch.location(in: self)
            self.ctr = 0
            self.pts[0] = touchPoint
        }
        
        if let delegate = self.delegate {
            delegate.startedSignatureDrawing!()
        }
    }
    
    override open func touchesMoved(_ touches: Set <UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let touchPoint = firstTouch.location(in: self)
            self.ctr += 1
            self.pts[self.ctr] = touchPoint
            if (self.ctr == 4) {
                self.pts[3] = CGPoint(x: (self.pts[2].x + self.pts[4].x)/2.0, y: (self.pts[2].y + self.pts[4].y)/2.0)
                self.path.move(to: self.pts[0])
                self.path.addCurve(to: self.pts[3], controlPoint1:self.pts[1], controlPoint2:self.pts[2])
                
                self.setNeedsDisplay()
                self.pts[0] = self.pts[3]
                self.pts[1] = self.pts[4]
                self.ctr = 1
            }
            
            self.setNeedsDisplay()
        }
    }
    
    override open func touchesEnded(_ touches: Set <UITouch>, with event: UIEvent?) {
        if self.ctr == 0 {
            let touchPoint = self.pts[0]
            self.path.move(to: CGPoint(x: touchPoint.x-1.0,y: touchPoint.y))
            self.path.addLine(to: CGPoint(x: touchPoint.x+1.0,y: touchPoint.y))
            self.setNeedsDisplay()
        } else {
            self.ctr = 0
        }
        
        if let delegate = self.delegate {
            delegate.finishedSignatureDrawing!()
        }
    }
    
    // MARK: - Methods for interacting with Signature View
    
    // Clear the Signature View
    open func clearSignature() {
        self.path.removeAllPoints()
        self.setNeedsDisplay()
    }
    
    // Save the Signature as an UIImage
    open func getSignature() -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: self.bounds.size.width, height: self.bounds.size.height))
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
            let signature = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return signature
        } else {
            return nil
        }
    }
    
    // Save the Signature (cropped of outside white space) as a UIImage
    open func getSignatureCropped() -> UIImage? {
        if let fullRender = getSignature() {
            if let imageRef = fullRender.cgImage?.cropping(to: path.bounds) {
                return UIImage(cgImage: imageRef)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}

// MARK: - Optional Protocol Methods for YPDrawSignatureViewDelegate
@objc protocol ScratchPadDelegate: class {
    @objc optional func startedSignatureDrawing()
    @objc optional func finishedSignatureDrawing()
}
