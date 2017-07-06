//
//  NewOtpViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 21/06/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit
import RealmSwift
import BluedolphinCloudSdk

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
        otpLabel.font = APPFONT.OTPCONFIRMATION
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
    

    
    func updateUser() {
        let objectdata = ["loginType":"mobile",
                          "mobile":mobileNumber,
                          "otpToken":otpToken,
                          "deviceType":"ios",
                          "deviceToken":UserDefaults.standard.value(forKey: "DeviceToken") as! String,
                          "imeiId":SDKSingleton.sharedInstance.DeviceUDID
            
            
        ]
        
        
        UserDataModel.createUserData(userObject: objectdata)
        UserDataModel.userSignUp(mobile: mobileNumber) { (result) in
            
        }
    }
    
    
    func getOauth(){
        let param = [
            "grantType":"accessToken",
            "selfRequest":true,
            "loginType":"mobile",
            "mobile":mobileNumber,
            "otpToken":otpToken
            ] as [String : Any]
        if isInternetAvailable() {
            showLoader(text: "Verifying")
            OauthModel.getToken(userObject: param) { (result) in
                
                switch (result){
                case APIResult.Success.rawValue:
                    self.updateUser()
                    UserDefaults.standard.set(self.mobileNumber, forKey: UserDefaultsKeys.FeCode.rawValue)
                    let realm = try! Realm()
                    let tokensList = realm.objects(AccessTokenObject.self)
                    if tokensList.count > 1{
                        let destVC = self.storyboard?.instantiateViewController(withIdentifier: "orgList") as! UINavigationController
                        let topController = destVC.topViewController as! NewOrganisationSelectViewController
                        topController.accessTokensList = tokensList
                        UIApplication.shared.keyWindow?.rootViewController = destVC
                        
                    }else{
                        for token in tokensList{
                            UserDefaults.standard.set(token.organizationId, forKey: UserDefaultsKeys.organizationId.rawValue)
                        }
                        
                        getUserData()
                        let destVC = self.storyboard?.instantiateViewController(withIdentifier: "Main") as! UINavigationController
                        UIApplication.shared.keyWindow?.rootViewController = destVC
                    }
                    
                case APIResult.InvalidCredentials.rawValue:
                    self.showAlert(ErrorMessage.InvalidOtp.rawValue)
                    
                case APIResult.InternalServer.rawValue:
                    self.showAlert(ErrorMessage.InternalServer.rawValue)
                    
                    
                case APIResult.InvalidData.rawValue:
                    self.showAlert(ErrorMessage.NotValidData.rawValue)
                default:
                    break
                    
                }
                
            }
            
        }else {
            showAlert(ErrorMessage.NetError.rawValue)
        }
        
    }
    
    
    func sendOTP(){
        
        showLoader()
        OTPModel.getOtp(mobile: mobileNumber) { (result) in
            switch (result){
            case APIResult.Success.rawValue:
                self.showAlert("Otp Sent")
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
    
    
    func showAlert(_ message : String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
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
    
    
    
}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */
extension NewOtpViewController:CodeInputViewDelegate{
    func codeInputView(codeInputView: CodeInputView, didFinishWithCode code: String) {
        otpToken  = code
        getOauth()
    }
}


