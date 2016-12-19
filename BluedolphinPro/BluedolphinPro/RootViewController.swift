//
//  RootViewController.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 16/12/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    @IBOutlet weak var sendOtpButton: UIButton!
    @IBOutlet weak var mobileTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
//        let codelabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
//        codelabel.text = "+91-"
//        mobileTextField.leftViewMode = .always
//        mobileTextField.leftView = codelabel
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        sendOtpButton.addTarget(self, action: #selector(sendOtpAction), for: UIControlEvents.touchUpInside)
        // Do any additional setup after loading the view.
    }

    func sendOtpAction(_:Any){
        let otpmodel = OTPModel()
        otpmodel.getOtp(mobile: mobileTextField.text!) { (result) in
            if result == APIResult.Success.rawValue{
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "otpScreen") as? OTPViewController
                controller?.mobileNumber = self.mobileTextField.text!
                self.navigationController?.show(controller!, sender: nil)
            }
        }
        
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
