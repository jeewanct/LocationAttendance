//
//  HomeViewController.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 17/11/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import UIKit
import RealmSwift
class HomeViewController: UIViewController {
 var data = ["One","Two","three"]
    override func viewDidLoad() {
        super.viewDidLoad()
        createViewPager()
//        let options = ViewPagerOptions(inView: self.view)
//        options.isEachTabEvenlyDistributed = true
//        options.isTabViewHighlightAvailable = true
    
        
        //getUserData()
        //postCheckin()
        // Do any additional setup after loading the view.
        
        
        
    }

    func createViewPager(){
        let tabView = ViewPagerControl(items: data)
        tabView.frame = CGRect(x: 0, y: 0, width: ScreenConstant.width, height: 60)
        tabView.selectionIndicatorColor = UIColor.blue
        self.view.addSubview(tabView)
        
        tabView.indexChangedHandler = { index in
            
            self.segmentControl(index: index)
            
        }
    }
  
    
    func segmentControl(index:Int){
        print(index)
    }
    func postCheckin(){
        let checkin = CheckinHolder()
        checkin.accuracy = CurrentLocation.accuracy
        checkin.altitude = CurrentLocation.altitude
        checkin.latitude = String(CurrentLocation.coordinate.latitude)
        checkin.longitude = String(CurrentLocation.coordinate.longitude)
        checkin.checkinDetails = toJsonString(["notes":"hello new note"] as AnyObject)
        checkin.checkinCategory = CheckinCategory.Transient.rawValue
        checkin.checkinType = CheckinType.Location.rawValue
        checkin.organizationId = Singleton.sharedInstance.organizationId
        checkin.checkinId = UUID().uuidString
        checkin.time = Date().formattedISO8601
        let user = CheckinModel()
        user.createCheckin(checkinData: checkin)
        user.postCheckin()
        
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

}

