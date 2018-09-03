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
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var endYourDayLabel: UILabel!
    @IBOutlet weak var lastCheckinAddressLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var upperView: UIView!
    var swipedown :UISwipeGestureRecognizer?
    @IBOutlet var statusChangeView: UIView!
    @IBOutlet weak var bottomMessageLabel: UILabel!
    @IBOutlet weak var unavailableTillLabel: UILabel!
    @IBOutlet weak var todayDateLabel: UILabel!
    @IBOutlet weak var syncButton: UIBarButtonItem!
    let activityIndicator = ActivityIndicatorView()
    var polyline = GMSPolyline()
    var animationPolyline = GMSPolyline()
    var path = GMSMutablePath()
    var animationPath = GMSMutablePath()
    var i: UInt = 0
    var timer: Timer!
    var pullController: SearchViewController!
    
    
    
    //MARK: View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shiftRelatedDetails()
        setupNavigationBar()
        setupMap()
        addObservers()
        setupGestures()
        updateView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        statusOfUser()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let _ = self.timer {
            self.timer.invalidate()
            self.timer = nil
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
                    self.statusChangeView.isHidden = false
                    self.syncButton.isEnabled = true
                    if let screenFlag = UserDefaults.standard.value(forKeyPath: "AlreadyCheckin") as? String {
                        if screenFlag == "1" {
                            UserDefaults.standard.set(false, forKey: UserDefaultsKeys.ManualSwipeDown.rawValue)
                            
                            UI {
                                UserDefaults.standard.set("2", forKey: "AlreadyCheckin")
                                // New change on 20/06/2018 to create one checkin
                                if isInternetAvailable(){
                                    CheckinModel.postCheckin()
                                }
                                bdCloudStopMonitoring()
                                
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.CheckinScreen.rawValue), object: self, userInfo: ["check":true])
                                
                                //                                createLocalNotification(message: "Looks like you're out of office. Time to relax!")
                            }
                        }
                    }
                } else {
                    self.statusChangeView.isHidden = true
                    self.syncButton.isEnabled = false
                }
            }
        }
        
    }
    
    
    func updateAddress(sender: NSNotification) {
        DispatchQueue.main.async {
            self.lastCheckinAddressLabel.text = CurrentLocation.address
        }
    }
    
    
    
}


//MARK: Setup UI Elements
extension NewCheckoutViewController{
    
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(NewCheckoutViewController.updateAddress(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.LocationUpdate.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewCheckoutViewController.discardFakeLocations(notification:)), name: NSNotification.Name(rawValue: LocalNotifcation.RMCPlacesFetched.rawValue), object: nil)
    }
    
    func setupNavigationBar(){
        navigationController?.removeTransparency()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu")?.withRenderingMode(.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(menuAction(sender:)))
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: APPFONT.DAYHEADER!]
    }
    
    func menuAction(sender:UIBarButtonItem){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowSideMenu"), object: nil)
        
    }
    
    func setupGestures(){
        swipedown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipedown?.direction = .down
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
    
    
    
}

//MARK: Shift Related details
extension NewCheckoutViewController{
    func shiftRelatedDetails(){
        let value = NSDate().aws_stringValue("y-MM-ddH:m:ss.SSSS")
        endYourDayLabel.font = APPFONT.DAYHEADER
        let shiftDetails = ShiftHandling.getShiftDetail()
        officeEndHour = shiftDetails.2
        officeStartHour = shiftDetails.0
        officeStartMin = shiftDetails.1
        officeEndMin = shiftDetails.3
        if let value = UserDefaults.standard.value(forKey: UserDefaultsKeys.BDShiftId.rawValue) as? String{
            SDKSingleton.sharedInstance.shiftId = value
        }
        bdCloudStartMonitoring()
        addShadowToUpperView()
    }
    
    func addShadowToUpperView () {
        
        upperView.layer.shadowColor = UIColor.gray.cgColor
        upperView.layer.shadowOpacity = 0.3
        upperView.layer.shadowOffset = CGSize(width: 0, height: 3)
        upperView.layer.shadowRadius = 1
    }
    
    func statusOfUser(){
        if AssignmentModel.statusOfUser() {
            if let screenFlag = UserDefaults.standard.value(forKeyPath: "AlreadyCheckin") as? String {
                if screenFlag == "1" {
                    UserDefaults.standard.set(false, forKey: UserDefaultsKeys.ManualSwipeDown.rawValue)
                    
                    UI {
                        UserDefaults.standard.set("2", forKey: "AlreadyCheckin")
                        // New change on 20/06/2018 to create one checkin
                        if isInternetAvailable(){
                            CheckinModel.postCheckin()
                        }
                        bdCloudStopMonitoring()
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.CheckinScreen.rawValue), object: self, userInfo: ["check":true])
                        
                        //                                createLocalNotification(message: "Looks like you're out of office. Time to relax!")
                    }
                }
            }
            self.statusChangeView.isHidden = false
            self.syncButton.isEnabled = true
            self.syncButton.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        } else {
            self.statusChangeView.isHidden = true
            self.syncButton.isEnabled = false
            self.syncButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    
}





//MARK: Call Filters on Checkouts

extension NewCheckoutViewController{
    
    func discardFakeLocations(notification: Notification){
        
        mapView.clear()
        
        animationPolyline = GMSPolyline()
        if let _ = timer{
            timer.invalidate()
            timer = nil
        }
        
        polyline = GMSPolyline()
        path.removeAllCoordinates()
        animationPath = GMSMutablePath()
        i = 0
        
     
            
            if let data = notification.userInfo as? [String: Any]{
                if let status = data["status"] as? Bool{
                    if status == true{
                        UserDefaults.standard.set(Date(), forKey: "RMCPlacesDuration")
                    }else{
                        
                    }
                }
            }
            
            //UserDefaults.standard.set(timeInSeconds(), forKey: "RMCPlacesDuration")
  
        
        
        updateView()
    }
    
    
    func updateView(date:Date = Date()){
        
        
        let isToday = Calendar.current.isDateInToday(date)
        if isToday{
            self.navigationItem.title = "Today"
            
            if let screenFlag = UserDefaults.standard.value(forKeyPath: "AlreadyCheckin") as? String {
                if screenFlag == "1" {
                    
                    let isToday = Calendar.current.isDateInToday(date)
                    if isToday{
                        self.navigationItem.title = "Today"
                        
                        self.view.addGestureRecognizer(self.swipedown!)
                        self.checkoutButton.isHidden = false
                        self.endYourDayLabel.isHidden = false
                    }else{
                        self.navigationItem.title = date.dayOfWeekFull()
                        self.checkoutButton.isHidden = true
                        self.endYourDayLabel.isHidden = true
                        self.view.removeGestureRecognizer(self.swipedown!)
                        
                    }
                    
                    
                }
                
                view.showActivityIndicator(activityIndicator: activityIndicator)
               
                let locationFilters = LocationFilters()
                locationFilters.delegate = self
                locationFilters.plotMarkers(date: date)
                
            }
            
        }
        
    }
    
}



/* Changes made on 10 July '18 New Design */


//MARK: Google Map Setup

extension NewCheckoutViewController{
    
    
    func setupMap(){
        mapView.changeStyle()
        mapView.setupCamera()
    }
    
    
    func plotMarkersInMap(location: [LocationDataModel]){
        
        let allLocations = UserPlace.getGeoTagData(location: location)
        self.view.removeActivityIndicator(activityIndicator: activityIndicator)
        
        mapView.addMarkersInMap(allLocations: allLocations)
        
        if allLocations.count != 0{
            
            if let _ = pullController{
                self.removePullUpController(pullController, animated: true)
            }
            
            
            self.pullController = UIStoryboard(name: "NewDesign", bundle: nil)
                .instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
            self.pullController.screenType = LocationDetailsScreenEnum.dashBoardScreen
            self.pullController.locationData = LogicHelper.shared.sortGeoLocations(locations: allLocations).reversed()
            self.addPullUpController(self.pullController, animated: true)
            
            let polyLine = PolyLineMap()
            polyLine.delegate = self
           // polyLine.allLocations = allLocations
            //polyLine.takePolyline()
            polyLine.getPolyline(location: LogicHelper.shared.sortGeoLocations(locations: allLocations))
            
        }
        

        
    }
    
    
    
    
    func animatePolylinePath() {
        let state = UIApplication.shared.applicationState
        
        if state == .background {
            // background
        }
        else if state == .active {
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
            
            // foreground
        }
        
        
    }
}

extension  NewCheckoutViewController: LocationsFilterDelegate, PolylineStringDelegate{
    func onFailure() {
        self.view.removeActivityIndicator(activityIndicator: activityIndicator)
    }
    
    
    func drawPolyline(coordinates: [CLLocationCoordinate2D]) {
        
        mapView.drawPath(coordinates: coordinates)
        //self.drawPath(coordinates: coordinates)
        
    }
    
    func finalLocations(locations: [LocationDataModel]) {
        
        self.plotMarkersInMap(location: LogicHelper.shared.sortOnlyLocations(location: locations))
        
    }
    
    
    
}











