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
    var mobileNumber = String()
    var otpToken = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        let codeInputView = CodeInputView(frame: CGRect(x: 0, y: 0, width: otpView.frame.width, height: otpView.frame.height))
        codeInputView.delegate = self
        codeInputView.tag = 17
        
        otpView.addSubview(codeInputView)
        
        codeInputView.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func resendButton(_ sender: Any) {
    }
    func codeInputView(codeInputView: CodeInputView, didFinishWithCode code: String) {
        otpToken  = code
        updateUser()
        getOauth()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updateUser(){
        let objectdata = ["loginType":"mobile",
                          "mobile":mobileNumber,
                          "otpToken":otpToken,
                          "deviceType":"ios",
                          "deviceToken":UserDefaults.standard.value(forKey: "DeviceToken") as! String,
                          "imeiId":Singleton.sharedInstance.DeviceUDID
            
            
        ]
        
        let userData = UserDataModel()
        userData.createUserData(userObject: objectdata)
        userData.userSignUp(mobile: mobileNumber)
    }
    
    
    func getOauth(){
        let param = [
            "grantType":"accessToken",
            "selfRequest":true,
            "loginType":"mobile",
            "mobile":mobileNumber,
            "otpToken":otpToken
        ] as [String : Any]
        
        let oauth = OauthModel()
        oauth.getToken(userObject: param) { (result) in
            if result == APIResult.Success.rawValue {
                getUserData()
                let destVC = self.storyboard?.instantiateViewController(withIdentifier: "Main") as! UINavigationController
                UIApplication.shared.keyWindow?.rootViewController = destVC
            }
        }
        
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
