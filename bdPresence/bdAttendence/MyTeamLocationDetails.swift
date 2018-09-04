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
//        addGestureInContainerView()
//        userLocationContainerView.isHidden = true
//        userLocationCardHeightAnchor.constant = (UIScreen.main.bounds.size.height - (UIScreen.main.bounds.size.height * 0.3))
//
        
        NotificationCenter.default.addObserver(self, selector: #selector(MyTeamLocationDetails.teamDetailsFetch(locatins:)), name: NSNotification.Name(rawValue: LocalNotifcation.MyTeamDetailsByUserId.rawValue), object: nil)
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let getTimer = self.timer{
            self.timer.invalidate()
        }
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTeamMemberDetails()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
       // NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func teamDetailsFetch(locatins: Notification){
    
        
        print("LocationsCount = \(locatins.userInfo)")
    
        
        view.removeActivityIndicator(activityIndicator: activityIndicator)
        
        
        if let teamDetails = locatins.userInfo as? [String: Any]{
            
            if let error = teamDetails["status"] as? Bool{
                if let teamDetailsModel = teamDetails["teamDetails"] as? [MyTeamDetailsDocument]{
                    
                    if teamDetailsModel.count == 0{
                        if error == false{
                            AlertsController.shared.displayAlertWithoutAction(whereToShow: self, message: "Data fetch error!")
                        }
                    }else{
                        self.makeTeamLocationData(teamLocationData: teamDetailsModel)
                    }
                    
                }
                
            }
    
            
        }
        
    }
    
 }

 
 

extension MyTeamLocationDetails{
    
    func getTeamMemberDetails(){
        
        guard let getUserId = teamMemberUserId else{
            return
        }
        
        view.showActivityIndicator(activityIndicator: activityIndicator)
        
        
        MyTeamDetailsModel.getTeamMember(userId: getUserId)
 
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
    
    
    
    func makeTeamLocationData(teamLocationData: [MyTeamDetailsDocument]){
        
        var teamData = [LocationDataModel]()
        
        
       
            
            for location in teamLocationData{
                
                let locationData = LocationDataModel()
                
                if let accuracy = location.checkinData?.location?.accuracy{
                   locationData.accuracy = Double(accuracy)
                    
                }
                
                if let altitude = location.checkinData?.location?.altitude{
                    locationData.altitude = String(altitude)
                }
                
                
                if let coordinates = location.checkinData?.location?.coordinates{
                    
                    if coordinates.count  == 2{
                        
                        locationData.longitude = String(coordinates[0])
                        locationData.latitude = String(coordinates[1])
                    
                        if Int(coordinates[0]) == 0{
                            locationData.address = "No address found"
                        }
                    
                    }
                    
                    
                    
                }
                
                if let lastSeen = location.checkinData?.time{
                    locationData.lastSeen = Formatter.iso8601.date(from: lastSeen)
                }
                
                
                
                teamData.append(locationData)
            }
            
        
        
        //reversing the team data
        teamData.sort(by: { (first, second) -> Bool in
            
            
            if let firstDate = first.lastSeen , let secondDate = second.lastSeen{
                return  firstDate.compare(secondDate) == .orderedAscending
                
                
            }
            
            return false
        })
        
        let locationFilters = LocationFilters()
        locationFilters.delegate = self
        locationFilters.plotMarkerInMap(locations: teamData)
        
        
        
    }
    
    func plotMarkersInMap(location: [LocationDataModel]){
        
        let allLocations = UserPlace.getGeoTagData(location: location)
       
        if allLocations.count != 0{
             mapView.addMarkersInMap(allLocations: allLocations)
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
    
//    func getLocationCorrospondingLatLong(locations: [[LocationDataModel]]){
//
//
//        for index in 0..<locations.count{
//
//            for index1 in 0..<locations[index].count{
//
//                if let geoTaggedLocation = locations[index][index1].geoTaggedLocations{
//
//                    self.userContainerView?.locationData = locations
//
//                }else{
//
//                    if let lat = locations[index][index1].latitude, let long = locations[index][index1].longitude{
//
//                        if let latD = CLLocationDegrees(lat), let longD = CLLocationDegrees(long){
//
//                            let cllLocation = CLLocation(latitude: latD, longitude: longD)
//
//                            LogicHelper.shared.reverseGeoCodeGeoLocations(location: cllLocation, index1: index, index2: index1) { (address, firstIndex, secondIndex) in
//
//                                locations[firstIndex][secondIndex].address = address
//
//                               //if index == locations.count - 1{
//
//                                    self.userContainerView?.locationData = locations
//                                //}
//
//                            }
//
//                        }
//
//
//                    }
//
//
//
//                }
//
//
//            }
//        }
//
//        //self.userContainerView?.locationData = locations
//
//
//    }
    
    
    
    
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
    
//    func addGestureInContainerView(){
//
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//        userLocationContainerView.addGestureRecognizer(tapGesture)
//
//        let downGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleTap))
//        downGesture.direction = .up
//
//        userLocationContainerView.addGestureRecognizer(downGesture)
//
//    }
//
//
//    @objc func handleTap(){
//
//        print("View Tapped")
//
//        if userLocationCardHeightAnchor.constant == 0 {
//            animateContainerView(heightToAnimate: (UIScreen.main.bounds.size.height - (UIScreen.main.bounds.size.height * 0.3)))
//        }else{
//            // 400
//            userContainerView?.tableView.isScrollEnabled = true
//
//            animateContainerView(heightToAnimate: 0)
//        }
//
//
//    }
//
//    func animateContainerView(heightToAnimate height: CGFloat){
//
//        UIView.animate(withDuration: 0.5) {
//            if height == (UIScreen.main.bounds.size.height - (UIScreen.main.bounds.size.height * 0.3)){
//                self.userLocationContainerView.backgroundColor = .clear
//
//            }else{
//                self.userLocationContainerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.9016010123)
//            }
//
//            self.userLocationCardHeightAnchor.constant = height
//            self.view.layoutIfNeeded()
//
//        }
//
//    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "MyTeamLocationDetailsSegue"{
//            userContainerView = segue.destination as! NewCheckOutUserScreen
//            userContainerView?.delegate = self
//        }
//    }
    
    
}


//
//extension MyTeamLocationDetails: HandleUserViewDelegate{
//
//    func handleOnSwipe() {
//        // userLocationCardHeightAnchor.constant += 50
//        self.view.layoutIfNeeded()
//        handleTap()
//    }
//
//
//}

 
 
 
 extension  MyTeamLocationDetails: LocationsFilterDelegate, PolylineStringDelegate{
    func onFailure() {
        
    }
    
    
    func drawPolyline(coordinates: [CLLocationCoordinate2D]) {
        drawPath(coordinates: coordinates)
    }
    
    
    
    func finalLocations(locations: [LocationDataModel]) {
    
        //self.plotMarkersInMap(location: finalLocations)
        self.plotMarkersInMap(location: LogicHelper.shared.sortOnlyLocations(location: locations))
        
        
        
    }
    
    
    
    
 }
 
 
 
 

