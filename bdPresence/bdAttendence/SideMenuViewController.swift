//
//  SideMenuViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 22/06/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit
import BluedolphinCloudSdk

protocol SideMenuDelegate {
    func updateMenu()
}
class SideMenuViewController: UIViewController  {
        
    @IBOutlet weak var versionLabel: UILabel!
        @IBOutlet weak var sideMenuTable: UITableView!
        @IBOutlet weak var userNameLabel: UILabel!
        @IBOutlet weak var userImageView: UIImageView!
        var menuindex = 0
    
        var sideMenuOptionsArray = [SideMenuOptions.MyDashboard.rawValue,SideMenuOptions.HistoricData.rawValue, SideMenuOptions.MyTeam.rawValue,SideMenuOptions.Locations.rawValue,SideMenuOptions.MyProfile.rawValue,SideMenuOptions.SystemDetail.rawValue,SideMenuOptions.ContactUs.rawValue]
    
        override func viewDidLoad() {
            super.viewDidLoad()
            if !SDKSingleton.sharedInstance.transmitter{
               //sideMenuOptionsArray.remove(at: sideMenuOptionsArray.index(of: SideMenuOptions.Transmit.rawValue)!)

            }

            if SDKSingleton.sharedInstance.userType == "Field-Executive"{
                sideMenuOptionsArray.remove(at: 2)
                sideMenuTable.reloadData()
            }
            
            userImageView.layer.cornerRadius = 30
            self.view.applyGradient(isTopBottom: true, colorArray: [APPColor.GreenGradient, APPColor.BlueGradient])
            
            
            let tapGestureForImage = UITapGestureRecognizer(target: self, action: #selector(SideMenuViewController.handleTap(sender:)))
            let tapGestureForLabel = UITapGestureRecognizer(target: self, action: #selector(SideMenuViewController.handleTap(sender:)))
                userImageView.isUserInteractionEnabled = true
                userNameLabel.isUserInteractionEnabled = true
                userNameLabel.addGestureRecognizer(tapGestureForLabel)
                userImageView.addGestureRecognizer(tapGestureForImage)
                userNameLabel.text = SDKSingleton.sharedInstance.userName.capitalized
                userNameLabel.textColor = UIColor.white
                userNameLabel.font = APPFONT.MENUTEXT
                versionLabel.textColor = UIColor.white
                versionLabel.font = APPFONT.VERSIONTEXT

                switch(ReleaseType.currentConfiguration()) {
                case .Alpha:
                    versionLabel.text = "V" + APPVERSION + "ALPHA"
                
                case .Unknown:
                    versionLabel.text = "V" + APPVERSION
                case .Debug:
                    versionLabel.text = "V" + APPVERSION

                case .Release:
                    versionLabel.text = "V" + APPVERSION

            }
                versionLabel.textAlignment = .center
            
            UserDefaults.standard.addObserver(self, forKeyPath: "profileImage", options: .new, context: nil)
            }
    
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "profileImage" {
            if let imageData = UserDefaults.standard.value(forKey: "profileImage") as? Data {
                userImageView.image = UIImage(data: imageData)!
            }
        }
    }
    
    deinit {
        UserDefaults.standard.removeObserver(self, forKeyPath: "profileImage")
    }
            // Do any additional setup after loading the view.
    
        
    
        func handleTap(sender : UITapGestureRecognizer) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MyProfile"), object: nil)
        }
    
    override func viewDidAppear(_ animated: Bool) {
        if let imageData = UserDefaults.standard.value(forKey: "profileImage") as? Data {
            userImageView.image = UIImage(data: imageData)!
        }
        let indexPath = IndexPath(row: menuindex, section: 0)
        self.tableView(sideMenuTable, didSelectRowAt: indexPath)
        sideMenuTable.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.bottom)
       
    }
    

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
    
}
extension SideMenuViewController:UITableViewDataSource, UITableViewDelegate {
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        
        cell.textLabel!.text = sideMenuOptionsArray[indexPath.row]
        cell.imageView?.image = UIImage()
        cell.selectionStyle = .gray
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = APPFONT.MENUTEXT
        cell.textLabel?.textAlignment = NSTextAlignment.left
        let selectedview = UIView()
        selectedview.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        cell.selectedBackgroundView = selectedview
        return cell
    }

    
   
    func numberOfSectionsInTableView(tableView: UITableView) ->Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideMenuOptionsArray.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 49
    }
    
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath as IndexPath)
//        cell!.contentView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
//        
//    }
//    
//    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath as IndexPath)
//        cell!.textLabel?.textColor = UIColor.white
//        
//        cell?.contentView.backgroundColor = UIColor.clear
//        cell?.backgroundColor = UIColor.clear
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        menuindex = indexPath.row
        let option = sideMenuOptionsArray[indexPath.row]
        
        switch (option)
        {
        case SideMenuOptions.MyDashboard.rawValue:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.Dashboard.rawValue), object: self, userInfo: nil)
        case SideMenuOptions.HistoricData.rawValue:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.ThisWeek.rawValue), object: self, userInfo: nil)
        case SideMenuOptions.SystemDetail.rawValue:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.SystemDetail.rawValue), object: self, userInfo: nil)
        case SideMenuOptions.MyProfile.rawValue:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MyProfile"), object: nil)
            
        case SideMenuOptions.Locations.rawValue:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.MyLocation.rawValue), object: self, userInfo: nil)
        case SideMenuOptions.MyTeam.rawValue:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.MyTeam.rawValue), object: self, userInfo: nil)
//        case SideMenuOptions.ThisWeek.rawValue:
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.ThisWeek.rawValue), object: self, userInfo: nil)
      case SideMenuOptions.ContactUs.rawValue :
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.ContactUs.rawValue), object: self, userInfo: nil)
//        case SideMenuOptions.Transmit.rawValue:
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.VirtualBeacon.rawValue), object: self, userInfo: nil)
            break
        default:
            break
            
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView(frame: CGRect.zero)
    }
    
}
//extension SideMenuViewController:SideMenuDelegate{
//    func updateMenu() {
//        if let imageData = UserDefaults.standard.value(forKey: "profileImage") as? Data {
//            userImageView.image = UIImage(data: imageData)!
//        }
//    }
//}
