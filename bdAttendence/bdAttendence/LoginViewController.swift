//
//  LoginViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 19/04/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit
import BluedolphinCloudSdk

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }

    @IBAction func loginAction(_ sender: Any) {
        if emailTextfield.text!.isBlank{
            showAlert("Email cannot be blank")
            
        }else if emailTextfield.text!.isEmail {
            if isInternetAvailable(){
                showLoader()
                let nameArray = emailTextfield.text!.components(separatedBy: "@")
                BlueDolphinManager.manager.authorizeUser(email: emailTextfield.text!, firstName: nameArray[0], lastName: "", metaInfo: NSDictionary())
            }else {
                showAlert(ErrorMessage.NetError.rawValue)
            }
        }else{
            showAlert(ErrorMessage.emailError.rawValue)
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
    
    func showLoader(text:String = "Validating User" ){
        AlertView.sharedInstance.setLabelText(text)
        AlertView.sharedInstance.showActivityIndicator(self.view)
        let delay = 5.0 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            AlertView.sharedInstance.hideActivityIndicator(self.view)
            self.moveToWelcome()
        })
    }
    
    func moveToWelcome(){
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "welcome") as? WelcomeViewController
        self.show(controller!, sender: nil)
        
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
