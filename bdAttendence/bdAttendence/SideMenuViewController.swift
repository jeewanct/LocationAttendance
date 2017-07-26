//
//  SideMenuViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 22/06/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit
import BluedolphinCloudSdk

class SideMenuViewController: UIViewController  {
        
    @IBOutlet weak var versionLabel: UILabel!
        @IBOutlet weak var sideMenuTable: UITableView!
        @IBOutlet weak var userNameLabel: UILabel!
        @IBOutlet weak var userImageView: UIImageView!
        var sideMenuOptionsArray =  ["My Dashboard","System Detail","This Week","Transmit"]

        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.applyGradient(isTopBottom: true, colorArray: [APPColor.BlueGradient,APPColor.GreenGradient])
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
                versionLabel.text = "V" + APPVERSION
                versionLabel.textAlignment = .center
            }
    
            //println(userData)
            
            
            // Do any additional setup after loading the view.
    
        
    
        func handleTap(sender : UITapGestureRecognizer) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MyProfile"), object: nil)
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
        //cell.imageView?.image = UIImage()
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = APPFONT.MENUTEXT
        cell.textLabel?.textAlignment = NSTextAlignment.center
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
        return tableView.frame.height / 7
    }
    
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath)
        cell!.contentView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath)
        cell!.textLabel?.textColor = UIColor.white
        cell?.contentView.backgroundColor = UIColor.clear
        cell?.backgroundColor = UIColor.clear
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        switch (indexPath.row)
        {
        case 0:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.Dashboard.rawValue), object: self, userInfo: nil)
        case 1:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.SystemDetail.rawValue), object: self, userInfo: nil)
        case 2:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.ThisWeek.rawValue), object: self, userInfo: nil)
        case 3:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.VirtualBeacon.rawValue), object: self, userInfo: nil)
            break
        default:
            break
            
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView(frame: CGRect.zero)
    }
    
}
