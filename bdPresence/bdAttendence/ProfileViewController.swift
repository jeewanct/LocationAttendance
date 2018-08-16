//
//  ProfileViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 16/08/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit
import BluedolphinCloudSdk
import RealmSwift

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    var organisationName = String()
    var tapGestureForImage = UITapGestureRecognizer()
    var picker:UIImagePickerController? = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        getOrganisationName()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.title = "My Profile"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: APPFONT.DAYHEADER!]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu")?.withRenderingMode(.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(menuAction(sender:)))
        profileImageView.isUserInteractionEnabled = true
        tapGestureForImage = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        profileImageView.addGestureRecognizer(tapGestureForImage)
        profileImageView.layer.cornerRadius = 50
        profileImageView.layer.borderWidth = 0.5
        profileImageView.layer.borderColor = UIColor.gray.cgColor
        if let imageData = UserDefaults.standard.value(forKey: "profileImage") as? Data {
            profileImageView.image = UIImage(data: imageData)!
        }
        
        self.userNameLabel.text = SDKSingleton.sharedInstance.userName.capitalized
        self.userNameLabel.font = APPFONT.PROFILEHEADER
        profileTableView.delegate = self
        profileTableView.dataSource = self
        
        profileTableView.tableFooterView = UIView()
        
        profileTableView.register(UINib(nibName: "TwoSideLabelTableViewCell", bundle: nil), forCellReuseIdentifier: "twoLabel")
        profileTableView.register(UINib(nibName: "SwitchTableViewCell", bundle: nil), forCellReuseIdentifier: "switch")
        
        profileTableView.register(UINib(nibName: "LabelWithImage", bundle: nil), forCellReuseIdentifier: "twoLabelWithImage")
        
        
        self.profileTableView.estimatedRowHeight =  50
        self.profileTableView.rowHeight = UITableViewAutomaticDimension;
       
        
        //addPullUpController()
        // Do any additional setup after loading the view.
    }
    func getOrganisationName(){
        let realm = try! Realm()
        if let tokenData = realm.objects(AccessTokenObject.self).filter("organizationId = %@",SDKSingleton.sharedInstance.organizationId).first {
            organisationName = tokenData.organizationName!
        }
    }
    func menuAction(sender:UIBarButtonItem){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowSideMenu"), object: nil)
        
    }
    
   
    
    func handleTap(sender : UITapGestureRecognizer) {
        
        if sender.view == profileImageView {
            self.picker?.allowsEditing = true
            self.picker?.delegate = self
            self.picker?.modalPresentationStyle = .overCurrentContext
            
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            let openGallaryAction = UIAlertAction(title:"Choose from existing", style: UIAlertActionStyle.default) { (action) in
                self.picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
                
                self.present(self.picker!, animated: true, completion: nil)
                return
            }
            
            let openCameraAction  = UIAlertAction(title:"Take a new photo", style: UIAlertActionStyle.default) { (action) in
                if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
                    
                    self.picker!.sourceType = UIImagePickerControllerSourceType.camera
                    self.present(self.picker!, animated: true, completion: nil)
                    
                } else {
                    
                    //self .showAlert("Device has no camera")
                }
                return
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) { (action) in
                return
            }
            alertController.addAction(openGallaryAction)
            alertController.addAction(openCameraAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true) {
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDateInAMPM(date:Date)->String{
        print(date)
        let timeFormatter = DateFormatter()
        //timeFormatter.dateStyle = .none
        
        timeFormatter.dateFormat = "hh:mm a"
        return timeFormatter.string(from:date)
        
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

extension ProfileViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var newcell = UITableViewCell()
        
        switch indexPath.row {
        case 0:
            let  cell = tableView.dequeueReusableCell(withIdentifier: "twoLabel", for: indexPath as IndexPath) as! TwoSideLabelTableViewCell
            cell.headingLabel.font = APPFONT.HELPTEXT
            cell.headingLabel.textColor = UIColor(hex: "333333")
            cell.valueLabel.textColor =  UIColor(hex: "a9a9a9")
            cell.valueLabel.font = APPFONT.HELPTEXT
            cell.headingLabel.text = "Status"
            cell.valueLabel.text = "Available"
            cell.setDisclosure(toColour: APPColor.blueGradient)
            return cell
        case 1:
            
            let  cell = tableView.dequeueReusableCell(withIdentifier: "twoLabel", for: indexPath as IndexPath) as! TwoSideLabelTableViewCell
            cell.headingLabel.textColor = UIColor(hex: "333333")
            cell.valueLabel.textColor =  UIColor(hex: "a9a9a9")
            cell.headingLabel.font = APPFONT.HELPTEXT
            cell.valueLabel.font = APPFONT.HELPTEXT
            cell.headingLabel.text = "Organization"
            cell.valueLabel.text = organisationName.capitalized
            cell.setDisclosure(toColour: APPColor.blueGradient)
            return cell
        case 2:
            let  cell = tableView.dequeueReusableCell(withIdentifier: "twoLabel", for: indexPath as IndexPath) as! TwoSideLabelTableViewCell
            cell.headingLabel.textColor = UIColor(hex: "333333")
            cell.valueLabel.textColor =  UIColor(hex: "a9a9a9")
            cell.headingLabel.font = APPFONT.HELPTEXT
            cell.valueLabel.font = APPFONT.HELPTEXT
            cell.headingLabel.text = "Shift-Timing"
            let shiftDetails = ShiftHandling.getShiftDetail()
            let startDate = Date().dateAt(hours: shiftDetails.0, minutes: shiftDetails.1)
            let endDate = Date().dateAt(hours: shiftDetails.2, minutes: shiftDetails.3)
            cell.valueLabel.text = "\(getDateInAMPM(date: startDate!)) -  \(getDateInAMPM(date: endDate!))"
            cell.setDisclosure(toColour: APPColor.blueGradient)
            return cell
//        case 3:
//            let cell =  tableView.dequeueReusableCell(withIdentifier: "switch", for: indexPath as IndexPath) as! SwitchTableViewCell
//            cell.headerLabel.textColor = UIColor(hex: "333333")
//
//            cell.headerLabel.font = APPFONT.HELPTEXT
//            cell.headerLabel.text = "Notification"
//
//            return cell
//
//        case 4:
//            let cell =  tableView.dequeueReusableCell(withIdentifier: "twoLabelWithImage", for: indexPath as IndexPath) as! LabelWithImage
//            cell.headerLabel.textColor = UIColor(hex: "333333")
//            cell.headerLabel.font = APPFONT.HELPTEXT
//            cell.headerLabel.text = "Logout"
//            return cell
        default:
            break
        }
        return newcell
        
        
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
}

extension ProfileViewController :UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let pickedImage  = info[UIImagePickerControllerEditedImage] as! UIImage
        profileImageView.image = pickedImage
        UserDefaults.standard.set(UIImageJPEGRepresentation(pickedImage, 100), forKey: "profileImage")
        UserDefaults.standard.synchronize()
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
        
        
    }
}
