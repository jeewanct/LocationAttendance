//
//  BaseAnalticsViewController.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 20/03/17.
//  Copyright © 2017 raremediacompany. All rights reserved.
//

import UIKit

func getDateFromcomponent(day:Int,month:Int,year:Int)->(date:Date,weekday:String){
    var component = DateComponents()
    component.day = day
    component.month = month
    component.year = year
    component.timeZone = TimeZone(abbreviation: "UTC")
    let date = Calendar.current.date(from: component)
    return (date!,date!.dayOfWeek()!)
    
}
class BaseAnalticsViewController: UIViewController {
    var menuView: CustomNavigationDropdownMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavView()
        let model = BaseAnalytics()
       model.getBaseAnaltics { (result) in
        for data in result{
            let dataDict = data as! NSDictionary
            guard let idDict = dataDict["_id"] as? NSDictionary else {
                return
            }
            
            guard let day = idDict["date"] as? Int else {
                return
            }
            guard let month = idDict["month"] as? Int else {
                return
            }
            guard let year = idDict["year"] as? Int else {
                return
            }
            print(getDateFromcomponent(day: day, month: month, year: year))
        }
        
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func createNavView(){
        let items = ["My DashBoard", "Assignments", "Profile","VirtualBeacon","Drafts",]
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        //UIColor(red: 0.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        
        menuView = CustomNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: "My DashBoard", items: items as [AnyObject])
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        
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
            self.menuChanger(segment: indexPath)
            
        }
        
        self.navigationItem.titleView = menuView
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
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: LocalNotifcation.VirtualBeacon.rawValue) , object: nil)
        case 4:
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: LocalNotifcation.Draft.rawValue) , object: nil)
            
        default:
            break
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

}
