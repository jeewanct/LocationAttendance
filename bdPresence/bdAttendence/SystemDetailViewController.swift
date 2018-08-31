//
//  SystemDetailViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 05/07/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit
import BluedolphinCloudSdk
import RealmSwift

class SystemDetailViewController: UIViewController {

    @IBOutlet weak var systemTableview: UITableView!
    var systemDetail = [String]()
    let activityIndicator = ActivityIndicatorView()
    var imageIcons :[UIImage] = [#imageLiteral(resourceName: "syncImage"),#imageLiteral(resourceName: "syncImage"),#imageLiteral(resourceName: "pendingImage"),#imageLiteral(resourceName: "notouchImage")]
    
        var longPressGesture :UILongPressGestureRecognizer?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.removeTransparency()
        setupController()
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.isTranslucent = true
        
        

        // Do any additional setup after loading the view.
    }

    
    func setupController(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu")?.withRenderingMode(.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(menuAction(sender:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "sync"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(sync(sender:)))
        self.navigationItem.title = "System Details"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: APPFONT.DAYHEADER!]
        systemTableview.delegate = self
        systemTableview.dataSource = self
        systemTableview.tableFooterView = UIView()
        systemTableview.allowsSelection = false
        
        systemTableview.register(UINib(nibName: "SystemSettingsCell", bundle: nil), forCellReuseIdentifier: "SystemSettingsCell")
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.lightGray
        refreshControl.addTarget(self, action: #selector(refresh(refreshControl:)), for: .valueChanged)
        systemTableview.addSubview(refreshControl)
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        updateData()
    }
    
    
    
    func sync(sender:UIBarButtonItem){
        if isInternetAvailable(){
            
            if let lastManualSync = UserDefaults.standard.value(forKey: UserDefaultsKeys.LastManualSync.rawValue) as? Date {
                let interval = Date().timeIntervalSince(lastManualSync)
                print(interval)
                if interval > 120 {
                    //AlertView.sharedInstance.setLabelText("Syncing started...")
                   // AlertView.sharedInstance.showActivityIndicator(self.view)
                    
                    self.view.showActivityIndicator(activityIndicator: activityIndicator)
                    CheckinModel.postCheckin()
                    checkShiftStatus { (apiResultStatus) in
                       // AlertView.sharedInstance.hideActivityIndicator(self.view)
                        self.view.removeActivityIndicator(activityIndicator: self.activityIndicator)
                        if apiResultStatus == APIResult.Success {
                            self.updateData()
                        }
                    }
                    
                } else {
                }
            }else {
//                AlertView.sharedInstance.setLabelText("Syncing started...")
//                AlertView.sharedInstance.showActivityIndicator(self.view)
                 self.view.showActivityIndicator(activityIndicator: activityIndicator)
                UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.LastManualSync.rawValue)
                // No last beacon checkin as Date
                CheckinModel.postCheckin()
                
                checkShiftStatus { (apiResultStatus) in
                    //AlertView.sharedInstance.hideActivityIndicator(self.view)
                    self.view.removeActivityIndicator(activityIndicator: self.activityIndicator)
                    if apiResultStatus == APIResult.Success {
                        self.updateData()
                    }
                }
                
            }
            
            
            
            
//            CheckinModel.postCheckin()
//            AlertView.sharedInstance.setLabelText("Syncing ...")
//            AlertView.sharedInstance.showActivityIndicator(self.view)
//            if isInternetAvailable(){
//                checkShiftStatus { (apiResultStatus) in
//                    AlertView.sharedInstance.hideActivityIndicator(self.view)
//                    if apiResultStatus == APIResult.Success {
//
//                        //let destVC = self.storyboard?.instantiateViewController(withIdentifier: "Main") as! UINavigationController
//                        //UIApplication.shared.keyWindow?.rootViewController = destVC
//                    }
//                }
//
//            }
//            checkShiftStatus()
            
            //Sourabh - Forcefully updating access token
            
            
            
//            BlueDolphinManager.manager.getNearByBeacons(completion: { (value) in
//
//            })
        }else{
            showAlert(ErrorMessage.NetError.rawValue)
        }
        
    }
    
    func handleLongPress(){
        let message = getBeaconList().joined(separator: "\n")
        let alertController = UIAlertController(title: "Beacons", message: message, preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (action) in
            return        }
        alertController.addAction(OkAction)
        self.present(alertController, animated: true) {
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
    func refresh(refreshControl:UIRefreshControl){
        updateData()
        refreshControl.endRefreshing()
    }
    func updateData(){
       
        systemDetail  = []
        let userDataForToday = UserDayData.getFrequencyLocationBarData(date: Date())
        var  lastCheckinTime = String()
        if let data = userDataForToday.getLastCheckinTime() {
        lastCheckinTime = " \(Date(timeIntervalSince1970: data).formatted)"
        }else{
           lastCheckinTime = "No last Checkin Found"
        }
        
        //let lastCheckinLocation = "Last beacon location : " + userDataForToday.getLastCheckInAddress()!.capitalized
        systemDetail.append(lastCheckinTime)
       // systemDetail.append(lastCheckinLocation)
//        if let data = UserDefaults.standard.value(forKey: UserDefaultsKeys.LastBeaconScanned.rawValue ) as? Date {
//            let detail = "Last beacon scanned on : " + data.formatted
//            systemDetail.append(detail)
//
//        }
        
        
        if let data = UserDefaults.standard.value(forKey: UserDefaultsKeys.LastSyncTime.rawValue ) as? Date {
            let detail = data.formatted
            systemDetail.append(detail)
            
        }
        let pendingCheckins = " \(CheckinModel.getCheckinsTypeCount(type: .Location))"
        systemDetail.append(pendingCheckins)
        if SDKSingleton.sharedInstance.noTouchMode {
            systemDetail.append("ON")
        } else {
            systemDetail.append("OFF")
        }
        DispatchQueue.main.async {
            self.systemTableview.reloadData()
        }
    }
    
    func menuAction(sender:UIBarButtonItem){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowSideMenu"), object: nil)
        
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
    func getBeaconList() -> [String]{
       var beaconAddressList = [String]()
        let realm = try! Realm()
        let beaconList = realm.objects(VicinityBeacon.self)
        var count = 1
        for object in beaconList{
            beaconAddressList.append("\(count): " + object.address!.capitalized)
            count = count + 1
        }
        return beaconAddressList
        
    }

}

extension SystemDetailViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageIcons.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 49
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SystemSettingsCell", for: indexPath as IndexPath) as! SystemSettingsCell
        cell.headerLabel.font = APPFONT.HELPTEXT
        cell.headerLabel.textColor = UIColor(hex: "333333")
        cell.valueLabel.textColor =  UIColor(hex: "a9a9a9")
        cell.valueLabel.font = APPFONT.HELPTEXT
//        cell.headingLabel.text = "Status"
//        cell.valueLabel.text = "Available"
        
        cell.imageView?.image = imageIcons[indexPath.item]
        cell.headerLabel.text = ["Last Location Check-in:", "Last synced at:", "Pending check-ins", "No touch mode"][indexPath.item]
        
        cell.valueLabel.text = systemDetail[indexPath.row]
//        cell.textLabel?.font = APPFONT.DAYHOURTEXT
//        cell.textLabel?.text = systemDetail[indexPath.row]
//        cell.textLabel?.numberOfLines = 0
//        cell.imageView?.image = imageIcons[indexPath.row]
//        if indexPath.row == 1{
//            cell.addGestureRecognizer(longPressGesture!)
//
//        }
    
        return cell
    }
    
}
