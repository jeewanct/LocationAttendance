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
import GoogleMaps



class NewCheckoutViewController: UIViewController {
    @IBOutlet weak var checkoutButton: UIImageView!
   // @IBOutlet weak var timeLabel: UILabel!
    
   // @IBOutlet weak var lastCheckinLabel: UILabel!
   // @IBOutlet weak var frequencyBarView: UIView!
    
   
    @IBOutlet weak var mapView: GMSMapView!
    
   // @IBOutlet weak var mapView: GMSMapView!
    
   // @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endYourDayLabel: UILabel!
   // @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var lastCheckinAddressLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
  //  @IBOutlet weak var progressView: UICircularProgressRingView!
    var  dataArray = [Date]()
    var swipedown :UISwipeGestureRecognizer?
   
    /* Changes done from 10 July '18 New Design */
    
    @IBOutlet weak var userLocationCardHeightAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var userLocationContainerView: UIView!
    
    var userContainerView: NewCheckOutUserScreen?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.removeTransparency()
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.isTranslucent = true
        
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu")?.withRenderingMode(.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(menuAction(sender:)))
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: APPFONT.DAYHEADER!]
        
//        let swipeleft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
//        swipeleft.direction = .left
//        let swiperight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
//        swiperight.direction = .right
//        
//        self.view.addGestureRecognizer(swipeleft)
//        self.view.addGestureRecognizer(swiperight)
        
//        let image: UIImage = UIImage(named: "s")!
//        let imageRotated: UIImage =
//            UIImage(cgImage: image.cgImage!, scale: 1, orientation: UIImageOrientation.down)
//        checkoutButton.image = imageRotated
        endYourDayLabel.font = APPFONT.DAYHEADER
      //  lastCheckinLabel.font = APPFONT.DAYHOURTEXT
        NotificationCenter.default.addObserver(self, selector: #selector(NewCheckoutViewController.updateTime(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.TimeUpdate.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewCheckoutViewController.updateAddress(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.LocationUpdate.rawValue), object: nil)
        swipedown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipedown?.direction = .down
        let shiftDetails = ShiftHandling.getShiftDetail()
        officeEndHour = shiftDetails.2
        officeStartHour = shiftDetails.0
        officeStartMin = shiftDetails.1
        officeEndMin = shiftDetails.3
        if let value = UserDefaults.standard.value(forKey: UserDefaultsKeys.BDShiftId.rawValue) as? String{
            SDKSingleton.sharedInstance.shiftId = value
        }
        bdCloudStartMonitoring()
        
        
        /* Changes made on 10 July '18 New Design */
        setupMap()
        addGestureInContainerView()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateView()
//        processCurrentWeek()
//        if  pageControl.currentPage < dataArray.count {
//            let value = dataArray[pageControl.currentPage]
//            updateView(date: value)
//        }
        
    }
    func updateAddress(sender: NSNotification) {
        DispatchQueue.main.async {
            self.lastCheckinAddressLabel.text = CurrentLocation.address
        }
    }
    
    func updateTime(sender:NSNotification){
        updateView()
       
        
        //processCurrentWeek()
        
//        if  pageControl.currentPage < dataArray.count {
//            let value = dataArray[pageControl.currentPage]
//            updateView(date: value)
//        }
        
        
    }
//    func processCurrentWeek(){
//        dataArray = []
//        let realm = try! Realm()
//        guard  let firstdateofWeek = Date().startOfWeek() else {
//            return
//        }
//        let attendanceLogForToday = realm.objects(AttendanceLog.self).filter("timeStamp >= %@",firstdateofWeek).sorted(byProperty: "timeStamp", ascending: true)
//        
//        let totalCount = attendanceLogForToday.count
//        if totalCount != 0{
//            pageControl.numberOfPages = totalCount
//        }
//        
//        for attendance in attendanceLogForToday{
//            dataArray.append(attendance.timeStamp!)
//        }
//        pageControl.currentPage = totalCount
//        //print(attendanceLogForToday.count)
//        
//        
//    }
//    @IBAction func pageControlAction(_ sender: UIPageControl) {
//        if dataArray.count > pageControl.currentPage{
//            let date = dataArray[pageControl.currentPage]
//            updateView(date: date)
//        }
//        
//    }
    
    //    func pageChanged(sender:UIPageControl){
    //        let date = dataArray[pageControl.currentPage]
    //        updateView(date: date)
    //
//        }
    func handleGesture(sender:UIGestureRecognizer){
        //print(dataArray)
        //Sourabh - When swiped down then we will not allow SDK to work as accordingly in RMCNotifier
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.ManualSwipe.rawValue)
        UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.ManualSwipedDate.rawValue)
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.ManualSwipeDown.rawValue)
        if let swipeGesture = sender as? UISwipeGestureRecognizer {
            switch swipeGesture.direction{
            case UISwipeGestureRecognizerDirection.down:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.DayCheckinScreen.rawValue), object: self, userInfo: nil)
                
//            case UISwipeGestureRecognizerDirection.left:
//                if pageControl.currentPage < dataArray.count {
//                    pageControl.currentPage = pageControl.currentPage + 1
//                    let value = dataArray[pageControl.currentPage]
//                    updateView(date: value)
//                }
//                
//                
//            case UISwipeGestureRecognizerDirection.right:
//                if pageControl.currentPage >= 0 {
//                    pageControl.currentPage = pageControl.currentPage - 1
//                    let value = dataArray[pageControl.currentPage]
//                    updateView(date: value)
//                }
                
                
            default:
                break
                
            }
            
        }
        
    }
//
    
    
    
    func updateView(date:Date = Date()){
        
        //progressView.maxValue = CGFloat((officeEndHour - officeStartHour) * 3600)
        //progressView.innerRingColor = APPColor.newGreen
        let isToday = Calendar.current.isDateInToday(date)
        if isToday{
            self.navigationItem.title = "Today"

            self.view.addGestureRecognizer(swipedown!)
            checkoutButton.isHidden = false
            endYourDayLabel.isHidden = false
        }else{
            self.navigationItem.title = date.dayOfWeekFull()
            checkoutButton.isHidden = true
            endYourDayLabel.isHidden = true
            self.view.removeGestureRecognizer(swipedown!)
        }


        //createFrequencybarView(date: date)
    }
    
//    func createFrequencybarView(date:Date){
//        let queue = DispatchQueue.global(qos: .userInteractive)
//
//
//
//        // submit a task to the queue for background execution
//        queue.async() {
//            let object = UserDayData.getFrequencyLocationBarData(date:date)
//            print(object)
//            DispatchQueue.main.async() {
//                let totalTime = object.getElapsedTime()!
//                self.progressView.setProgress(value: CGFloat(totalTime), animationDuration: 2.0) {
//
//                }
//                let (hour,min,_) = self.secondsToHoursMinutesSeconds(seconds: Int(totalTime))
//
//                let myMutableString =  NSMutableAttributedString(
//                    string: "\(self.timeText(hour)):\(self.timeText(min))",
//                    attributes: [NSFontAttributeName:APPFONT.DAYHOUR!])
//                let seconndMutableString =  NSMutableAttributedString(
//                    string: " Total hours",
//                    attributes: [NSFontAttributeName:APPFONT.DAYHOURTEXT!])
//                myMutableString.append(seconndMutableString)
//                self.timeLabel.attributedText = myMutableString
//                self.startTimeLabel.text = self.getDateInAMPM(date: Date(timeIntervalSince1970: object.getStartTime()!))
//                self.endTimeLabel.text = self.getDateInAMPM(date: Date(timeIntervalSince1970: object.getEndTime()!))
//                if let lastCheckinTime = object.getLastCheckinTime() {
//                    self.lastCheckinLabel.text = "You were last seen at \(self.currentTime(time: lastCheckinTime)) "
//                }else{
//                    self.lastCheckinLabel.text = "No checkins for today"
//                }
//                self.lastCheckinAddressLabel.numberOfLines = 0
//                self.lastCheckinAddressLabel.lineBreakMode = .byWordWrapping
//                self.lastCheckinAddressLabel.adjustsFontSizeToFitWidth = true
//                self.lastCheckinAddressLabel.text = object.getLastCheckInAddress()?.capitalized
//                self.updateFrequencyBar(mData: object)
//            }
//        }
//
//
//
//
//    }
    
    func getDateInAMPM(date:Date)->String{
        print(date)
        let timeFormatter = DateFormatter()
        //timeFormatter.dateStyle = .none
        
        timeFormatter.dateFormat = "hh:mm a"
        return timeFormatter.string(from:date)
        
    }
    
    
//    func updateFrequencyBar(mData:FrequencyBarGraphData) {
//        var mRectList = [CGRect]()
//        
//        let viewWidth = frequencyBarView.frame.size.width;
//        let viewHeight =
//            frequencyBarView.frame.size.height;
//        let maxDuration = mData.getEndTime()! - mData.getStartTime()!;
//        let widthPerDuration =  viewWidth / CGFloat(maxDuration);
//        for  duration in mData.graphData {
//            
//            let left = Int(widthPerDuration * CGFloat(duration.getStartTime() - mData.getStartTime()!));
//            var right = Int(CGFloat(left) + (widthPerDuration * CGFloat(duration.getEndTime() - duration.getStartTime())));
//            let top = 0;
//            let bottom = viewHeight;
//            right = right - left < 1 ?  1 :  right - left;
//            
//            let rect = CGRect(x: left, y: top, width: right, height: Int(bottom))
//            //print(rect)
//            mRectList.append(rect)
//        }
//        let view = FrequencyGraphView(frame: CGRect(x: 0, y: 0, width: frequencyBarView.frame.width, height: frequencyBarView.frame.height), data: mRectList)
//        frequencyBarView.addSubview(view)
//        
//    }
    
    
    
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
    
//    let mapView1: GMSMapView = {
//        let camera = GMSCameraPosition.camera(withLatitude: 51.527669000000003, longitude: -0.089038999999999993, zoom: 17)
//        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
//        return mapView
//    }()
    
}



/* Changes made on 10 July '18 New Design */


extension NewCheckoutViewController{
    
    func setupMap(){
      
       // mapView.changeStyle()
        
        let marker = GMSMarker()
       
        
        
        
        var locationManage = CLLocationManager()
         locationManage.location?.coordinate.latitude
        
        
        
        
        
        if let lat = locationManage.location?.coordinate.latitude, let long = locationManage.location?.coordinate.longitude {
           
            marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
            marker.title = "Sydney"
            marker.snippet = "Australia"
            marker.icon = #imageLiteral(resourceName: "locationBlack")
            marker.map = mapView
            
            
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
            mapView.camera = camera
        }
        
        
        
        
    }
    
    func addGestureInContainerView(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        userLocationContainerView.addGestureRecognizer(tapGesture)
        
        let downGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleTap))
        downGesture.direction = .up
        
        userLocationContainerView.addGestureRecognizer(downGesture)
        
    }
    
    @objc func handleTap(){
        
        print("View Tapped")
        
        if userLocationCardHeightAnchor.constant == 49 {
            animateContainerView(heightToAnimate: 450)
        }else{
            // 400
            userContainerView?.tableView.isScrollEnabled = true
            animateContainerView(heightToAnimate: 49)
        }
        
        
    }
    
    func animateContainerView(heightToAnimate height: CGFloat){
        
        UIView.animate(withDuration: 0.5) {
            self.userLocationCardHeightAnchor.constant = height
            self.view.layoutIfNeeded()
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "containerViewSegue"{
            userContainerView = segue.destination as! NewCheckOutUserScreen
            userContainerView?.delegate = self
        }
    }
    
    
}


extension NewCheckoutViewController: HandleUserViewDelegate{
   
    func handleOnSwipe() {
       // userLocationCardHeightAnchor.constant += 50
        self.view.layoutIfNeeded()
        handleTap()
    }
    
    
}






