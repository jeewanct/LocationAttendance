//
//  OTPViewController.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 12/12/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import UIKit

class OTPViewController: UIViewController ,CodeInputViewDelegate{

    @IBOutlet weak var otpView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let codeInputView = CodeInputView(frame: CGRect(x: 0, y: 0, width: otpView.frame.width, height: otpView.frame.height))
        codeInputView.delegate = self
        codeInputView.tag = 17
        
        otpView.addSubview(codeInputView)
        
        codeInputView.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }
    
    func codeInputView(codeInputView: CodeInputView, didFinishWithCode code: String) {
        print(code)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
