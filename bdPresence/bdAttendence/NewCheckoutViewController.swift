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
    
    var activityIndicator =  ActivityIndicatorView()
    var pullController: SearchViewController!
    
    
    //MARK: View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shiftRelatedDetails()
        setupNavigationBar()
        addObservers()
        setupGestures()
        setupMap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.view.removeActivityIndicator(activityIndicator: activityIndicator)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @IBAction func handleSync(_ sender: Any) {
        
        
        activityIndicator = ActivityIndicatorView()
        
        self.view.showActivityIndicator(activityIndicator: activityIndicator)
        let queryStr = "&assignmentStartTime=" + ((Calendar.current.date(byAdding: .day, value: -15, to: Date()))?.formattedISO8601)! + AppConstants.AssignmentUrls.query
        
        AssignmentModel.getAssignmentsForDesiredTime(query: queryStr) { (completionStatus) in
            self.view.removeActivityIndicator(activityIndicator: self.activityIndicator)
            UI {
                print("completionstatus = \(completionStatus)")
                if completionStatus == "Success" {
                    UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.LastAssignmentFetched.rawValue)
                }
                
                if AssignmentModel.statusOfUser() {
                    
                    self.callDashboard()
                    
                    
                } else {
                    
                    bdCloudStartMonitoring()
                    UserDefaults.standard.set("1", forKey: "AlreadyCheckin")
                    
                }
            }
        }
        
        
        
    }
    
}



// Upon user avaibility call these methods

extension NewCheckoutViewController{
    func callDashboard(){
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
        
    }
    
    func userAvailable(){
        
        bdCloudStartMonitoring()
        UserDefaults.standard.set("1", forKey: "AlreadyCheckin")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifcation.Dashboard.rawValue), object: self, userInfo: nil)
        
    }
    
}

//MARK: Setup UI Elements
extension NewCheckoutViewController{
    
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(NewCheckoutViewController.discardFakeLocations(notification:)), name: NSNotification.Name(rawValue: LocalNotifcation.RMCPlacesFetched.rawValue), object: nil)
    }
    
    func setupNavigationBar(){
        todaysDateLbl.text = LogicHelper.shared.dashBoardDate(date: Date())
        navigationController?.removeTransparency()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(menuAction(sender:)))
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: APPFONT.DAYHEADER!]
        
        if SDKSingleton.sharedInstance.noTouchMode == true && SDKSingleton.sharedInstance.strictMode == true{
            manualSwipeDisableHieghtAnchor.constant = 0
            upperView.isHidden = true
        }else{
            manualSwipeDisableHieghtAnchor.constant = 90
            upperView.isHidden = false
        }
    }
    
    @objc  func menuAction(sender:UIBarButtonItem){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowSideMenu"), object: nil)
        
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
    
    
    @objc func handleGesture(sender:UIGestureRecognizer){
        
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.ManualSwipe.rawValue)
        UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.ManualSwipedDate.rawValue)
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.ManualSwipeDown.rawValue)
        UserDefaults.standard.synchronize()
        
        if let swipeGesture = sender as? UISwipeGestureRecognizer {
            switch swipeGesture.direction{
            case .down:
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
    
    
    func setupMap(){
        mapView.changeStyle()
        mapView.setupCamera()
    }
    
    
    func clearMapData(){
        self.view.removeActivityIndicator(activityIndicator: activityIndicator)
        mapView.clear()
        if let _ = pullController{
            self.removePullUpController(pullController, animated: true)
            
        }
    }
    
    
    
}





//MARK: Call Filters on Checkouts

extension NewCheckoutViewController{
    
    
    // This method invoke after every checkin creation
    
    @objc func discardFakeLocations(notification: Notification){
        
        
        if let data = notification.userInfo as? [String: Any]{
            
            if let _ = data["checkInId"] as? String{
                updateView()
                let superController = SuperViewController()
                superController.getPlacesAfterTenMinutes()
            }
            
            
            
            
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
                    
                    getDataIfTenMinutes(date: date)
                    
                }
                
                
            }
            
        }
        
    }
    
    
}


extension  NewCheckoutViewController: LocationsFilterDelegate, PolylineStringDelegate{
    func onFailure(type: ErrorMessages) {
        
        self.view.removeActivityIndicator(activityIndicator: activityIndicator)
        
        
        if type == .noCheckInFound{
        }else{
            AlertsController.shared.displayAlertWithoutAction(whereToShow: self, message: type.rawValue)
        }
    }
    
    
    func drawPolyline(coordinates: [CLLocationCoordinate2D]) {
        mapView.drawPath(coordinates: coordinates)
    }
    
    
    
    
    func finalLocations(locations: [LocationDataModel]) {
        
        self.view.removeActivityIndicator(activityIndicator: activityIndicator)
        
        if locations.count > 0{
            
            let allLocations = UserPlace.getGeoTagData(location: LogicHelper.shared.sortOnlyLocations(location: locations))
            mapView.addMarkersInMap(allLocations: allLocations)
            
            
            let locations = ClusterDataFromServer.convertDataToUserModel(locationData: LogicHelper.shared.sortGeoLocations(locations: allLocations).reversed())
            let headerData = ClusterDataFromServer.getHeaderData(locationData: locations)
            dataFromServer(locationData: locations, headerData: headerData)
        }
        
        
    }
    
    
    
}



extension NewCheckoutViewController: ServerDataFromClusterDelegate{
    
    func dataFromServer(locationData: [UserDetailsDataModel], headerData: [String]) {
        
        if let controller = pullController{
            
            if  ClusterDataFromServer.checkIfNewDataCameFromServer(firstData: controller.userDetails, secondData: locationData){
                showPullController(locationData: locationData, headerData: headerData)
            }
            
        }else{
            showPullController(locationData: locationData, headerData: headerData)
            
        }
        
        
    }
    
    func showPullController(locationData: [UserDetailsDataModel], headerData: [String]){
        clearMapData()
        
        
        pullController = UIStoryboard(name: "NewDesign", bundle: nil)
            .instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
        pullController.screenType = LocationDetailsScreenEnum.dashBoardScreen
        
        mapView.addMarkersInMap(allLocations: locationData)
        
        pullController.userDetails = locationData
        pullController.distanceArray = headerData
        self.addPullUpController(pullController, initialStickyPointOffset: UIScreen.main.bounds.height * 0.3, animated: true)
        
        let polyLine = DrawPolyLineInMap()
        polyLine.delegate = self
        polyLine.getPolyline(location: locationData.reversed())
        
        
    }
    
    
    
}

// Call The Cluster api after 10 min other wise it will pick it from database

extension NewCheckoutViewController: ServerResponseDelegate{
    
    func getDataIfTenMinutes(date: Date){
        
        if let valueForDashBoard = UserDefaults.standard.value(forKey: "lastDashBoardUpdated") as? Date{
            
            if let data = UserDayData.getLocationDataFromServer(date: date){
                
                if Date().secondsFrom(valueForDashBoard) > 600{
                    getDataFromServer(date: date)
                }
                
                let headerData = ClusterDataFromServer.getHeaderData(locationData: data)
                dataFromServer(locationData: data, headerData: headerData)
            }else{
                getDataFromServer(date: date)
            }
            
            
        }else{
            getDataFromServer(date: date)
        }
        
    }
    
    func getDataFromServer(date: Date){
        let serverData = checkinFromServerManager()
        serverData.delegate = self
        serverData.getClusterData(query: GetClusteringFromServer.quoteString(date: date), date: date)
    }
    
    
    // Delegate response from Cluster data from sdk
    
    func successData<T>(data: T) {
        
        UserDefaults.standard.set(Date(), forKey: "lastDashBoardUpdated")
        if let locationData = data  as? [UserDetailsDataModel]{
            let headerData = ClusterDataFromServer.getHeaderData(locationData: locationData)
            dataFromServer(locationData: locationData, headerData: headerData)
        }
        
        
    }
    
    func errorData<T>(error: T) {
        
        if let getError = error as? String{
            if getError == "No Data"{
                let databaseData = LocationFilters()
                databaseData.delegate = self
                databaseData.plotMarkers(date: Date())
                
            }
            
            if getError == "NoShift"{
                callDashboard()
            }
            
            
        }
    }
    
}
