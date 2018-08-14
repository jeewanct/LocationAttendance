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
import Polyline

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
    
    @IBOutlet weak var upperView: UIView!
    
    
  //  @IBOutlet weak var progressView: UICircularProgressRingView!
    var  dataArray = [Date]()
    var swipedown :UISwipeGestureRecognizer?
   
    /* Changes done from 10 July '18 New Design */
    
    @IBOutlet weak var userLocationCardHeightAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var userLocationContainerView: UIView!
    
    
    // Status change view
    @IBOutlet var statusChangeView: UIView!
    @IBOutlet weak var bottomMessageLabel: UILabel!
    @IBOutlet weak var unavailableTillLabel: UILabel!
    @IBOutlet weak var todayDateLabel: UILabel!
    @IBOutlet weak var syncButton: UIBarButtonItem!
    
    var tapGesture: UITapGestureRecognizer?
    var userContainerView: NewCheckOutUserScreen?
    
    var userLocations: [LocationDataModel]?{
        didSet{
            //plotUserLocation()
        }
    }
    

    
    
    
    var polyline = GMSPolyline()
    var animationPolyline = GMSPolyline()
    var path = GMSMutablePath()
    var animationPath = GMSMutablePath()
    var i: UInt = 0
    var timer: Timer!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        let application = UIApplication.shared
        let co = application.topViewController as? UINavigationController
        let arr = co?.viewControllers
        print("application.topViewController = \(String(describing: arr?.last))")
        
        
        let value = NSDate().aws_stringValue("y-MM-ddH:m:ss.SSSS")
        
        print(value ?? "")
        
        
        navigationController?.removeTransparency()
        let height = UIScreen.main.bounds.size.height
        userLocationCardHeightAnchor.constant = height - (height * 0.3)
        
       // userLocationContainerView.applyGradient(isTopBottom: false, colorArray: [APPColor.BlueGradient,APPColor.GreenGradient])
       
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
        
        addShadowToUpperView()
        
        userLocationContainerView.isHidden = true
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewCheckoutViewController.discardFakeLocations), name: NSNotification.Name(rawValue: LocalNotifcation.RMCPlacesFetched.rawValue), object: nil)
        
        
        
        
        // Do any additional setup after loading the view.
    }
    

  
    override func viewDidAppear(_ animated: Bool) {

        updateView()
        
        if AssignmentModel.statusOfUser() {
            self.statusChangeView.isHidden = false
            self.syncButton.isEnabled = true
        } else {
            self.statusChangeView.isHidden = true
            self.syncButton.isEnabled = false
        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let getTimer = self.timer{
            self.timer.invalidate()
        }
        
    }
    
    
    
    
    @IBAction func syncTapped(_ sender: Any) {
        self.syncButton.isEnabled = false
        //"&status=" + AssignmentStatus.Assigned.rawValue
        let queryStr = "&assignmentStartTime=" + ((Calendar.current.date(byAdding: .day, value: -15, to: Date()))?.formattedISO8601)!
        AssignmentModel.getAssignmentsForDesiredTime(query: queryStr) { (completionStatus) in
            UI {
                print("completionstatus = \(completionStatus)")
                if completionStatus == "Success" {
                    UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.LastAssignmentFetched.rawValue)
                }
                if AssignmentModel.statusOfUser() {
                    // Here i have to swipe down the user screen to stop mobitoring
                    bdCloudStopMonitoring()
                    self.statusChangeView.isHidden = false
                    self.syncButton.isEnabled = true
                } else {
                    self.statusChangeView.isHidden = true
                    self.syncButton.isEnabled = false
                }
            }
        }
        
    }
    
    
    func addShadowToUpperView () {

        upperView.layer.shadowColor = UIColor.gray.cgColor
        upperView.layer.shadowOpacity = 0.3
        upperView.layer.shadowOffset = CGSize(width: 0, height: 3)
        upperView.layer.shadowRadius = 1
    }
    
    
    func updateAddress(sender: NSNotification) {
        DispatchQueue.main.async {
            self.lastCheckinAddressLabel.text = CurrentLocation.address
        }
    }
    
    func updateTime(sender:NSNotification){
       // updateView()
       
        
  
        
    }

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
            default:
                break
                
            }
            
        }
        
    }
//
    
    
    func discardFakeLocations(){
        updateView()
    }
    
    
    func updateView(date:Date = Date()){
        
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

        
        let locationFilters = LocationFilters()
        locationFilters.delegate = self
        locationFilters.plotMarkers(date: date)

    }
    
    

    
    
    
    func plotMarkersInMap(location: [LocationDataModel]){
        
        let allLocations = UserPlace.getGeoTagData(location: location)
        
        if allLocations.count == 0{
            userLocationContainerView.isHidden = true
        }else{
            //plotPathInMap(location: allLocations)
            userContainerView?.locationData = allLocations.reversed()
            let polyLine = PolyLineMap()
            polyLine.delegate = self
            polyLine.getPolyline(location: allLocations)
            
           // getLocationCorrospondingLatLong(locations: allLocations)
            userLocationContainerView.isHidden = false
        }
        
        
        
        for locations in allLocations{
            
            for geoTaggedLocation in locations{
                
                if let geoTagg = geoTaggedLocation.geoTaggedLocations{
                   
                    addMarker(latitude: geoTagg.latitude, longitude: geoTagg.longitude, markerColor: #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1))
                }else{
                    
                    addMarker(latitude: geoTaggedLocation.latitude, longitude: geoTaggedLocation.longitude, markerColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                }
                
            }
            
            
        }
    }
    
    func drawPath(coordinates: [CLLocationCoordinate2D]){
        
        
        for coordinate in coordinates{
            path.add(coordinate)
            
        }
        
        let bounds = GMSCoordinateBounds(path: path)
        mapView.animate(with: GMSCameraUpdate.fit(bounds))
       // mapView.animate(with: GMSCameraUpdate()
       // mapView.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(bounds, withPadding: 40))
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = .black
        polyline.strokeWidth = 3
        polyline.map = mapView
        
        //self.timer = Timer.scheduledTimer(timeInterval: 0.0003, target: self, selector: #selector(animatePolylinePath), userInfo: nil, repeats: true)
        
    }
    
    
    func animatePolylinePath() {
        if (self.i < self.path.count()) {
            self.animationPath.add(self.path.coordinate(at: self.i))
            self.animationPolyline.path = self.animationPath
            self.animationPolyline.strokeColor = UIColor.gray
            self.animationPolyline.strokeWidth = 3
            self.animationPolyline.map = self.mapView
            self.i += 1
        }
        else {
            self.i = 0
            self.animationPath = GMSMutablePath()
            self.animationPolyline.map = nil
        }
    }
    
   
        
    func addMarker(latitude: String?, longitude: String?, markerColor: UIColor){
            let marker = GMSMarker()
            if let lat = latitude, let long = longitude{
                
                                if let locationLat = CLLocationDegrees(lat), let locationLong = CLLocationDegrees(long){
                
                                    marker.position = CLLocationCoordinate2D(latitude:  locationLat, longitude: locationLong)
                
                
                                    marker.title = "Sydney"
                                    marker.snippet = "Australia"
                                    let iconImageView = UIImageView(image: #imageLiteral(resourceName: "locationBlack").withRenderingMode(.alwaysTemplate))
                                    iconImageView.tintColor = markerColor
                                    marker.iconView = iconImageView
                                        
                                    marker.map = mapView
                
                
                                    let camera = GMSCameraPosition.camera(withLatitude: locationLat, longitude: locationLong, zoom: 17.0)
                                    mapView.camera = camera
                
                
                                    //path.add(CLLocationCoordinate2D(latitude: locationLat, longitude: locationLong))
                
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
    
//
//
//
//
//
//    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
//        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
//    }
//
//    func timeText(_ s: Int) -> String {
//        return s < 10 ? "0\(s)" : "\(s)"
//    }
//    func currentTime(time:TimeInterval) -> String {
//
//        //        if let value = UserDefaults.standard.value(forKey: "LastCheckinTime") as? Date {
//        //            date = value
//        //        }
//        let date = Date(timeIntervalSince1970: time)
//        let calendar = Calendar.current
//        let hour = calendar.component(.hour, from: date)
//        let minutes = calendar.component(.minute, from: date)
//        return "\(timeText(hour)):\(timeText(minutes))"
//    }
    
    func menuAction(sender:UIBarButtonItem){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowSideMenu"), object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
  
}



/* Changes made on 10 July '18 New Design */


extension NewCheckoutViewController{
    
    func setupMap(){
      
            let camera = GMSCameraPosition.camera(withLatitude: CurrentLocation.coordinate.latitude, longitude: CurrentLocation.coordinate.longitude, zoom: 17.0)
            mapView.camera = camera
        
        
    }
    
    func addGestureInContainerView(){
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        userLocationContainerView.addGestureRecognizer(tapGesture!)
        
        let downGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleTap))
        downGesture.direction = .up
        
        userLocationContainerView.addGestureRecognizer(downGesture)
        
    }
    
    @objc func handleTap(){
        
        print("View Tapped")
        
        if userLocationCardHeightAnchor.constant == 80 {
            view.removeGestureRecognizer(tapGesture!)
            
            animateContainerView(heightToAnimate: (UIScreen.main.bounds.size.height - (UIScreen.main.bounds.size.height * 0.3)))
        }else{
            // 400
            userContainerView?.tableView.isScrollEnabled = true
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            userLocationContainerView.addGestureRecognizer(tapGesture!)
            animateContainerView(heightToAnimate: 80)
        }
        
        
    }
    
    func animateContainerView(heightToAnimate height: CGFloat){
        
        UIView.animate(withDuration: 0.5) {
            if height == (UIScreen.main.bounds.size.height - (UIScreen.main.bounds.size.height * 0.3)){
                self.userLocationContainerView.backgroundColor = .clear
                
            }else{
                self.userLocationContainerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7477992958)
            }
            
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










extension  NewCheckoutViewController: LocationsFilterDelegate, PolylineStringDelegate{
   
    func drawPolyline(coordinates: [CLLocationCoordinate2D]) {
        drawPath(coordinates: coordinates)
    }
    
    
    
    func finalLocations(locations: [LocationDataModel]) {
        
        plotMarkersInMap(location: locations)
        
        
    }
    
    

    
    
}











