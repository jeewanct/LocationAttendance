//
//  TimeLineViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 28/07/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit
import RealmSwift
import BluedolphinCloudSdk

class TimeLineViewController: UIViewController {
    fileprivate var timeLineData = [CheckinListData]()
    var currentDate :Date?

    @IBOutlet weak var timeLineTableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(cancelAction))
        self.navigationItem.title = currentDate?.formattedWith(format: "MMM d, yyyy")
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: APPFONT.DAYHEADER!]
        self.navigationController?.navigationBar.tintColor = APPColor.BlueGradient
        timeLineData = CheckinListModel.getDataFromDb(date: currentDate!)
        timeLineTableview.delegate = self
        timeLineTableview.dataSource = self
        timeLineTableview.allowsSelection = false
        timeLineTableview.tableFooterView = UIView()
        timeLineTableview.separatorStyle = .none
        
    
    
        // Do any additional setup after loading the view.
    }

    func cancelAction(){
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDateInAMPM(date:Date)->String{
        print(date)
        let timeFormatter = DateFormatter()
        //timeFormatter.dateStyle = .none
        
        timeFormatter.dateFormat = "hh:mm a"
        return timeFormatter.string(from:date)
        
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



extension TimeLineViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "timeLineCell", for: indexPath as IndexPath) as! TimeLineTableViewCell
        let currentData = timeLineData[indexPath.row]
        cell.timeLabel.text = self.getDateInAMPM(date: Date(timeIntervalSince1970:  currentData.getStartTime()!))  +  " - " +  self.getDateInAMPM(date: Date(timeIntervalSince1970:  currentData.getEndTime()!))
        cell.timeLabel.font = APPFONT.HELPTEXT
        cell.beaconLabel.text = "Beacon Location"
        cell.beaconLabel.font = APPFONT.OTPACTION
        let distictBeacon = currentData.getDistinctBeacons()
        let realm = try! Realm()
        var beaconAddressArray = [String]()
        for data in distictBeacon{
            if let data = realm.objects(VicinityBeacon.self).filter("beaconId =%@",data).first {
                beaconAddressArray.append(data.address!)
            }
            
            
        }
        cell.numberOfBeaconLabel.font = APPFONT.HELPTEXT
        cell.numberOfBeaconLabel.numberOfLines = 0
        cell.numberOfBeaconLabel.lineBreakMode = .byWordWrapping
        cell.numberOfBeaconLabel.sizeToFit()
        cell.numberOfBeaconLabel.text = beaconAddressArray.joined(separator: "\n").capitalized
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeLineData.count
    }
}
