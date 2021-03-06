//
//  ContactUsViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 31/07/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit
import MessageUI
import BluedolphinCloudSdk
import RealmSwift

class ContactUsViewController: UIViewController {

    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var sendMessage: UIButton!
    @IBOutlet weak var contactTableview: UITableView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    fileprivate var organizationName : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getOrganisationName()
        navigationController?.removeTransparency()
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.title = "Contact Us"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: APPFONT.DAYHEADER!]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(menuAction(sender:)))
       
        
        helloLabel.font = APPFONT.DAYHEADER
        messageLabel.text = "Your Message"
        messageLabel.font = APPFONT.DAYHEADER
        introLabel.text = "Drop us a line in case you are facing any issues, we'd love to help you out"
        introLabel.numberOfLines = 0
        introLabel.font = APPFONT.MESSAGEHELPTEXT
        introLabel.lineBreakMode = .byWordWrapping
        contactTableview.delegate = self
        contactTableview.dataSource = self
       // contactTableview.allowsSelection = false
        contactTableview.separatorStyle = .none
        
        messageTextView.layer.borderColor = APPColor.blueGradient.cgColor
        messageTextView.layer.borderWidth = 1.0;
        messageTextView.layer.cornerRadius = 5.0;
        sendMessage.addTarget(self, action: #selector(sendMail), for: .touchUpInside)
        
        contactTableview.estimatedRowHeight = 100

        // Do any additional setup after loading the view.
    }
    
    func getOrganisationName(){
        let realm = try! Realm()
        if let tokenData = realm.objects(AccessTokenObject.self).filter("organizationId = %@",SDKSingleton.sharedInstance.organizationId).first {
            organizationName = tokenData.organizationName!
        }
    }
    
    
    @objc func menuAction(sender:UIBarButtonItem){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowSideMenu"), object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func sendMail(){
        if messageTextView.text.isBlank {
            self.showAlert("Please enter your message")
        }else{
            if( MFMailComposeViewController.canSendMail() ) {
                
                let mailComposer = MFMailComposeViewController()
                mailComposer.mailComposeDelegate = self
                if supportEmail.isBlank {
                    //mailComposer.setToRecipients([(workdict?.emailId)!])
                }else{
                    mailComposer.setToRecipients([supportEmail])
                }
                
                //Set the subject and message of the email
                mailComposer.setSubject("BD Field Force (iOS) v" + APPVERSION + ":Contact Us")
                _ = SDKSingleton.sharedInstance.organizationId
                let message1 = "Username: " + SDKSingleton.sharedInstance.userName
                let orgName = "\n" + "Organization Name: " + organizationName
                let message2 = "\n" + "Contact Number: " + SDKSingleton.sharedInstance.mobileNumber
                let message3 = "\n" + "Device Details:  " + UIDevice.current.modelName +  " iOS \(UIDevice.current.systemVersion)"
                let message4 = "\n" + "Message: \n" + messageTextView.text
                
                mailComposer.setMessageBody(message1 + orgName + message2 + message3 + message4, isHTML: false)
                
                
                self.present(mailComposer, animated: true, completion: nil)
            }
        }
        
        //}
        
    }
    
    func addressAction(){
        let googlePath = "http://maps.google.com/maps"
        let googleApp =  "comgooglemaps://"
        let query = "?q=" + "Rare Media Company, New Delhi, Delhi"
        //let applePath = "http://maps.apple.com/"
        
        
        if UIApplication.shared.canOpenURL(URL(string: googleApp)!)
        {
            if let url = URL(string: googleApp + query.stringByAddingPercentEncodingForRFC3986()!) {
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }
            
        } else {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: googlePath + query.stringByAddingPercentEncodingForRFC3986()!)!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
    func callAction(){
        let phoneCallURL:URL = URL(string: "tel://\(supportContactNumber)")!
        let application:UIApplication = UIApplication.shared
        if (application.canOpenURL(phoneCallURL)) {
            //application.openURL(phoneCallURL);
            if #available(iOS 10.0, *) {
                application.open(phoneCallURL, options: [:], completionHandler: { (success) in
                    if success {
                        print("call")
                    }
                })
            } else {
                // Fallback on earlier versions
            }
        }
        else {
            self.showAlert("Your device is not compatible to call.")
        }
    }
    
    
    func callAlertView() {
        
        let alertString =  "Carrier charges may apply. Are  you sure you want to call ?"
        showAlertView(alertString, yesAction: callAction)
        
    }
    func showAlertView(_ alertmessage:String,yesAction: @escaping ()->Void) {
        let alert=UIAlertController(title: "Alert", message:alertmessage, preferredStyle: .alert);
        //default input textField (no configuration...)
        //no event handler (just close dialog box)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil));
        //event handler with closure
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(action:UIAlertAction) in
            yesAction()
        }));
        self.present(alert, animated: true, completion: nil);
        
    }
    func showAlert(_ message : String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            return        }
        alertController.addAction(OkAction)
        self.present(alertController, animated: true) {
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
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
extension ContactUsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath as IndexPath) as! ContactTableViewCell
        cell.contactButton.textColor = APPColor.blueGradient
       // cell.contactButton.setTitleColor(APPColor.blueGradient, for: .normal)
       
       // cell.contactButton.titleLabel?.adjustsFontSizeToFitWidth = true
        cell.headerLabel.font = APPFONT.DAYHEADER
        
        switch indexPath.row {
        case 0:
            cell.headerLabel.text = "Let's talk on the phone"
            cell.contactButton.text = supportContactNumber
            //cell.contactButton.setTitle(supportContactNumber, for: UIControlState.normal)
            cell.contactImageView.image = #imageLiteral(resourceName: "phone")
          //  cell.contactButton.addTarget(self, action: #selector(callAlertView), for: UIControlEvents.touchUpInside)
        case 1:
            cell.headerLabel.text = "We'd love for you to visit us"
            cell.contactImageView.image = #imageLiteral(resourceName: "location")
            cell.contactButton.text = supportAddress
           // cell.contactButton.setTitle(supportAddress, for: UIControlState.normal)
           // cell.contactButton.addTarget(self, action: #selector(addressAction), for: UIControlEvents.touchUpInside)
        default:
            break
        }
       // cell.contactButton.centerTextAndImage(spacing: 2.0)
        return cell
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.item {
        case 0:
            callAlertView()
        default:
            addressAction()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ContactUsViewController:MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .sent:
            messageTextView.text = ""
        case .cancelled,.failed,.saved:
            //self.showAlert("Transfer")
            break
            
        
        }
        dismiss(animated: true, completion: nil)
    }
}

