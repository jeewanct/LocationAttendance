//
//  MainViewController.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 01/12/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var mainContainerView: UIView!
    var seanbeacons = NSMutableDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        let oauth = OauthModel()
        oauth.updateToken()
        
        NotificationCenter.default .removeObserver(self, name: NSNotification.Name(rawValue: LocalNotifcation.Pushreceived.rawValue), object: nil)
        NotificationCenter.default .addObserver(self, selector: #selector(MainViewController.methodOfReceivedNotification(notification:)), name: NSNotification.Name(rawValue: LocalNotifcation.Pushreceived.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.ShowController(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.Assignment.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.ShowController(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.Profile.rawValue), object: nil)
//        self.updateNewAssignmentData(id: "dc26ecb6-0e80-4d9f-afb9-26ed20ce35f1")
//       let model = AssignmentModel()
//        model.getAssignments(status: "Downloaded", completion: { (result) in
//            
//        })
        
        //startScanning()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ShowController (sender : NSNotification) {
        switch (sender.name.rawValue) {
        case LocalNotifcation.Profile.rawValue:
            
            //      for views in mainContainer.subviews {
            //        views.removeFromSuperview()
            //      }
            //println(self.childViewControllers.count)
            var lastController: AnyObject?
            
            if let controller =  self.childViewControllers.first as? UINavigationController {
                lastController = controller
            } else {
                lastController = self.childViewControllers.last as! UINavigationController
            }
            for views in self.mainContainerView.subviews {
                views.removeFromSuperview()
            }
            
            lastController?.willMove(toParentViewController: nil)
            //lastController?.willMoveToParentViewController(toSuperview: nil)
            lastController?.removeFromParentViewController()
            let destVc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileScene") as! UINavigationController
            //println(self.childViewControllers)
            self.addChildViewController(destVc)
            destVc.view.frame = self.mainContainerView.frame
            
            self.mainContainerView.addSubview(destVc.view)
            destVc.didMove(toParentViewController: self)
            
            
        case LocalNotifcation.Assignment.rawValue:
            
           
            var lastController: AnyObject?
            
            if let controller =  self.childViewControllers.first as? UINavigationController {
                lastController = controller
            } else {
                lastController = self.childViewControllers.last as! UINavigationController
            }
            for views in self.mainContainerView.subviews {
                views.removeFromSuperview()
            }
            lastController?.willMove(toParentViewController: nil)
           
            lastController?.removeFromParentViewController()
            let destVc = self.storyboard?.instantiateViewController(withIdentifier: "AssignmentScene") as! UINavigationController
            self.addChildViewController(destVc)
            destVc.view.frame = self.mainContainerView.frame
            self.mainContainerView.addSubview(destVc.view)
            destVc.didMove(toParentViewController: self)
            
        default:
            /* let destVc = self.storyboard?.instantiateViewControllerWithIdentifier("blue") as! UINavigationController
             self.addChildViewController(destVc)
             destVc.view.frame = self.mainContainer.frame
             self.mainContainer.addSubview(destVc.view)
             destVc.didMoveToParentViewController(self)*/
            print("")
        }
    }
    
    func methodOfReceivedNotification(notification: NSNotification){
        let result: NSDictionary = notification.userInfo! as NSDictionary
        let type:NotificationType = NotificationType(rawValue: result ["notificationType"] as! String)!
        switch type {
        case .Welcome:
            break
        case .NewAssignment,.UpdatedAssignment:
            if let assignmentId = result["assignmentId"] as? String{
                updateNewAssignmentData(id: assignmentId)
            }
            
        }
        
       
        
        
        
        // //println(notification)
        
        //    self.goToScreen(status,info: result)
    }
    
    func goToScreen(flag:Int,info:NSDictionary){
        //switch flag {}
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func pushAlertView(userInfo:NSDictionary) {
        var alertMessage = ""
        //let result: AnyObject? = userInfo ["aps"]
        alertMessage = userInfo.value(forKey: "message")! as! String
        
        let alert2 = UIAlertController(title: "Message", message:alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { action in
            //pushReceived = false
            
            
            
        })
        alert2.addAction(cancelAction)
        alert2.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
            
        }))
        
        
        self.present(alert2, animated: true, completion: nil)
        
    }
    
    
    
    
    func updateNewAssignmentData(id:String){
        let model = AssignmentModel()
        model.getAssignments(assignmentId: id) { (success) in
            
        }
        
        
        
    }
    
    

}

extension MainViewController {
    func startScanning(){
        let beaconManager = IBeaconManager()
        //var itemdata =  [24361:10010,27403:10858,21826:21481]
        //        let kontaktIOBeacon = iBeacon(minor: nil, major: nil, proximityId: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")
        let estimoteBeacon1 = iBeacon(minor: 10010, major: 24361, proximityId: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")
        let estimoteBeacon2 = iBeacon(minor: 10858, major: 27403, proximityId: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")
        let estimoteBeacon3 = iBeacon(minor: 21481, major: 21826, proximityId: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")
        beaconManager.registerBeacons([ estimoteBeacon1,estimoteBeacon2,estimoteBeacon3])
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: iBeaconNotifications.BeaconProximity.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(beaconsRanged(notification:)), name: NSNotification.Name(rawValue: iBeaconNotifications.BeaconProximity.rawValue), object: nil)
        
        beaconManager.startMonitoring({
            
        }) { (messages) in
            print("Error Messages \(messages)")
        }
    }
    /**Called when the beacons are ranged*/
    func beaconsRanged(notification:NSNotification){
        if let visibleIbeacons = notification.object as? [iBeacon]{
            
            
            for beacon in visibleIbeacons{
                /// Do something with the iBeacon
                
                let dict = [
                    "uuid" : beacon.UUID ,
                    "major": String(describing: beacon.major!),
                    "minor" : String(describing: beacon.minor!),
                    //"proximity" :  String(describing: beacon.proximity),
                    "rssi" : beacon.rssi,
                    "distance" :beacon.accuracy,
                    "lastseen" : Date().formattedISO8601
                
                ]
                seanbeacons.addEntries(from: [beacon.major! :dict])
                print(dict)
            }
            let delay = 5.0 * Double(NSEC_PER_SEC)
            let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: time, execute: {
            if self.seanbeacons.count != 0 {
                let checkin = CheckinHolder()
                var beaconArray = Array<Any>()
                for (_,value) in self.seanbeacons {
                    beaconArray.append(value)
                }
                checkin.beaconProximities = beaconArray
                checkin.checkinDetails = [:]
                checkin.checkinCategory = CheckinCategory.Data.rawValue
                checkin.checkinType = CheckinType.Data.rawValue
                self.seanbeacons = NSMutableDictionary()                //        checkin.imageName = imageName + Date().formattedISO8601
                //        checkin.relativeUrl = imageId
                let checkinModelObject = CheckinModel()
                checkinModelObject.createCheckin(checkinData: checkin)
                if isInternetAvailable(){
                    checkinModelObject.postCheckin()
                }

            }
            })
            
            
        }
    }
}
