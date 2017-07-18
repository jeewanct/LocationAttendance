//
//  GradientView.swift
//  bdAttendence
//
//  Created by Raghvendra on 21/06/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import Foundation
import UIKit

class GradientView: UIView {
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = self.layer as! CAGradientLayer
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.colors = [APPColor.blue.cgColor, APPColor.black.cgColor]
    }
}

extension UIView {
    
    func applyGradient(isTopBottom: Bool, colorArray: [UIColor]) {
        if let sublayers = layer.sublayers {
            let _ = sublayers.filter({ $0 is CAGradientLayer }).map({ $0.removeFromSuperlayer() })
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colorArray.map({ $0.cgColor })
        if isTopBottom {
            gradientLayer.locations = [0.0, 1.0]
            gradientLayer.startPoint = CGPoint.zero
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)

        } else {
            //leftRight
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        
        //backgroundColor = .clear
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
}

class FrequencyGraphView :UIView {
    var dataList = [CGRect]()
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, data: [CGRect]) {
        
        super.init(frame: frame)
        self.dataList = data
        draw(frame)
        
    }
    override func draw(_ rect: CGRect) {
        self.backgroundColor = APPColor.newYellow
        for data in dataList {
            if let ctx = UIGraphicsGetCurrentContext()
            {
                ctx.setFillColor(APPColor.newGreen.cgColor)
                ctx.setStrokeColor(APPColor.newGreen.cgColor)
                ctx.setLineWidth(1)
                
               // print(data)
                ctx.addRect(data)
                ctx.drawPath(using: .fillStroke)
            }
//            print(data)
//            let color = APPColor.newGreen
//            let bpath:UIBezierPath = UIBezierPath(rect: data)
//            
//            color.set()
//            bpath.stroke()
        }
    }

    
}
