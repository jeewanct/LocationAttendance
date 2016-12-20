//
//  SignatureViewController.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 13/12/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import UIKit

class SignatureViewController: UIViewController {

    @IBOutlet weak var signatureView: ScratchPad!
    @IBOutlet weak var signatureImageView: UIImageView!
    @IBOutlet weak var noSignatureLabel: UILabel!
     var assignment : RMCAssignmentObject?
    fileprivate var albumName:String = "BluedolphinPro"
    var customAlbum :CustomPhotoAlbum?
    override func viewDidLoad() {
        super.viewDidLoad()
        noSignatureLabel.isHidden = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(AddNotesViewController.cancelPressed(_:)))
        if let assignmentdetail = assignment?.assignmentDetails?.parseJSONString as? NSDictionary{
            if let jobNumber = assignmentdetail["jobNumber"] as? String{
                self.navigationItem.title = jobNumber
                albumName = jobNumber
            }
        }
        customAlbum = CustomPhotoAlbum(name: albumName)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(SignatureViewController.saveAction(_:)))
//        if workdictHolder?.jobStatus == JobStatus.CompleteStatus.rawValue{
//            navigationItem.rightBarButtonItem = nil
//            imgView.isHidden = false
//            displayPhoto()
//            
//        }
//        else {
            navigationItem.rightBarButtonItem = saveButton
            signatureImageView.isHidden = true
        //}
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 104/255, green: 168/255, blue: 220/25, alpha: 1)
        //self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    }


    @IBAction func signatureClearAction(_ sender: Any) {
        self.signatureView.clearSignature()
    }
    
    
    func cancelPressed(_:UIButton){
        self.dismiss(animated: true, completion: nil)
        
    }
    func saveAction(_ sender: AnyObject) {
        if self.signatureView.containsSignature {
            if let signatureImage = self.signatureView.getSignature() {
                
                
//                let manager = AWSS3Manager()
//                manager.configAwsManager()
//                manager.sendFile(imageName : "Signature" + Date().formattedISO8601, image: signatureImage, extention: "jpg")
               //print(customAlbum!.updatePhoto(signatureImage))
                customAlbum?.updatePhoto(signatureImage, completion: { (data) in
                    DispatchQueue.main.async {
                        self.postCheckin(imageId:data)
                    }

                    
                })
//                showLoader()
//                createCheckin(signatureImage)
                // Since the Signature is now saved to the Photo Roll, the View can be cleared anyway.
                self.signatureView.clearSignature()
            }
        }
        else {
            self.showAlert("No Signature is available")
        }
    }
    
    
    func showAlert(_ message : String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (action) in
            return        }
        alertController.addAction(OkAction)
        self.present(alertController, animated: true) {
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
    
    func postCheckin(imageId:String){
        
        let checkin = CheckinHolder()
        
        checkin.checkinDetails = [AssignmentWork.JobNumber.rawValue:albumName as AnyObject]
        checkin.checkinCategory = CheckinCategory.NonTransient.rawValue
        checkin.checkinType = CheckinType.PhotCheckin.rawValue
        checkin.assignmentId = assignment?.assignmentId
        checkin.imageName = albumName + ".Signature"
        checkin.relativeUrl = imageId
        let checkinModelObject = CheckinModel()
        checkinModelObject.createCheckin(checkinData: checkin)
        //checkinModelObject.postCheckin()
        let assignmentModel = AssignmentModel()
        assignmentModel.updateAssignment(id:(assignment?.assignmentId)! , type: AssignmentWork.Signature, value: imageId, status: CheckinType.Inprogress)
        
    }

}

extension SignatureViewController :ScratchPadDelegate {
    func finishedSignatureDrawing() {
        print("Finished")
    }
    
    func startedSignatureDrawing() {
        print("Started")
    }
}
