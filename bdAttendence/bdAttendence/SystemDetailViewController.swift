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
    
    var imageIcons :[UIImage] = [#imageLiteral(resourceName: "bluetooth_gray"),#imageLiteral(resourceName: "bluetooth_gray"),#imageLiteral(resourceName: "bluetooth_gray"),#imageLiteral(resourceName: "pending_checkin"),#imageLiteral(resourceName: "sync")]
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(menuAction(sender:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "sync"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(sync(sender:)))
        self.navigationItem.title = "System Detail"
        systemTableview.delegate = self
        systemTableview.dataSource = self
        systemTableview.tableFooterView = UIView()
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.lightGray
        refreshControl.addTarget(self, action: #selector(refresh(refreshControl:)), for: .valueChanged)
        systemTableview.addSubview(refreshControl)
        
        updateData()

        // Do any additional setup after loading the view.
    }

    func sync(sender:UIBarButtonItem){
        if isInternetAvailable(){
            CheckinModel.postCheckin()
        }else{
            showAlert(ErrorMessage.NetError.rawValue)
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
        let userDataForToday = UserDayData.getFrequencyBarData(date: Date())
        var  lastCheckinTime = String()
        if let data = userDataForToday.getLastCheckinTime() {
        lastCheckinTime = "Last beacon check-in \(Date(timeIntervalSince1970: data).formatted)"
        }else{
           lastCheckinTime = "No last Checkin Found"
        }
        
        let lastCheckinLocation = "Last beacon location " + userDataForToday.getLastCheckInAddress()!
        systemDetail.append(lastCheckinTime)
        systemDetail.append(lastCheckinLocation)
        if let data = UserDefaults.standard.value(forKey: UserDefaultsKeys.LastBeaconScanned.rawValue ) as? Date {
            let detail = "Last beacon scanned on " + data.formatted
            systemDetail.append(detail)
            
        }
        
        let pendingCheckins = "Pending check-ins \(CheckinModel.getBeaconCheckinCount())"
        systemDetail.append(pendingCheckins)
        if let data = UserDefaults.standard.value(forKey: UserDefaultsKeys.LastSyncTime.rawValue ) as? Date {
            let detail = "Last synced at " + data.formatted
            systemDetail.append(detail)
            
        }
        systemTableview.reloadData()
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

}

extension SystemDetailViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return systemDetail.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 7
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "systemdetailCell", for: indexPath as IndexPath)
        cell.textLabel?.font = APPFONT.DAYHOURTEXT
        cell.textLabel?.text = systemDetail[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.imageView?.image = imageIcons[indexPath.row]
    
        return cell
    }
    
}
