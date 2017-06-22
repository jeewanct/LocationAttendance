//
//  NewOtpViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 21/06/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit

class NewOtpViewController: UIViewController {
    @IBOutlet weak var otpView: UIView!

    @IBOutlet weak var otpLabel: UILabel!
    fileprivate var otpToken = String()
    var mobileNumber = "9015620820"
    override func viewDidLoad() {
        super.viewDidLoad()
    self.view.applyGradient(isTopBottom: true, colorArray: [APPColor.BlueGradient,APPColor.GreenGradient])
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        let codeInputView = CodeInputView(frame: CGRect(x: 0, y: 0, width: otpView.frame.width, height: otpView.frame.height))
        codeInputView.delegate = self
        codeInputView.tag = 17
        
        otpView.addSubview(codeInputView)
        
        codeInputView.becomeFirstResponder()
        otpLabel.text = "6-digit OTP send to \(mobileNumber)"
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(backbuttonAction(sender:)))
        // Do any additional setup after loading the view.
    }
    
    func backbuttonAction(sender:Any){
        self.navigationController?.popViewController(animated: true)
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
extension NewOtpViewController:CodeInputViewDelegate{
    func codeInputView(codeInputView: CodeInputView, didFinishWithCode code: String) {
        otpToken  = code
        ///getOauth()
    }
}
