 //
//  MyTeamLocationDetails.swift
//  bdPresence
//
//  Created by Raghvendra on 13/07/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import UIKit
import GoogleMaps
import BluedolphinCloudSdk
import Polyline
 import RealmSwift
 
 
class MyTeamLocationDetails: UIViewController{
    
   
    var userContainerView: NewCheckOutUserScreen?
    
    @IBOutlet weak var mapView: GMSMapView!
   
    
    let activityIndicator = ActivityIndicatorView()
    
    
    
    var count = 0
    var polyline = GMSPolyline()
    var animationPolyline = GMSPolyline()
    var path = GMSMutablePath()
    var animationPath = GMSMutablePath()
    var i: UInt = 0
    var timer: Timer!
    
    
    var teamMemberUserId: String?
    var teamMemberUserName: Name?{
        didSet{
           setUpTitle()
        }
        
    }
    
     var pullController: SearchViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.removeTransparency()
        setupMap()
        getTeamMemberDetails()
        
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let getTimer = self.timer{
            self.timer.invalidate()
        }
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
       // NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    
    
 }

 
 

extension MyTeamLocationDetails{
    
    func getTeamMemberDetails(){
        
        guard let getUserId = teamMemberUserId else{
            return
        }
        
        view.showActivityIndicator(activityIndicator: activityIndicator)
        
        
        
        let convertedDate = Date().toString(dateFormat: "YYYYMMdd")
        let query = "{\"docId\":{\"$in\":[\"\(SDKSingleton.sharedInstance.organizationId)|\(getUserId)|\(convertedDate)\"]}}"
        
        
        if let getQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed){
           // GetCheckinsData.getClusterData(query: getQuery, date: date)
            
            let teamData = MyTeamDetailsModel()
            teamData.delegate = self
            teamData.getUserDobjId(query: getQuery)

        }
        
        
        
        
        //MyTeamDetailsModel.getTeamMember(userId: getUserId)
 
//        })
    }
    
    
    func setUpTitle(){
    
        if let teamMember = teamMemberUserName{
            
            var userName = ""
            if let firstname = teamMember.first{
                userName = firstname + " "
            }
            
            if let lastname = teamMember.last{
                userName = userName + lastname
            }
            
            title = userName
        }
        
    }
    
    
    func plotMarkersInMap(location: [LocationDataModel]){
        
        let allLocations = UserPlace.getGeoTagData(location: location)
       
        view.removeActivityIndicator(activityIndicator: activityIndicator)
        
        if allLocations.count != 0{
             mapView.addMarkersInMap(allLocations: allLocations)
            if let _ = pullController{
                self.removePullUpController(pullController, animated: true)
            }
            
            
            self.pullController = UIStoryboard(name: "NewDesign", bundle: nil)
                .instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
            self.pullController.screenType = LocationDetailsScreenEnum.myTeamScreen
            self.pullController.locationData = LogicHelper.shared.sortGeoLocations(locations: allLocations).reversed()
            self.addPullUpController(self.pullController, animated: true)
            
            
            if !LogicHelper.shared.checkIfAllLocationsAreSame(locations: allLocations){
                let polyLine = PolyLineMap()
                polyLine.delegate = self
                // polyLine.allLocations = allLocations
                //polyLine.takePolyline()
                polyLine.getPolyline(location: LogicHelper.shared.sortGeoLocations(locations: allLocations))
            }
//            let polyLine = PolyLineMap()
//            polyLine.delegate = self
//            // polyLine.allLocations = allLocations
//            //polyLine.takePolyline()
//            polyLine.getPolyline(location: LogicHelper.shared.sortGeoLocations(locations: allLocations))
            
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
    
    
    
}


extension MyTeamLocationDetails{
    
    func setupMap(){
        
         mapView.changeStyle()
        
        let marker = GMSMarker()
        
        
        
        
        var locationManage = CLLocationManager()
        locationManage.location?.coordinate.latitude
        
        
        
        
        
        if let lat = locationManage.location?.coordinate.latitude, let long = locationManage.location?.coordinate.longitude {
            
            
            
            
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
            mapView.camera = camera
        }
        
        
        
        
    }
    

    
    
}



 
 
 
 extension  MyTeamLocationDetails: LocationsFilterDelegate, PolylineStringDelegate{
    func onFailure(type: ErrorMessages) {
        view.removeActivityIndicator(activityIndicator: activityIndicator)
        AlertsController.shared.displayAlertWithoutAction(whereToShow: self, message: type.rawValue)
    }
    
    
    
    
    func drawPolyline(coordinates: [CLLocationCoordinate2D]) {
        
        mapView.drawPath(coordinates: coordinates)
        
    }
    
    
    
    func finalLocations(locations: [LocationDataModel]) {
    
        //self.plotMarkersInMap(location: finalLocations)
        self.plotMarkersInMap(location: LogicHelper.shared.sortOnlyLocations(location: locations))
        
        
        
    }
    
    
    
    
 }
 
 extension MyTeamLocationDetails: ServerDataFromClusterDelegate{
    
    func dataFromServer(locationData: [UserDetailsDataModel], headerData: [String]) {
        
        clearMapData()
        
        mapView.addMarkersInMap(allLocations: locationData)
        
        pullController = UIStoryboard(name: "NewDesign", bundle: nil)
            .instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
        pullController.screenType = LocationDetailsScreenEnum.myTeamScreen
        
        
        pullController.userDetails = locationData
        pullController.distanceArray = headerData
        self.addPullUpController(pullController, animated: true)
        
        let polyLine = DrawPolyLineInMap()
        polyLine.delegate = self
        polyLine.getPolyline(location: locationData)
        
        
    }
    
    func clearMapData(){
        mapView.clear()
        if let _ = timer{
            timer.invalidate()
            timer = nil
        }
        
//        polyline = GMSPolyline()
//        path.removeAllCoordinates()
//        animationPath = GMSMutablePath()
//        animationPolyline = GMSPolyline()
//        i = 0
        
        if let _ = pullController{
            self.removePullUpController(pullController, animated: true)
            
        }
    }
    
    
 }
 
 

 extension MyTeamLocationDetails: ServerResponseDelegate{
    
    func successData<T>(data: T) {
        
        view.removeActivityIndicator(activityIndicator: activityIndicator)
        if let locationData = data  as? [UserDetailsDataModel]{
            let headerData = ClusterDataFromServer.getHeaderData(locationData: locationData)
            dataFromServer(locationData: locationData, headerData: headerData)
        }
        
        
    }
    
    func errorData<T>(error: T) {
        view.removeActivityIndicator(activityIndicator: activityIndicator)
        if let getError = error as? String{
            AlertsController.shared.displayAlertWithoutAction(whereToShow: self, message: getError)
        }
    }
    
 }
