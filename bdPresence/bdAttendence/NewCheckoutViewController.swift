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
import Alamofire


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
    
    var userLocations: [LocationDataModel]?{
        didSet{
            plotUserLocation()
        }
    }
    
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


        plotMarkers(date: date)
        //createFrequencybarView(date: date)
    }
    
    func plotMarkers(date: Date){
        
        let queue = DispatchQueue.global(qos: .userInteractive)
        
        queue.async {
            let locations = UserDayData.getLocationData(date: date)
            
            DispatchQueue.main.async() {
                
                if let getLocations = locations{
                    self.removeUnneccessaryLocationsWithAccuracy(locations: getLocations)
                }
                
                
                
            }
        }
    }
    
    func removeUnneccessaryLocationsWithAccuracy(locations: [LocationDataModel]){
     
        var updatedLocations = [LocationDataModel]()
        for location in locations{
            
            if let getAccuracy = location.accuracy, let accuracy = Float(getAccuracy){
                
                if accuracy > 700{
                    
                }else{
                    updatedLocations.append(location)
                }
            }
        }
        
        
        let finalLocations = removeUnnecessaryLocationWithTime(locations: updatedLocations)
        userLocations = finalLocations
        
        if let locationData = userLocations{
            
            userContainerView?.locationData = locationData.reversed()
        }
        
        
        
        
        print("After removing locations", finalLocations)
        
        
        
    }
    
    func removeUnnecessaryLocationWithTime(locations: [LocationDataModel]) -> [LocationDataModel]{
        
        var updatedLocations = [LocationDataModel]()
        
      
            
            for index1 in 0..<locations.count - 1{
                
                
                if let firstLat = locations[index1].latitude, let firstLong =  locations[index1].longitude, let secondLat = locations[index1 + 1].latitude, let secondLong = locations[index1 + 1].longitude{
                    
                    let distanceBetweenTwoCoordinates = distanceBetween(firstLat: firstLat, firstLong: firstLong, secondLat: secondLat, secondLong: secondLong)
                    
                    if distanceBetweenTwoCoordinates == 0 || distanceBetweenTwoCoordinates > 8000{
                       
                        let url = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(firstLat),\(firstLong)&destinations=\(secondLat),\(secondLong)&key=AIzaSyAEHGCnCX0R__be18wIL8sZ9UVhPO6bbAo&departure_time=1727491194&traffic_model=optimistic"
                        
                        //findApproxTimeToTravel(timeDifference: timeDifference, url: url)
                        
                    }else{
                        
                        updatedLocations.append(locations[index1])
                    }
                    
                    
                }
                
            }
            
        
        
        return updatedLocations
        
    }
    
    func findApproxTimeToTravel(timeDifference: Int, url: String) -> Bool{
        
        var isUsed  = false
        
        Networking.fetchGenericData(url, header: [:], success: { (timeRequired: GoogleDistanceCoveredTimeModel) in
            
            print(dump(timeRequired))
            
            
            isUsed = self.discardLocationUsingGoogle(timeRequired: timeRequired.rows, timeDifference : timeDifference)
            
            
        }) { (error) in
            
        }
        
        return isUsed
        
    }
    
    func discardLocationUsingGoogle(timeRequired: [GoogleRowModel]?, timeDifference : Int) -> Bool{
        
        
        guard let googleTimeArray = timeRequired else{
            return false
        }
        
        var timeTaken = 0
        
        for timeArray in googleTimeArray{
            
            if let elements = timeArray.elements{
                
                for element in elements{
                    
                    if let getTime = element.duration?.value{
                        timeTaken = timeTaken + getTime
                        
                    }
                    
                }
                
            }
            
        }
        
        if 0.45 * Double(timeTaken) > Double(timeDifference){
            return false
        }
        
        return true
        
    }
    
    
    func distanceBetween(firstCoordinate first: CLLocation, secondCoordinate second: CLLocation) -> Double{
        
        return first.distance(from: second)
        
    }
    
    func distanceBetween(firstLat: String, firstLong: String, secondLat: String, secondLong: String) -> Double{
     
        if let firstLocationLat = CLLocationDegrees(firstLat), let firstLocationLong = CLLocationDegrees(firstLong), let secondLocationLat = CLLocationDegrees(secondLat), let secondLocationLong = CLLocationDegrees(secondLong){
           
            let firstLocation = CLLocation(latitude: CLLocationDegrees(firstLocationLat), longitude: CLLocationDegrees(firstLocationLong))
            let secondLocation = CLLocation(latitude: CLLocationDegrees(secondLocationLat), longitude: CLLocationDegrees(secondLocationLong))
            
            return firstLocation.distance(from: secondLocation)
            
        }
        
        return 0
    }
    
    
    func getTime(date: Date) -> Int{
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        
        return hour * 60 * 60 + minutes * 60 + seconds
    
    }
    
    
    func createFrequencybarView(date:Date){
        let queue = DispatchQueue.global(qos: .userInteractive)



        // submit a task to the queue for background execution
        queue.async() {
            let object = UserDayData.getFrequencyLocationBarData(date:date)
            print(object)
            
            
            DispatchQueue.main.async() {
                
            
//                let latitudeData = attendanceLogForToday.locationList.sorted(byKeyPath: "latitude", ascending: true).filter("lastSeen BETWEEN %@",[date.dayStart(),date.dayEnd()])
//
//                let longitueData = attendanceLogForToday.locationList.sorted(byKeyPath: "longitude", ascending: true).filter("lastSeen BETWEEN %@",[date.dayStart(),date.dayEnd()])
                
                
                
                
                
                
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
            }
        }




    }
    
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
        
//        let marker = GMSMarker()
//       
//        
//        
//        
//        var locationManage = CLLocationManager()
//         locationManage.location?.coordinate.latitude
//        
//        
//        
//        
//        
//        if let lat = locationManage.location?.coordinate.latitude, let long = locationManage.location?.coordinate.longitude {
//           
//            marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
//            marker.title = "Sydney"
//            marker.snippet = "Australia"
//            marker.icon = #imageLiteral(resourceName: "locationBlack")
//            marker.map = mapView
//            
//            
//            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
//            mapView.camera = camera
//        }
        
        
        
        
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



extension NewCheckoutViewController{
    
    func plotUserLocation(){
        
        guard let markerLocations = userLocations else {
            return 
        }
        
        
        let path = GMSMutablePath()
        for location in markerLocations{
            
            let marker = GMSMarker()
            
            
            if let lat = location.latitude, let long = location.longitude{
                
                if let locationLat = CLLocationDegrees(lat), let locationLong = CLLocationDegrees(long){
                    
                    marker.position = CLLocationCoordinate2D(latitude:  locationLat, longitude: locationLong)
                    marker.title = "Sydney"
                    marker.snippet = "Australia"
                    marker.icon = #imageLiteral(resourceName: "locationBlack")
                    marker.map = mapView
                    
                    
                    let camera = GMSCameraPosition.camera(withLatitude: locationLat, longitude: locationLong, zoom: 17.0)
                    mapView.camera = camera
                    
                    
                    
                    path.add(CLLocationCoordinate2D(latitude: locationLat, longitude: locationLong))
                    
                }
                
                
                
            }
         
            
        }
        
        let polyline = GMSPolyline(path: path)
        polyline.map = mapView
        
    }
}



class Networking{

class func fetchGenericData<T: Decodable>(_ strURL: String,header:[String: String], success:@escaping (T) -> Void, failure:@escaping (Error) -> Void) {
    print(strURL)
    print(header)
    Alamofire.request(strURL,headers: header as? HTTPHeaders).responseJSON { (responseObject) -> Void in
        
        print(responseObject)
        
        
        if responseObject.result.isSuccess {
            if let responseData = responseObject.data{
                
                do{
                    let jsonData = try JSONDecoder().decode(T.self, from: responseData)
                    success(jsonData)
                }catch let jsonError{
                    failure(jsonError)
                }
            }
        }
        if responseObject.result.isFailure {
            let error : Error = responseObject.result.error!
            failure(error)
        }
        
        
    }
}

}


class GoogleDistanceCoveredTimeModel: Decodable{
    
    var rows : [GoogleRowModel]?
}

class GoogleRowModel: Decodable{
    
    var elements: [GoogleElementsModel]?
}

class GoogleElementsModel: Decodable{
    
    var duration: GoogleDurationModel?
}


class GoogleDurationModel: Decodable{
    
    var  text : String?
    var value : Int?
}







