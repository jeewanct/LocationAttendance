//
//  SideMenu.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 31/07/17.
//  Copyright © 2017 raremediacompany. All rights reserved.
//

import Foundation


func createNavView(controller:UIViewController,title:String){
    let items = ["My DashBoard", "Assignments", "Profile","Drafts"]
    
    controller.navigationController?.navigationBar.isTranslucent = false
    controller.navigationController?.navigationBar.barTintColor = UIColor.white
    //UIColor(red: 0.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
    controller.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
    
   let menuView = CustomNavigationDropdownMenu(navigationController: controller.navigationController, containerView: controller.navigationController!.view, title: title, items: items as [AnyObject])
    menuView.cellHeight = 50
    menuView.cellBackgroundColor = controller.navigationController?.navigationBar.barTintColor
    
    menuView.cellSelectionColor = UIColor.white
    //UIColor(red: 0.0/255.0, green:160.0/255.0, blue:195.0/255.0, alpha: 1.0)
    menuView.shouldKeepSelectedCellColor = true
    menuView.cellTextLabelColor = UIColor.black
    menuView.cellTextLabelFont = UIFont(name: "SourceSansPro-Regular", size: 17)
    menuView.cellTextLabelAlignment = .left // .Center // .Right // .Left
    menuView.arrowPadding = 15
    menuView.animationDuration = 0.3
    menuView.maskBackgroundColor = UIColor.black
    menuView.maskBackgroundOpacity = 0.3
    menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
        print("Did select item at index: \(indexPath)")
        menuChanger(segment: indexPath)
        
    }
    
    controller.navigationItem.titleView = menuView
}

func menuChanger(segment:Int){
    switch segment {
    case 0:
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: LocalNotifcation.BaseAnalytics.rawValue) , object: nil)
    case 1:
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: LocalNotifcation.Assignment.rawValue) , object: nil)
        
    case 2:
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: LocalNotifcation.Profile.rawValue) , object: nil)

    case 3:
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: LocalNotifcation.Draft.rawValue) , object: nil)
//    case 4:
//        NotificationCenter.default.post(name:NSNotification.Name(rawValue: LocalNotifcation.VirtualBeacon.rawValue) , object: nil)
//    case 5:
//        NotificationCenter.default.post(name:NSNotification.Name(rawValue: LocalNotifcation.Attendance.rawValue) , object: nil)
        
    default:
        break
    }
}
    
