//
//  NewCheckoutViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 22/06/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit
import RealmSwift
import BluedolphinCloudSdk

class NewCheckoutViewController: UIViewController {
    @IBOutlet weak var checkoutButton: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var lastCheckinLabel: UILabel!
    @IBOutlet weak var frequencyBarView: UIView!
    @IBOutlet weak var progressView: UICircularProgressRingView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(menuAction(sender:)))
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .down
        self.view.addGestureRecognizer(swipeUp)

        let image: UIImage = UIImage(named: "swipe_up")!
        let imageRotated: UIImage =
            UIImage(cgImage: image.cgImage!, scale: 1, orientation: UIImageOrientation.down)
        checkoutButton.image = imageRotated
       
       
        // Do any additional setup after loading the view.
    }
    
    func handleGesture(sender:UIGestureRecognizer){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateView()
    }
    func updateView(){
        progressView.maxValue = 32400
        progressView.innerRingColor = APPColor.newGreen
        if let value = UserDefaults.standard.value(forKey: "TotalTime") as? NSNumber {
            progressView.setProgress(value: CGFloat(value), animationDuration: 2.0) {
                let (hour,min,_) = self.secondsToHoursMinutesSeconds(seconds: Int(value))
                self.timeLabel.text = "\(self.timeText(hour)):\(self.timeText(min)) hrs"
            }
            
            
        }
        
        self.lastCheckinLabel.text = "Your last check in \(currentTime())"
        createFrequencybarView()
    }
    
    func createFrequencybarView(){
        let realm = try! Realm()
        let weekDay = Calendar.current.component(.weekday, from: Date())
        let weekOfYear = Calendar.current.component(.weekOfYear, from: Date())
        if let attendanceLogForToday = realm.objects(AttendanceLog.self).filter("dayofWeek = %@","\(weekDay)").first {
            if weekOfYear == Calendar.current.component(.weekOfYear, from: attendanceLogForToday.timeStamp!){
                let beaconData = attendanceLogForToday.beaconList.sorted(byProperty: "lastSeen", ascending: true)
                for data in beaconData{
                    print(data)
                }
                
                
            }
        }
        
        
        
    }
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    func timeText(_ s: Int) -> String {
        return s < 10 ? "0\(s)" : "\(s)"
    }
    func currentTime() -> String {
        var date = Date()
        if let value = UserDefaults.standard.value(forKey: "LastCheckinTime") as? Date {
            date = value
        }
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        return "\(hour):\(minutes)"
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

class GraphData {
    
    
}
