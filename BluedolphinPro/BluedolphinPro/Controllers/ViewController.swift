//
//  ViewController.swift
//  BluedolphinPro
//
//  Created by RMC LTD on 20/10/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var window: UIWindow?
   @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    var email = String()
    var pass = String()
    let signButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    let checkButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    @IBAction func SignIn(_ sender: AnyObject) {
        email = mobileTextField.text!
            //+ "@rmc.in"
        pass = passwordTextfield.text!
        updateUser()
        getOauth()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let deviceToken = UserDefaults.standard.value(forKey: UserDefaultsKeys.deviceToken.rawValue) as? String{
            print(deviceToken)
        }
        mobileTextField.delegate = self
        passwordTextfield.delegate  = self
        
        passwordTextfield.rightViewMode = .always
        signButton.setImage(UIImage(named: "chevron_inactive"), for: UIControlState.normal)
        passwordTextfield.rightView = signButton
        signButton.addTarget(self, action: #selector(ViewController.signInAction(sender:)), for: UIControlEvents.touchUpInside)
        signButton.isUserInteractionEnabled = false
            
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    func signInAction(sender:UIButton){
        email = mobileTextField.text!
        //+ "@rmc.in"
        pass = passwordTextfield.text!
        updateUser()
        getOauth()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updateUser(){
        let objectdata = ["email": email,
                          "signUpType":"custom",
                          "password":pass,
                          "deviceType":"ios",
                          "deviceToken":UserDefaults.standard.value(forKey: "DeviceToken") as! String,
                          "imeiId":SDKSingleton.sharedInstance.DeviceUDID
            
            
        ]
        
        
//                UserDataModel.createUserData(userObject: objectdata)
//                UserDataModel.userSignUp(param: email) { (value) in
//                    print(value)
//        }
    }
    
    
    func getOauth(){
                let param = [
                            "grantType":"accessToken",
                            "selfRequest":"true",
                            "loginType":"mobile",
                            "mobile":email,
                            "otpToken":pass
                        ]
        
    
        OauthModel.getToken(userObject: param) { (result) in
            if result == APIResult.Success.rawValue {
                getUserData()
                let destVC = self.storyboard?.instantiateViewController(withIdentifier: "Main") as! UINavigationController
                UIApplication.shared.keyWindow?.rootViewController = destVC
            }
        }

    }
    


}
extension ViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if updatedText.isBlank {
            textField.leftViewMode = .never
            if textField == mobileTextField {
                mobileTextField.rightViewMode = .never
            }else{
                signButton.setImage(UIImage(named: "chevron_inactive"), for: UIControlState.normal)
                passwordTextfield.rightView = signButton
                signButton.isUserInteractionEnabled = false
            }
            
            
            

        }else{
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 10 , height: textField.frame.size.height))
            label.text = textField.placeholder
            label.frame.size.width = label.intrinsicContentSize.width
            label.font = UIFont(name: "SourceSansPro-Regular", size: 14)
            label.textColor = UIColor.black
            label.textAlignment = .center
            textField.leftView = label
            textField.leftView?.frame.origin.x = 5
            textField.leftViewMode = .always
            
            if textField == mobileTextField {
                checkButton.setImage(UIImage(named: "check"), for: UIControlState.normal)
                mobileTextField.rightView = checkButton
                mobileTextField.rightViewMode = .always
            } else{
                signButton.setImage(UIImage(named: "chevron_active"), for: UIControlState.normal)
                passwordTextfield.rightView = signButton
                signButton.isUserInteractionEnabled = true

            }
            
        }
        return true
    }
    
}

