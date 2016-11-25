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
    var tabView:ViewPagerControl!
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
        tabView = ViewPagerControl(items: data)
        tabView.type = .text
        tabView.frame = CGRect(x: 0, y: 64, width: ScreenConstant.width, height: 60)
        tabView.isHighlighted = true
        tabView.selectionIndicatorColor = UIColor.blue
        tabView.selectionIndicatorHeight = 2
        
        self.view.addSubview(tabView)
        
        tabView.indexChangedHandler = { index in
            
            self.segmentControl(index: index)
            
        }
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped(sender:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped(sender:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        
        self.view.addGestureRecognizer(swipeLeft)
        self.view.addGestureRecognizer(swipeRight)

    }
  
    func swiped(sender:UISwipeGestureRecognizer){
        if let swipeGesture = sender as? UISwipeGestureRecognizer{
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                tabView.setSelectedSegmentIndex(tabView.selectedSegmentIndex + 1 > 2 ? 2:tabView.selectedSegmentIndex + 1, animated: true)
            case UISwipeGestureRecognizerDirection.left:
                tabView.setSelectedSegmentIndex(tabView.selectedSegmentIndex - 1 < 0 ? 0:tabView.selectedSegmentIndex - 1, animated: true)
                print("left swipe")
            default:
                print("other swipe")
            }
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
    
//    func addObserver(){
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.MobileNumber(_:)), name: NSNotification.Name(rawValue: NotifRequestSuccess.mobileNumber.rawValue), object: nil)
//        
//    }

}
    
    
