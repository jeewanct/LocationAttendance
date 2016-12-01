//
//  ViewController.swift
//  BluedolphinPro
//
//  Created by RMC LTD on 20/10/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

   @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    var email = String()
    var pass = String()
    
    
    @IBAction func SignIn(_ sender: AnyObject) {
        email = mobileTextField.text!
            //+ "@rmc.in"
        //pass = password.text!
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
        
        // Do any additional setup after loading the view, typically from a nib.
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
                          "imeiId":Singleton.sharedInstance.DeviceUDID
            
            
        ]
        
                let userData = UserDataModel()
                userData.createUserData(userObject: objectdata)
                userData.userSignUp(email: email)
    }
    
    
    func getOauth(){
                let param = [
                            "grantType":"accessToken",
                            "selfRequest":"true",
                            "signUpType":"custom",
                            "email":email,
                            "password":pass
                        ]
        
        let oauth = OauthModel()
        oauth.getToken(userObject: param) { (result) in
            if result == APIResult.Success.rawValue {
                let navController = self.storyboard?.instantiateViewController(withIdentifier: "AssignmentScene") as! UINavigationController
                let controller = navController.topViewController as! AssignmentViewController
                
                self.navigationController?.pushViewController(navController, animated: true)
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
            
        }
        return true
    }
    
}

