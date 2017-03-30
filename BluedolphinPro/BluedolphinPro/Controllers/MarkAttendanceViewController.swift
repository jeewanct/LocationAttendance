//
//  MarkAttendanceViewController.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 29/03/17.
//  Copyright © 2017 raremediacompany. All rights reserved.
//

import UIKit

class MarkAttendanceViewController: UIViewController {
var menuView :CustomNavigationDropdownMenu!
    var seanbeacons = NSMutableDictionary()
    //var beaconManager: IBeaconManager!
    var checkinString = "I am in"
    
    
    @IBOutlet weak var OfficeLabel: UILabel!
    @IBOutlet weak var checkinButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavView()
        hideButtons()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Scan", style: UIBarButtonItemStyle.plain, target: self, action: #selector(scanPressed))
        
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        if let buttonString = UserDefaults.standard.value(forKey: "CheckinString") as? String{
            checkinString = buttonString
        }
        startScanning()
    }
    
    func scanPressed(){
        hideButtons()
        startScanning()
    }
    func hideButtons(){
        checkinButton.isHidden = true
        OfficeLabel.isHidden = true
    }
    func showButton(){
        checkinButton.setTitle(checkinString, for: UIControlState.normal)
        OfficeLabel.text = "You are in Raremediacompany"
        checkinButton.isHidden = false
        OfficeLabel.isHidden = false
        
        
    }
    @IBAction func ButtonAction(_ sender: UIButton) {
        sendCheckin()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createNavView(){
        let items = ["My DashBoard", "Assignments", "Profile","VirtualBeacon","Drafts","Attendence"]
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        //UIColor(red: 0.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        
        menuView = CustomNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: "Attendence", items: items as [AnyObject])
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
        case 5:
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: LocalNotifcation.Attendance.rawValue) , object: nil)
            
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
    
    func sendCheckin(){
        
        if self.seanbeacons.count != 0 {
            
            let checkin = CheckinHolder()
            var beaconArray = Array<Any>()
            for (_,value) in self.seanbeacons {
                beaconArray.append(value)
            }
            checkin.beaconProximities = beaconArray
            checkin.checkinDetails = [AssignmentWork.AppVersion.rawValue:AppVersion as AnyObject,AssignmentWork.UserAgent.rawValue:deviceType as AnyObject,"beaconStatus":checkinString as AnyObject]
            checkin.checkinCategory = CheckinCategory.Transient.rawValue
            checkin.checkinType = CheckinType.Beacon.rawValue
            self.seanbeacons = NSMutableDictionary()                //        checkin.imageName = imageName + Date().formattedISO8601
            //        checkin.relativeUrl = imageId
            let checkinModelObject = CheckinModel()
            checkinModelObject.createCheckin(checkinData: checkin)
            if isInternetAvailable(){
                checkinModelObject.postCheckin()
            }
            
            if checkinString == "I am in"{
                checkinString = "I am out"
            }else{
                checkinString = "I am in"
            }
            //showButton()
            hideButtons()
            showAlert("Your Checkin has been posted")
            UserDefaults.standard.set(checkinString, forKey: "CheckinString")
            
        }
        
        
    }
    func showAlert(_ message : String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (action) in
            return        }
        alertController.addAction(OkAction)
        self.present(alertController, animated: true) {
        }
    }

}

extension MarkAttendanceViewController {
    
    
    func startScanning(){
        let beaconManager = IBeaconManager()
        var beaconArray = [iBeacon]()
        let vicinityManager = VicinityManager()
        
        let beaconsData = vicinityManager.fetchBeaconsFromDb()
        for beaconObject in beaconsData{
            let ibeacon =
                iBeacon(minor: beaconObject.minor, major: beaconObject.major, proximityId: beaconObject.uuid!, id: beaconObject.beaconId!)
            beaconArray.append(ibeacon)
        }
        beaconManager.registerBeacons(beaconArray)
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
                    "lastseen" : getCurrentDate().formattedISO8601
                    
                ]
                seanbeacons.addEntries(from: [beacon.major! :dict])
                print(dict)
                
            }
            
            
            
            }
        if seanbeacons.count != 0{
            showButton()
            //beaconManager.stopMonitoring()
        }
        
        }
    
 
    }
