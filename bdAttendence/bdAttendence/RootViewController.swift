//
//  RootViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 03/05/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit
import BluedolphinCloudSdk

class RootViewController: UIViewController {
    
    @IBOutlet weak var sendOtpButton: UIButton!
    @IBOutlet weak var mobileTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        mobileTextField.delegate = self
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
        if mobileTextField.text!.isBlank{
            self.showAlert(ErrorMessage.FECodeError.rawValue)
        }
        else if mobileTextField.text!.isMobile {
            if isInternetAvailable() {
                sendOTP()
            }else {
                showAlert(ErrorMessage.NetError.rawValue)
            }
        }else {
            showAlert(ErrorMessage.InvalidFECode.rawValue)
        }
        
        
    }
    
    func sendOTP(){
        
        showLoader()
        OTPModel.getOtp(mobile: mobileTextField.text!) { (result) in
            switch (result){
            case APIResult.Success.rawValue:
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "otpScreen") as? OTPViewController
                controller?.mobileNumber = self.mobileTextField.text!
                self.navigationController?.show(controller!, sender: nil)
            case APIResult.InvalidCredentials.rawValue:
                self.showAlert(ErrorMessage.UserNotFound.rawValue)
                
            case APIResult.InternalServer.rawValue:
                self.showAlert(ErrorMessage.InternalServer.rawValue)
                
                
            case APIResult.InvalidData.rawValue:
                self.showAlert(ErrorMessage.NotValidData.rawValue)
            default:
                break
                
            }
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showAlert(_ message : String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (action) in
            return        }
        alertController.addAction(OkAction)
        self.present(alertController, animated: true) {
        }
    }
    
    func showLoader(text:String = "Sending OTP" ){
        AlertView.sharedInstance.setLabelText(text)
        AlertView.sharedInstance.showActivityIndicator(self.view)
        let delay = 3.0 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            AlertView.sharedInstance.hideActivityIndicator(self.view)
            //self.dismiss(animated: true, completion: nil)
        })
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
extension RootViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if updatedText.characters.count > 10 {
            return false
        }
        return true
        
    }
    
}
