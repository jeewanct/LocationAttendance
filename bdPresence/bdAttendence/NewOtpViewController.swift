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

    @IBOutlet weak var sendOtpButton: UIButton!
    @IBOutlet weak var otpLabel: UILabel!
    var codeInputView : CodeInputView!
    fileprivate var otpToken = String()
    var mobileNumber = "9015620820"
    override func viewDidLoad() {
        super.viewDidLoad()
    //self.view.applyGradient(isTopBottom: true, colorArray: [APPColor.BlueGradient,APPColor.GreenGradient])
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = UIColor.white
        sendOtpButton.addTarget(self, action: #selector(sendOTP), for: UIControlEvents.touchUpInside)
        codeInputView = CodeInputView(frame: CGRect(x: 0, y: 0, width: otpView.frame.width, height: otpView.frame.height))
        codeInputView.delegate = self
        codeInputView.tag = 17
        
        otpView.addSubview(codeInputView)
        
        //codeInputView.becomeFirstResponder()
        otpLabel.text = "6-digit OTP send to \(mobileNumber)"
        otpLabel.font = APPFONT.OTPCONFIRMATION
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(backbuttonAction(sender:)))
        // Do any additional setup after loading the view.
        
        /* Changes made from 10 th July '18 */
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleHideKeyBoard)))
        let downGesturee = UISwipeGestureRecognizer(target: self, action: #selector(handleHideKeyBoard))
        downGesturee.direction = .down
        view.addGestureRecognizer(downGesturee)
        otpView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc func handleHideKeyBoard(){
            codeInputView.resignFirstResponder()
    }
    
    
    @objc func handleTap(){
        codeInputView.becomeFirstResponder()
    }
    
    func backbuttonAction(sender:Any){
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
         codeInputView.becomeFirstResponder()
    }
    
    func updateUser(updateflag:Bool = false){
        
        var deviceToken = "3273a5f0598cd8e9518ccf07c67fbdd1ebb079d2a95aa890e259a4b70ecad57e"
        if let token = UserDefaults.standard.value(forKey: "DeviceToken") as? String {
            deviceToken = token
        }
        var objectdata :[String:AnyObject] = ["loginType":"mobile" as AnyObject,
                                              "mobile":mobileNumber as AnyObject,
                                              "otpToken":otpToken as AnyObject,
                                              "deviceType":"ios" as AnyObject,
                                              "appName":"BDPresence" as AnyObject,
                                              "deviceToken":deviceToken as AnyObject,
                                              "imeiId":SDKSingleton.sharedInstance.DeviceUDID as AnyObject,
                                              "appId":appIdentifier as AnyObject
            
            
        ]
        if updateflag{
            objectdata["updateFlag"] = updateflag as AnyObject
        }
        print(objectdata)
        //UserDataModel.createUserData(userObject: objectdata as! [String : AnyObject])
        AlertView.sharedInstance.setLabelText("Verifying")
        AlertView.sharedInstance.showActivityIndicator(self.view)
        UserDataModel.userSignUp(param:objectdata) { (value) in
        AlertView.sharedInstance.hideActivityIndicator(self.view)
            switch (value){
            case APIResult.Success.rawValue:
                
                UserDefaults.standard.set(self.mobileNumber, forKey: UserDefaultsKeys.FeCode.rawValue)
                UserDefaults.standard.synchronize()
                let realm = try! Realm()
                let tokensList = realm.objects(AccessTokenObject.self)
                if tokensList.count > 1{
                    let destVC = self.storyboard?.instantiateViewController(withIdentifier: "orgList") as! UINavigationController
//                    let topController = destVC.topViewController as! NewOrganisationSelectViewController
//                    topController.accessTokensList = tokensList
                    UIApplication.shared.keyWindow?.rootViewController = destVC
                    
                }else{
                    for token in tokensList{
                        UserDefaults.standard.set(token.organizationId, forKey: UserDefaultsKeys.organizationId.rawValue)
                        UserDefaults.standard.synchronize()
                    }
                    
                    getUserData()
                    let destVC = self.storyboard?.instantiateViewController(withIdentifier: "Main") as! UINavigationController
                    UIApplication.shared.keyWindow?.rootViewController = destVC
                }
            case APIResult.UserInteractionRequired.rawValue:
                self.showInteractionAlert(ErrorMessage.MultipleUser.rawValue )
                
                
            default:
                break
                
            }
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
        print(param)
        if isInternetAvailable() {
            //showLoader(text: "Verifying")
            AlertView.sharedInstance.setLabelText("Verifying")
            AlertView.sharedInstance.showActivityIndicator(self.view)
            OauthModel.getToken(userObject: param) { (result) in
                AlertView.sharedInstance.hideActivityIndicator(self.view)
                
                switch (result){
                case APIResult.Success.rawValue:
                    self.updateUser()
                    
                    
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
    func showInteractionAlert(_ message : String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: userUpdatePressed))
        alertController.addAction(UIAlertAction(title: "cancel", style: UIAlertActionStyle.default, handler: userCancelPressed))
        self.present(alertController, animated: true) {
        }
    }
    
    func userUpdatePressed(action: UIAlertAction){
        self.updateUser(updateflag: true)
    }
    func userCancelPressed(action: UIAlertAction){
        self.navigationController?.popViewController(animated: true)
        
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


