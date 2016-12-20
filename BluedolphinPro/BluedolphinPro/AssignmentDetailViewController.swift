//
//  AssignmentDetailViewController.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 29/11/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import UIKit
import MessageUI

class AssignmentDetailViewController: UIViewController {
    var viewPager:ViewPagerControl!
    var tabView:ViewPagerControl!
    
    
   
    var timeLineTableArray = ["OutGoingCall","Image Captured","Assignment Started"]
    
    @IBOutlet weak var instructionLabelHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var timeLineTableView: UITableView!
    
    @IBOutlet weak var startTimeLabel: UILabel!
    
    @IBOutlet weak var endTimeLabel: UILabel!
   
    @IBOutlet weak var addressButton: UIButton!
    
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactNumberButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    
    @IBOutlet weak var instructionLabel: UILabel!
    var assignment : RMCAssignmentObject?
    var alertTextfield = UITextField()
    fileprivate var albumName:String = "BluedolphinPro"
    var customAlbum :CustomPhotoAlbum?
    
    @IBOutlet weak var imageLabel: UILabel!
    
    @IBOutlet weak var galleryView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        createTabbarView()
        createViewPager()
        createLayout()
        
        timeLineTableView.delegate = self
        timeLineTableView.dataSource = self
        timeLineTableView.isHidden = true
        let saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(AssignmentDetailViewController.saveAction(_:)))
        self.navigationItem.rightBarButtonItem = saveButton
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0, green: 0.5694751143, blue: 1, alpha: 1)
        self.navigationItem.backBarButtonItem?.style = .plain
        
        contactNumberButton.addTarget(self, action: #selector(AssignmentDetailViewController.callAlertView), for: UIControlEvents.touchUpInside)
        emailButton.addTarget(self, action: #selector(AssignmentDetailViewController.mailAction), for: UIControlEvents.touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
        galleryView.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
    func tapBlurButton(_ sender: UITapGestureRecognizer) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "PhotoViewController") as?
        PhotoViewController
        self.navigationController?.show(controller!, sender: nil)
    }
    func saveAction(_:UIButton){
        
    }
    
    func createTabbarView(){
        let image1 = ["notes","attachments","signature"]
        let image2 = ["notes","attachments","signature"]
        tabView = ViewPagerControl(images: image2, selectedImage: image1)
        //ViewPagerControl(items: data)
        tabView.type = .image
        tabView.frame = CGRect(x: 0, y: ScreenConstant.height - 114, width: ScreenConstant.width, height: 50)
        
        
        tabView.selectionIndicatorColor = UIColor.white
        //tabView.showSelectionIndication = false
        self.view.addSubview(tabView)
        
        tabView.indexChangedHandler = { index in
            
            self.tabChanger(segment: index)
            
        }
        
    }
    func createViewPager(){
        let data = ["General","History"]
        viewPager = ViewPagerControl(items: data)
        viewPager.type = .text
        viewPager.frame = CGRect(x: 0, y: 0
            , width: ScreenConstant.width, height: 40)
        viewPager.isHighlighted = true
        viewPager.selectionIndicatorColor = #colorLiteral(red: 0, green: 0.5694751143, blue: 1, alpha: 1)
        viewPager.selectionIndicatorHeight = 2
        viewPager.titleTextAttributes = [
            NSForegroundColorAttributeName : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
            NSFontAttributeName : UIFont(name: "SourceSansPro-Regular", size: 13)!
        ]
        
        viewPager.selectedTitleTextAttributes = [
            NSForegroundColorAttributeName : #colorLiteral(red: 0, green: 0.5694751143, blue: 1, alpha: 1),
            NSFontAttributeName : UIFont(name: "SourceSansPro-Regular", size: 13)!
        ]
        self.view.addSubview(viewPager)
        viewPager.setSelectedSegmentIndex(0, animated: false)
        viewPager.indexChangedHandler = { index in
            
            self.segmentControl(index: index)
            
        }
    }
    
    
    
    
    func segmentControl(index:Int){
        switch(index){
        case 0:
            timeLineTableView.isHidden = true
        case 1:
            timeLineTableView.isHidden = false
        default:
            break

        }
    }
    
    
    func tabChanger(segment:Int){
        switch segment {
        case 0:
            let navController = self.storyboard?.instantiateViewController(withIdentifier: "notesScreen") as! UINavigationController
           let controller = navController.topViewController as! AddNotesViewController
            controller.assignment = assignment
            self.present(navController, animated: true, completion: nil)
        case 1:
            showActionSheet()
            
        case 2:
            let navController = self.storyboard?.instantiateViewController(withIdentifier: "signatureScreen") as! UINavigationController
            let controller = navController.topViewController as! SignatureViewController
           controller.assignment = assignment
            self.present(navController, animated: true, completion: nil)
            
        default:
            break
        }
    }
    
    func createLayout(){
        if let assignmentdetail = assignment?.assignmentDetails?.parseJSONString as? NSDictionary{
            
            if let mobile = assignmentdetail["mobile"] as? String{
                contactNumberButton.setTitle(mobile, for: UIControlState.normal)
            }
            if let email = assignmentdetail["email"] as? String{
                emailButton.setTitle(email, for: UIControlState.normal)
            }

            if let contactPerson = assignmentdetail["contactPerson"] as? String{
                contactNameLabel.text = contactPerson
            }

            if let instructions = assignmentdetail["instructions"] as? String{
                instructionLabel.text = instructions
                instructionLabel.resizeHeightToFit(heightConstraint:instructionLabelHeightConstraint )
            }
            
                
            
        }
        if let startTime = assignment?.assignmentStartTime {
            startTimeLabel.text = "Start:" + startTime.asDate.formatted
        }
        if let jobNumber = assignment?.jobNumber{
            self.navigationItem.title = jobNumber
            albumName = jobNumber
            customAlbum = CustomPhotoAlbum(name: albumName)
        }

        if let endtime = assignment?.assignmentDeadline {
            endTimeLabel.text = "End: " + endtime.asDate.formatted
        }
        if let address = assignment?.assignmentAddress{
            addressButton.setTitle(address, for: UIControlState.normal)
        }

    }
    
    
    func showActionSheet(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let sendButton = UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            self.btnCamera()
        })
        
        let  deleteButton = UIAlertAction(title: "Document", style: .default, handler: { (action) -> Void in
            print("Delete button tapped")
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            //self.tabView.
        })
        
        
        alertController.addAction(sendButton)
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
        
    }
    

    func callAlertView() {
        
        let alertString =  "Carrier charges may apply Are  you sure you want to call"
        showAlertView(alertString, yesAction: callAction)
        
    }
    func showAlertView(_ alertmessage:String,yesAction: @escaping ()->Void) {
        let alert=UIAlertController(title: "Alert", message:alertmessage, preferredStyle: UIAlertControllerStyle.alert);
        //default input textField (no configuration...)
        //no event handler (just close dialog box)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil));
        //event handler with closure
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
            yesAction()
        }));
       self.present(alert, animated: true, completion: nil);
        
    }
    func showAlert(_ message : String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (action) in
            return        }
        alertController.addAction(OkAction)
        self.present(alertController, animated: true) {
        }
    }
    
    
    func callAction(){
        if let assignmentdetail = assignment?.assignmentDetails?.parseJSONString as? NSDictionary{
        if let number = assignmentdetail["mobile"] as? String{
            print(number)
            let phoneCallURL:URL = URL(string: "tel://\(number)")!
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                //application.openURL(phoneCallURL);
                application.open(phoneCallURL, options: [:], completionHandler: { (success) in
                    if success {
                        print("call")
                    }
                })
            }
            else {
                self.showAlert("Your device is not compatible to call.")
            }
            
        }
        }
    }
    
    func mailAction(){
        //        if workdict!.emailId!.isBlank {
        //            self.showAlert("No email available")
        //        } else {
        if let assignmentdetail = assignment?.assignmentDetails?.parseJSONString as? NSDictionary{
        if let email = assignmentdetail["email"] as? String{
        if( MFMailComposeViewController.canSendMail() ) {
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            if email.isBlank {
                //mailComposer.setToRecipients([(workdict?.emailId)!])
            }else{
                mailComposer.setToRecipients([email])
            }
            
            //Set the subject and message of the email
            //mailComposer.setSubject("Have you heard a swift?")
            //mailComposer.setMessageBody("This is what they sound like.", isHTML: false)
            
            
            self.present(mailComposer, animated: true, completion: nil)
        }
        //}
        
        }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
}


extension AssignmentDetailViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return timeLineTableArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "timeLineCell") as! TimeLineTableViewCell
            cell.taskTitleLabel.text = timeLineTableArray[indexPath.row]
            cell.taskImageView.image = UIImage(named: "bookmark")
            cell.taskTimeLabel.text = "11/11/16 21:30"
            if indexPath.row == 0{
                cell.upLineView.isHidden = true
                cell.downLineView.isHidden = false
                
            }else if indexPath.row == timeLineTableArray.count - 1 {
                cell.upLineView.isHidden = false
               cell.downLineView.isHidden = true
            }else{
                cell.upLineView.isHidden = false
                cell.downLineView.isHidden = false
            }
            return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "showDetails", sender: self)
        
    }
    
    
    
    
}


extension AssignmentDetailViewController :UINavigationControllerDelegate,UIImagePickerControllerDelegate {
        func btnCamera() {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            //load the camera interface
            let picker : UIImagePickerController = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.delegate = self
            picker.allowsEditing = false
            self.present(picker, animated: true, completion: nil)
        }else{
            //no camera available
            let alert = UIAlertController(title: "Error", message: "There is no camera available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: {(alertAction)in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image: UIImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            DispatchQueue.main.async(execute: {
                // NSLog("Adding Image to Library -> %@", (success ? "Sucess":"Error!"))
                picker.dismiss(animated: true, completion: nil)
                self.showTextfieldAlert(image)
                
            })
            //Implement if allowing user to edit the selected image
            //let editedImage = info.objectForKey("UIImagePickerControllerEditedImage") as UIImage
            
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    //Textfield Alert
    func configurationTextField(_ textField: UITextField!)
    {
        print("configurat hire the TextField")
        
        if let tField = textField {
            
            self.alertTextfield = tField        //Save reference to the UITextField
            self.alertTextfield.placeholder = "Enter photoName"
        }
    }
    
    
    func handleCancel(_ alertView: UIAlertAction!)
    {
        print("User click Cancel button")
        print(self.alertTextfield.text!)
    }
    
    func showTextfieldAlert(_ image:UIImage){
        let alert = UIAlertController(title: "Image Name", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField(configurationHandler: configurationTextField)
        
        alert.addAction(UIAlertAction(title: "Discard", style: UIAlertActionStyle.cancel, handler:handleCancel))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
            print("User click Ok button")
            print(self.alertTextfield.text!)
            if self.alertTextfield.text!.isBlank {
                //self.customAlbum!.
//                let manager = AWSS3Manager()
//                manager.configAwsManager()
//                manager.sendFile(imageName : "NoName" + Date().formattedISO8601, image: image, extention: "jpg")
                //self.saveImage(image, name:"NoName")
            }else {
                //print( self.customAlbum!.updatePhoto(image))
//                let manager = AWSS3Manager()
//                manager.configAwsManager()
//                manager.sendFile(imageName : self.alertTextfield.text! + Date().formattedISO8601, image: image, extention: "jpg")
                //self.saveImage(image, name: self.alertTextfield.text!)
                
            }
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
}
extension AssignmentDetailViewController:MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}

