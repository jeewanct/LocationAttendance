//
//  SideMenuViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 22/06/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController  {
        
        @IBOutlet weak var sideMenuTable: UITableView!
        @IBOutlet weak var userNameLabel: UILabel!
        @IBOutlet weak var userImageView: UIImageView!
        var sideMenuOptionsArray =  ["My Dashboard"]

        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.applyGradient(isTopBottom: true, colorArray: [APPColor.BlueGradient,APPColor.GreenGradient])
            let tapGestureForImage = UITapGestureRecognizer(target: self, action: #selector(SideMenuViewController.handleTap(sender:)))
            let tapGestureForLabel = UITapGestureRecognizer(target: self, action: #selector(SideMenuViewController.handleTap(sender:)))
                userImageView.isUserInteractionEnabled = true
                userNameLabel.isUserInteractionEnabled = true
                userNameLabel.addGestureRecognizer(tapGestureForLabel)
                userImageView.addGestureRecognizer(tapGestureForImage)
    
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
        cell.imageView?.image = UIImage()
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.textAlignment = NSTextAlignment.left
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
        
        default: print("")
            
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView(frame: CGRect.zero)
    }
    
}
