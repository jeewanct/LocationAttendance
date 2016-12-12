//
//  OTPViewController.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 12/12/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import UIKit

class OTPViewController: UIViewController ,CodeInputViewDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        let codeInputView = CodeInputView(frame: CGRect(x: (view.frame.width-215)/2, y: 242, width: 215, height: 60))
        codeInputView.delegate = self
        codeInputView.tag = 17
        view.addSubview(codeInputView)
        
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
