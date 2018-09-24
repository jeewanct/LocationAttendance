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
    
    @IBOutlet weak var todaysDateLbl: UILabel!
    @IBOutlet weak var checkoutButton: UIImageView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var endYourDayLabel: UILabel!
    @IBOutlet weak var lastCheckinAddressLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var upperView: UIView!
    var swipedown :UISwipeGestureRecognizer?
    // @IBOutlet weak var syncButton: UIBarButtonItem!
    @IBOutlet weak var manualSwipeDisableHieghtAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var shiftSyncBarBtn: UIBarButtonItem!
    
    
    
    var activityIndicator: ActivityIndicatorView?
    var polyline = GMSPolyline()
    var animationPolyline = GMSPolyline()
    var path = GMSMutablePath()
    var animationPath = GMSMutablePath()
    var i: UInt = 0
    var timer: Timer!
    var animate = false
    
    var pullController: SearchViewController!
    var placeIndicator: RmcPlaceIndicator?
    
    
    //MARK: View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shiftRelatedDetails()
        setupNavigationBar()
        addObservers()
        setupGestures()
        setupMap()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //getPlacesAfterTenMinutes()
        // checkStatus()
        animate = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getDateFromServer()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animate = false
        if let _ = self.timer {
            self.timer.invalidate()
            self.timer = nil
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleSync(_ sender: Any) {
        
        
        activityIndicator = ActivityIndicatorView()
        
        self.view.showActivityIndicator(activityIndicator: activityIndicator!)
        let queryStr = "&assignmentStartTime=" + ((Calendar.current.date(byAdding: .day, value: -15, to: Date()))?.formattedISO8601)! + AppConstants.AssignmentUrls.query
        
        AssignmentModel.getAssignmentsForDesiredTime(query: queryStr) { (completionStatus) in
            self.view.removeActivityIndicator(activityIndicator: self.activityIndicator!)
            UI {
                print("completionstatus = \(completionStatus)")
                if completionStatus == "Success" {
                    UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.LastAssignmentFetched.rawValue)
                }
                
                if AssignmentModel.statusOfUser() {
                    
                    bdCloudStopMonitoring()
                    //                    self.shiftSyncBarBtn.isEnabled = true
                    //                    self.shiftSyncBarBtn.tintColor = APPColor.BlueGradient
                    UserDefaults.standard.set("2", forKey: "AlreadyCheckin")
                    UI {
                        if isInternetAvailable(){
                            CheckinModel.postCheckin()
                        }
                        
                    }
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.Dashboard.rawValue), object: self, userInfo: nil)
                    
                } else {
                    
                    bdCloudStartMonitoring()
                    UserDefaults.standard.set("1", forKey: "AlreadyCheckin")
                    //                    self.shiftSyncBarBtn.isEnabled = false
                    //                    self.shiftSyncBarBtn.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    
                }
            }
        }
        
        
        
    }
    
    
    //    func checkStatus(){
    //        if AssignmentModel.statusOfUser() {
    //
    //
    //            //UserDefaults.standard.set(false, forKey: UserDefaultsKeys.ManualSwipeDown.rawValue)
    //
    //            UI {
    //                UserDefaults.standard.set("2", forKey: "AlreadyCheckin")
    //                UserDefaults.standard.set(true, forKey: "DownDueToStatusChange")
    //                UserDefaults.standard.synchronize()
    //                // New change on 20/06/2018 to create one checkin
    //                if isInternetAvailable(){
    //                    CheckinModel.postCheckin()
    //                }
    //
    //                bdCloudStopMonitoring()
    //
    //                NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.CheckinScreen.rawValue), object: self, userInfo: ["check":true])
    //
    //            }
    //
    //
    //        } else {
    //            UserDefaults.standard.set(false, forKey: "DownDueToStatusChange")
    //
    //        }
    //    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    
    func updateAddress(sender: NSNotification) {
        DispatchQueue.main.async {
            
            self.lastCheckinAddressLabel.text = CurrentLocation.address
            
        }
    }
    
    
    
}


//MARK: Setup UI Elements
extension NewCheckoutViewController{
    
    func getDataFromCheckin(){
        updateView()
    }
    
    
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(NewCheckoutViewController.updateAddress(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.LocationUpdate.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewCheckoutViewController.showView), name: NSNotification.Name(rawValue: "CheckInsFromServer"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewCheckoutViewController.getDataFromCheckin), name: NSNotification.Name(rawValue: "CheckInsFromServerWithZeroElements"), object: nil)
        
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(NewCheckoutViewController.discardFakeLocations(notification:)), name: NSNotification.Name(rawValue: LocalNotifcation.RMCPlacesFetched.rawValue), object: nil)
    }
    
    func setupNavigationBar(){
        todaysDateLbl.text = LogicHelper.shared.dashBoardDate(date: Date())
        navigationController?.removeTransparency()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu")?.withRenderingMode(.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(menuAction(sender:)))
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: APPFONT.DAYHEADER!]
        
        if SDKSingleton.sharedInstance.noTouchMode == true && SDKSingleton.sharedInstance.strictMode == true{
            manualSwipeDisableHieghtAnchor.constant = 0
            upperView.isHidden = true
        }else{
            manualSwipeDisableHieghtAnchor.constant = 90
            upperView.isHidden = false
        }
    }
    
    func menuAction(sender:UIBarButtonItem){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowSideMenu"), object: nil)
        
    }
    
    func getPlacesAfterTenMinutes(){
        
        
        if let getPlacesSeconds = UserDefaults.standard.value(forKey: "RMCPlacesDuration") as? Date{
            
            
            if Date().secondsFrom(getPlacesSeconds) > 0{
                
                self.performSelector(inBackground: #selector(NewCheckoutViewController.getPlaces), with: nil)
                //RMCPlacesManager.getPlaces()
                
                //                placeIndicator = UIView.fromNib()
                //
                //                if let indicator = placeIndicator{
                //                    indicator.todaysDateLbl.startAnimating()
                //                    indicator.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
                //                    view.addSubview(indicator)
                //                  //  view.addConstraints(indicator: indicator)
                //                }
                
                
            }//else{
            //                activityIndicator = ActivityIndicatorView()
            //                if let indicator = activityIndicator{
            //                    view.showActivityIndicator(activityIndicator: indicator)
            //                }
            //
            //                updateView()
            //            }
            
        }else{
            
            //            placeIndicator = UIView.fromNib()
            //
            //            if let indicator = placeIndicator{
            //                indicator.todaysDateLbl.startAnimating()
            //                indicator.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            //                view.addSubview(indicator)
            //                //  view.addConstraints(indicator: indicator)
            //            }
            self.performSelector(inBackground: #selector(NewCheckoutViewController.getPlaces), with: nil)
            //RMCPlacesManager.getPlaces()
        }
        
    }
    
    
    func getPlaces(){
        RMCPlacesManager.getPlaces()
    }
    
    func setupGestures(){
        swipedown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipedown?.direction = .down
        setupSwipeFeature()
    }
    
    func setupSwipeFeature(){
        if let screenFlag = UserDefaults.standard.value(forKeyPath: "AlreadyCheckin") as? String {
            if screenFlag == "1" {
                
                let isToday = Calendar.current.isDateInToday(Date())
                if isToday{
                    self.navigationItem.title = "Today"
                    
                    self.view.addGestureRecognizer(self.swipedown!)
                    self.checkoutButton.isHidden = false
                    self.endYourDayLabel.isHidden = false
                }else{
                    self.navigationItem.title = Date().dayOfWeekFull()
                    self.checkoutButton.isHidden = true
                    self.endYourDayLabel.isHidden = true
                    self.view.removeGestureRecognizer(self.swipedown!)
                    
                }
                
            }
            
        }
    }
    
    
    func handleGesture(sender:UIGestureRecognizer){
        //print(dataArray)
        //Sourabh - When swiped down then we will not allow SDK to work as accordingly in RMCNotifier
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.ManualSwipe.rawValue)
        UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.ManualSwipedDate.rawValue)
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.ManualSwipeDown.rawValue)
        UserDefaults.standard.synchronize()
        
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
    
    func clearMapData(){
        mapView.clear()
        if let _ = timer{
            timer.invalidate()
            timer = nil
        }
        
        polyline = GMSPolyline()
        path.removeAllCoordinates()
        animationPath = GMSMutablePath()
        animationPolyline = GMSPolyline()
        i = 0
        
        if let _ = pullController{
            self.removePullUpController(pullController, animated: true)
            
        }
    }
    
    
    
}





//MARK: Call Filters on Checkouts

extension NewCheckoutViewController{
    
    func discardFakeLocations(notification: Notification){
        
        
        if let data = notification.userInfo as? [String: Any]{
            
            if let checkInId = data["checkInId"] as? String{
                checkIfNewLocationAdded(checkinId: checkInId)
            }
            
            
            if let status = data["status"] as? Bool{
                if status == true{
                    UserDefaults.standard.set(Date(), forKey: "RMCPlacesDuration")
                }else{
                    //                        if let indicator = activityIndicator{
                    //                            indicator.removeFromSuperview()//self.view.removeActivityIndicator(activityIndicator: indicator)
                    //                        }
                    
                }
            }
        }//else{
        //                activityIndicator = ActivityIndicatorView()
        //                if let indicator = activityIndicator{
        //                  //  view.showActivityIndicator(activityIndicator: activityIndicator!)
        //                    view.showActivityIndicator(activityIndicator: indicator)
        //                }
        //
        //        }
        
        //UserDefaults.standard.set(timeInSeconds(), forKey: "RMCPlacesDuration")
        
        
        
        // updateView()
    }
    
    
    func checkIfNewLocationAdded(checkinId: String){
        
        
        
        var present = false
        
        if let getPullController = pullController{
            if let allLocations = getPullController.locationData{
                
                for locations in allLocations{
                    
                    for location in locations{
                        if location.checkinId == checkinId{
                            present = true
                            break
                        }
                    }
                    
                }
                
            }
            
        }
        
        if present == false{
            // updateView()
            getDateFromServer()
        }
        
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
        //updateView()
        
    }
    
    func getDateFromServer(){
        
        if let valueForDashBoard = UserDefaults.standard.value(forKey: "lastDashBoardUpdated") as? Date{
            
            if let getDataIfAvail =  UserDayData.getLocationDataFromServer(date: Date()){
                
                if getDataIfAvail.count > 0 {
                    showDatabaseData(locationData: getDataIfAvail)
                }else{
                    activityIndicator = ActivityIndicatorView()
                    GetClusteringFromServer.getDataOf(date: Date())
                }
                
            }else{
                activityIndicator = ActivityIndicatorView()
                GetClusteringFromServer.getDataOf(date: Date())
            }
            
            
            
            //if Date().secondsFrom(valueForDashBoard) > 600{
                activityIndicator = ActivityIndicatorView()
                GetClusteringFromServer.getDataOf(date: Date())
            //}
            
        }else{
            activityIndicator = ActivityIndicatorView()
            GetClusteringFromServer.getDataOf(date: Date())
        }
        
        
        
    }
    
    func showDatabaseData(locationData: [UserDetailsDataModel]){
        
        
        pullController = UIStoryboard(name: "NewDesign", bundle: nil)
            .instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
        pullController.screenType = LocationDetailsScreenEnum.historyScreen
        
        // pullController.selectedDate = selectedDate
        pullController.userDetails = locationData
        
        var headerData = [String]()
        if let firstData = locationData.last{
            if let startTime = firstData.startTime{
                
                headerData.append(LogicHelper.shared.getLocationDate(date: startTime))
                
                
            }else{
                headerData.append("")
            }
        }
        
        var distance = 0
        for location in locationData {
            
            if let distanceDb = location.distance{
                distance = distance + distanceDb
            }
            
            
        }
        
        headerData.append(String(distance))
        
        headerData.append(String(locationData.count))
        
        pullController.distanceArray = headerData
        
        
        
        self.addPullUpController(pullController, animated: true)
        
        mapView.addMarkersInMap(allLocations: locationData)
        
        
        let polyLine = DrawPolyLineInMap()
        polyLine.delegate = self
        polyLine.getPolyline(location: locationData)
        
        
        
    }
    
    func showView(notification: Notification){
        
        
        if let activity = activityIndicator{
            self.view.removeActivityIndicator(activityIndicator: activity)
        }
        
        
        if let userNotification  = notification.userInfo as? [String: Any]{
            
            if let error = userNotification["status"] as? Bool{
                
                if !error{
                    AlertsController.shared.displayAlertWithoutAction(whereToShow: self, message: "Something went wrong.")
                }else{
                    
                    UserDefaults.standard.set(Date(), forKey: "lastDashBoardUpdated")
                    
                    if let getDataIfAvail =  UserDayData.getLocationDataFromServer(date: Date()){
                        
                        if getDataIfAvail.count > 0{
                            showDatabaseData(locationData: getDataIfAvail)
                        }else{
                            //                            AlertsController.shared.displayAlertWithoutAction(whereToShow: self, message: "No Checkins!")
                            updateView()
                        }
                        
                        
                        
                    }else{
                        AlertsController.shared.displayAlertWithoutAction(whereToShow: self, message: "No Checkins!")
                    }
                }
                
            }
            
        }
        
        
        
        
    }
    
    
    func plotMarkersInMap(location: [LocationDataModel]){
        
        let allLocations = UserPlace.getGeoTagData(location: location)
        if let indicator = activityIndicator{
            self.view.removeActivityIndicator(activityIndicator: indicator)
        }
        
        
        //        if let getIndicator = placeIndicator{
        //            getIndicator.removeFromSuperview()
        //        }
        
        clearMapData()
        
        mapView.addMarkersInMap(allLocations: allLocations)
        
        if allLocations.count != 0{
            
            
            
            UI{
                self.pullController = UIStoryboard(name: "NewDesign", bundle: nil)
                    .instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
                self.pullController.screenType = LocationDetailsScreenEnum.dashBoardScreen
                self.pullController.locationData = LogicHelper.shared.sortGeoLocations(locations: allLocations).reversed()
                self.addPullUpController(self.pullController, animated: true)
            }
            
            
            if !LogicHelper.shared.checkIfAllLocationsAreSame(locations: allLocations){
                let polyLine = PolyLineMap()
                polyLine.delegate = self
                // polyLine.allLocations = allLocations
                //polyLine.takePolyline()
                polyLine.getPolyline(location: LogicHelper.shared.sortGeoLocations(locations: allLocations))
            }
            
            
            
        }
        
        
    }
    
    func animatePolyline(){
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1), execute: {
            // Put your code which should be executed with a delay here
            self.animatePolylinePath()
        })
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
        
        if  UIApplication.shared.applicationState  == .background{
            
        }else{
            if animate == true{
                animatePolyline()
            }
            
        }
        
        
        
    }
    
    
    
}

extension  NewCheckoutViewController: LocationsFilterDelegate, PolylineStringDelegate{
    func onFailure(type: ErrorMessages) {
        if let indicator = activityIndicator{
            self.view.removeActivityIndicator(activityIndicator: indicator)
        }
        
        if type == .noCheckInFound{
        }else{
            AlertsController.shared.displayAlertWithoutAction(whereToShow: self, message: type.rawValue)
        }
    }
    
    
    func drawPolyline(coordinates: [CLLocationCoordinate2D]) {
        
        //var path = GMSMutablePath()
        for coordinate in coordinates{
            path.add(coordinate)
            // animationPath.add(coordinate)
        }
        
        polyline = GMSPolyline(path: path)
        //animationPolyline = GMSPolyline(path: path)
        
        
        
        mapView.drawPath(coordinates: coordinates)
        //self.drawPath(coordinates: coordinates)
        
        
        
        // animatePolyline()
    }
    
    func checkIfAllLocationsAreSame(locations: [[LocationDataModel]]) -> Bool{
        var firstCheckInId = ""
        if let firstCheckIn = locations.first{
            
            if let first = firstCheckIn.first{
                if let checkInId = first.geoTaggedLocations?.placeDetails?.placeId{
                    firstCheckInId = checkInId
                }else{
                    return false
                }
            }
            
        }
        for location in locations{
            
            if let firstLocation  = location.first{
                if firstLocation.geoTaggedLocations?.placeDetails?.placeId != firstCheckInId{
                    return false
                    
                }
            }
            
        }
        
        return true
        
    }
    
    
    func finalLocations(locations: [LocationDataModel]) {
        
        
        self.plotMarkersInMap(location: LogicHelper.shared.sortOnlyLocations(location: locations))
        
    }
    
    
    
}











