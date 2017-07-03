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

let CHECK_IN_DURATION_TOLERANCE:Double = 30 * 60
let VALID_CHECKIN_DURATION :Double = 5*60
let officeStartHour = 9
let officeStartMin = 0
let officeEndHour = 21
let officeEndMin = 0


class NewCheckoutViewController: UIViewController {
    @IBOutlet weak var checkoutButton: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var lastCheckinLabel: UILabel!
    @IBOutlet weak var frequencyBarView: UIView!
    
    
    @IBOutlet weak var lastCheckinAddressLabel: UILabel!
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
        //NotificationCenter.default.addObserver(self, selector: #selector(NewCheckoutViewController.updateView(date:)), name: NSNotification.Name(rawValue: LocalNotifcation.TimeUpdate.rawValue), object: nil)
       
       
        // Do any additional setup after loading the view.
    }
    
    func handleGesture(sender:UIGestureRecognizer){
        UserDefaults.standard.set("2", forKey: "AlreadyCheckin")
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "day") as? DayCheckoutViewController
        self.show(controller!, sender: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateView()
    }
    func updateView(date:Date = Date()){
        progressView.maxValue = 12*60*60
        progressView.innerRingColor = APPColor.newGreen
        let isToday = Calendar.current.isDateInToday(date)
        if isToday{
            self.navigationItem.title = "Today"
        }else{
            self.navigationItem.title = date.dayOfWeek()
        }
        
       createFrequencybarView(date: date)
    }
    
    func createFrequencybarView(date:Date){
        let object = getFrequencyBarData(date:Date())
        let totalTime = object.getElapsedTime()!
        progressView.setProgress(value: CGFloat(totalTime), animationDuration: 2.0) {
            let (hour,min,_) = self.secondsToHoursMinutesSeconds(seconds: Int(totalTime))
            self.timeLabel.text = "\(self.timeText(hour)):\(self.timeText(min)) hrs"
        }
        
        self.lastCheckinLabel.text = "Your last check in \(currentTime(time: object.getLastCheckinTime()!)) "
       self.lastCheckinAddressLabel.text = object.getLastCheckInAddress()
        updateFrequencyBar(mData: object)
        
    }
    
    func updateFrequencyBar(mData:FrequencyBarGraphData) {
        var mRectList = [CGRect]()

            let viewWidth = frequencyBarView.frame.size.width;
            let viewHeight =
                frequencyBarView.frame.size.height;
            let maxDuration = mData.getEndTime()! - mData.getStartTime()!;
            let widthPerDuration =  viewWidth / CGFloat(maxDuration);
            for  duration in mData.graphData {
               
                let left = Int(widthPerDuration * CGFloat(duration.getStartTime() - mData.getStartTime()!));
                var right = Int(CGFloat(left) + (widthPerDuration * CGFloat(duration.getEndTime() - duration.getStartTime())));
                let top = 0;
                let bottom = viewHeight;
                right = right - left < 1 ?  1 :  right - left;
                
                let rect = CGRect(x: left, y: top, width: right, height: Int(bottom))
                //print(rect)
                mRectList.append(rect)
            }
        let view = FrequencyGraphView(frame: CGRect(x: 0, y: 0, width: frequencyBarView.frame.width, height: frequencyBarView.frame.height), data: mRectList)
        frequencyBarView.addSubview(view)
        
    }
    
    
    
    
    func getFrequencyBarData(date:Date) ->FrequencyBarGraphData{
        
        
        let calendar = Calendar.current
        let frequencyGraphData = FrequencyBarGraphData()
        let slotStartTime =  calendar.date(bySettingHour: officeStartHour, minute: officeStartMin, second: 0, of: date)!.timeIntervalSince1970
        let slotEndTime = calendar.date(bySettingHour: officeEndHour, minute: officeEndMin, second: 0, of: date)!.timeIntervalSince1970
        
        frequencyGraphData.setStartTime(startTime: slotStartTime)
        frequencyGraphData.setEndTime(endTime: slotEndTime)
        
        let isToday =  Calendar.current.isDateInToday(Date())
        let realm = try! Realm()
        let weekDay = Calendar.current.component(.weekday, from: Date())
        let weekOfYear = Calendar.current.component(.weekOfYear, from: Date())
        var lastCheckInRecorded :TimeInterval = 0;
        var elapsedTime:TimeInterval
            = 0;
        
        
        if let attendanceLogForToday = realm.objects(AttendanceLog.self).filter("dayofWeek = %@","\(weekDay)").first {
            if weekOfYear == Calendar.current.component(.weekOfYear, from: attendanceLogForToday.timeStamp!){
                let beaconData = attendanceLogForToday.beaconList.sorted(byProperty: "lastSeen", ascending: true).filter("beaconNumber = %@","0")
                print("============")
                print(beaconData.count)
                for i in 0..<beaconData.count{
                    let beaconObject = beaconData[i]
                    let  frequencyStartTime = beaconObject.lastSeen?.timeIntervalSince1970
                    var  frequencyEndTime = frequencyStartTime
                    if  i+1 < beaconData.count{
                        let nextBeacon = beaconData[i+1]
                        let timeDifference = getBeaconTimeDifference(timePrev: frequencyStartTime!, timeNext: nextBeacon.lastSeen!.timeIntervalSince1970)
                        frequencyEndTime = frequencyStartTime! + timeDifference
                    }
                    frequencyGraphData.graphData.append(GraphData(sTime: frequencyStartTime!, eTime: frequencyEndTime!))
                    if (lastCheckInRecorded != 0) {
                        // check how much time elapsed
                        let elapsedTimeNow = getElapsedTime(previousCheckInTime: lastCheckInRecorded, currentCheckInTime: frequencyStartTime!);
                        elapsedTime =  elapsedTime + elapsedTimeNow;
                    }
                    if (isToday) {
                        frequencyGraphData.setLastCheckinTime(lastCheckinTime: frequencyStartTime!);
                    }
                    
                    lastCheckInRecorded = frequencyStartTime!
                    
                    if (i == beaconData.count - 1) {
                             if let lastKnownBeacon =  realm.objects(VicinityBeacon.self).filter("major = %@ AND minor = %@ AND uuid = %@",beaconObject.major!,beaconObject.minor!,beaconObject.uuid!).first  {
                       
                            frequencyGraphData.setLastCheckInAddress(lastCheckInAddress: lastKnownBeacon.address!)
                                
                        }
                    }
                }
                frequencyGraphData.setElapsedTime(elapsedTime: elapsedTime);
                
            }else{
                
            }
        }
        return frequencyGraphData
        
    }
    
    
    func getBeaconTimeDifference(timePrev:TimeInterval,timeNext:TimeInterval) -> TimeInterval{
        let elapsedTime = timeNext - timePrev;
        if (elapsedTime <= CHECK_IN_DURATION_TOLERANCE) {
            return elapsedTime + 100;
        }
        return 1;
    }
    
    func getElapsedTime(previousCheckInTime:TimeInterval,currentCheckInTime:TimeInterval) -> TimeInterval {
        let elapsedTime = currentCheckInTime - previousCheckInTime;
        if (elapsedTime <= CHECK_IN_DURATION_TOLERANCE) {
            return elapsedTime;
        }
        return 0;
    }
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func timeText(_ s: Int) -> String {
        return s < 10 ? "0\(s)" : "\(s)"
    }
    func currentTime(time:TimeInterval) -> String {
       
//        if let value = UserDefaults.standard.value(forKey: "LastCheckinTime") as? Date {
//            date = value
//        }
        let date = Date(timeIntervalSince1970: time)
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        return "\(timeText(hour)):\(timeText(minutes))"
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

class GraphData:NSObject {
    fileprivate var startTime:TimeInterval?
    fileprivate var endTime:TimeInterval?
    init(sTime:TimeInterval,eTime:TimeInterval){
        startTime = sTime
        endTime = eTime
    }
    func getStartTime()->TimeInterval{
        return startTime!
    }
    func getEndTime()->TimeInterval{
        return endTime!
    }
    
}

class FrequencyBarGraphData :NSObject  {
    fileprivate var startTime:TimeInterval?
    fileprivate var endTime:TimeInterval?
    fileprivate var elapsedTime:TimeInterval?
    fileprivate var lastCheckinTime:TimeInterval?
    fileprivate var lastCheckInAddress:String?
    var graphData = [GraphData]()
    
    public func getStartTime()->TimeInterval? {
        return startTime
    }
    
    public func setStartTime( startTime:TimeInterval) {
        self.startTime = startTime
    }
    
    public func getEndTime()->TimeInterval? {
        return endTime
    }
    
    public func setEndTime( endTime:TimeInterval) {
        self.endTime = endTime
    }
    
    public func getElapsedTime()->TimeInterval? {
        return elapsedTime ?? 0
    }
    
    public func setElapsedTime(elapsedTime:TimeInterval) {
        self.elapsedTime = elapsedTime
    }
    
    public func getLastCheckinTime() ->TimeInterval?{
        return lastCheckinTime
    }
    
    public func setLastCheckinTime( lastCheckinTime:TimeInterval) {
        self.lastCheckinTime = lastCheckinTime;
    }
    
    public func getLastCheckInAddress()->String? {
        return lastCheckInAddress;
    }
    
    public func setLastCheckInAddress( lastCheckInAddress:String) {
        self.lastCheckInAddress = lastCheckInAddress;
    }
}
