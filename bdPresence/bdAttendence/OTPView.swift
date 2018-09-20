//
//  OTPView.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 12/12/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation
import UIKit

public class CodeInputView: UIView, UIKeyInput {
    public var numberOfText:Int = 6
    public var delegate: CodeInputViewDelegate?
    private var nextTag = 1
    
    // MARK: - dsfdsfdsfdsdsfdsfffUIResponder
    public override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    // MARK: - UIView
    public override init(frame: CGRect) {
        super.init(frame: frame)
        print(frame)
        let width = CGFloat(self.frame.width)/CGFloat(numberOfText)
        // Add four digitLabels
        
       
        var frame = CGRect(x: 0, y: 5, width: width - 20, height: 40)
        
        for index in 1...numberOfText {
            frame.origin.x += 10
            let digitLabel = UILabel(frame: frame)
            digitLabel.font = UIFont.systemFont(ofSize: 42)
            digitLabel.tag = index
            digitLabel.text = "–"
            digitLabel.textColor = UIColor.black
            digitLabel.textAlignment = .center
            addSubview(digitLabel)
            frame.origin.x += frame.width + 10
        }
    }
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") } // NSCoding
    
    
    // MARK: - UIKeyInput
    public var hasText:Bool {
        get {
            return nextTag > 1 ? true : false
        }
        
    }
    
    public func insertText(_ text: String) {
        if nextTag < numberOfText + 1{
            (viewWithTag(nextTag)! as! UILabel).text = text
            nextTag += 1
            
            if nextTag == numberOfText + 1 {
                var code = ""
                for index in 1..<nextTag {
                    code += (viewWithTag(index)! as! UILabel).text!
                }
                delegate?.codeInputView(codeInputView: self, didFinishWithCode: code)
            }
        }
    }
    
    public func deleteBackward() {
        if nextTag > 1 {
            nextTag -= 1
            (viewWithTag(nextTag)! as! UILabel).text = "–"
        }
    }
    
    public func clear() {
        while nextTag > 1 {
            deleteBackward()
        }
    }
    
    // MARK: - UITextInputTraits
    public var keyboardType: UIKeyboardType { get { return .numberPad } set { } }
}

public protocol CodeInputViewDelegate {
    func codeInputView(codeInputView: CodeInputView, didFinishWithCode code: String)
}
