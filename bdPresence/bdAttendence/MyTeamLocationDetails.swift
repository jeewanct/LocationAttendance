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
    
    @IBOutlet weak var userLocationCardHeightAnchor: NSLayoutConstraint!
    var userContainerView: NewCheckOutUserScreen?
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var userLocationContainerView: UIView!
    
    let activityIndicator = ActivityIndicatorView()
    
    
    
    var polyline = GMSPolyline()
    var animationPolyline = GMSPolyline()
    var path = GMSMutablePath()
    var animationPath = GMSMutablePath()
    var i: UInt = 0
    var timer: Timer!
    
    
    var teamMemberUserId: String?{
        didSet{
            getTeamMemberDetails()
        }
    }
    var teamMemberUserName: [String: String]?{
        didSet{
           setUpTitle()
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        addGestureInContainerView()
        userLocationContainerView.isHidden = true
        userLocationCardHeightAnchor.constant = (UIScreen.main.bounds.size.height - (UIScreen.main.bounds.size.height * 0.3))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let getTimer = self.timer{
            self.timer.invalidate()
        }
       
    }
}


extension MyTeamLocationDetails{
    
    func getTeamMemberDetails(){
        
        guard let getUserId = teamMemberUserId else{
            return
        }
        
        view.showActivityIndicator(activityIndicator: activityIndicator)
        
        
        MyTeamDetailsModel.getTeamMember(userId: getUserId, completion: { (data) in
           // dump(data)
            
            self.view.removeActivityIndicator(activityIndicator: self.activityIndicator)
            self.makeTeamLocationData(teamLocationData: data)
        }, inError: { (error) in
            self.view.removeActivityIndicator(activityIndicator: self.activityIndicator)
        })
    }
    
    
    func setUpTitle(){
    
        if let teamMember = teamMemberUserName{
            
            var userName = ""
            if let firstname = teamMember["first"]{
                userName = firstname + " "
            }
            
            if let lastname = teamMember["last"]{
                userName = userName + lastname
            }
            
            title = userName
        }
        
    }
    
    
    
    func makeTeamLocationData(teamLocationData: [MyTeamDetailsDocument]?){
        
        var teamData = [LocationDataModel]()
        
        
        if let getTeamLocation = teamLocationData{
            
            for location in getTeamLocation{
                
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
                    }
                    
                }
            
                teamData.append(locationData)
            }
            

            
            
            
        }
        
        
        LogicHelper.shared.plotMarkerInMap(locations: teamData) { (data) in
            self.plotMarkersInMap(location: teamData)
            
        }
        
        
       
        
        
        
        
    }
    
    func plotMarkersInMap(location: [LocationDataModel]){
        
        let allLocations = UserPlace.getGeoTagData(location: location)
        
        if allLocations.count == 0{
            userLocationContainerView.isHidden = true
        }else{
            
            userContainerView?.locationData = allLocations
            userLocationContainerView.isHidden = false
        }
        
        
        plotPathInMap(location: allLocations)
        
        
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
    
    
    func plotPathInMap(location: [[LocationDataModel]]){
        
        var originLatLong = ""
        
        if location.count > 2 {
        
            
                let firstLocation = location.first
                let secondLocation = location.last
                
                var orginDestinationString  =  "origin="
                if let  origin = firstLocation{
                    
                    for index in origin{
                        
                        if let geoTag = index.geoTaggedLocations{
                            
                            if let latitude = geoTag.latitude, let longitude = geoTag.longitude{
                                
                                orginDestinationString.append("\(latitude),\(longitude)")
                            }
                            
                        }else{
                            
                            if let latitude = index.latitude, let longitude = index.longitude{
                                orginDestinationString.append("\(latitude),\(longitude)")
                            }
                            
                        }
                    }
                }
        
            orginDestinationString.append("&destination=")
            
            if let  destination = secondLocation{
                
                for index in destination{
                    
                    if let geoTag = index.geoTaggedLocations{
                        
                        if let latitude = geoTag.latitude, let longitude = geoTag.longitude{
                            
                            orginDestinationString.append("\(latitude),\(longitude)")
                        }
                        
                    }else{
                        
                        if let latitude = index.latitude, let longitude = index.longitude{
                            orginDestinationString.append("\(latitude),\(longitude)")
                        }
                        
                    }
                }
            }
            
            
            
            GoogleUtils.getPolylineGoogle(originDestination: orginDestinationString) { (polyline) in
                
                let  coordinates: [CLLocationCoordinate2D]? = decodePolyline(polyline)
                
                if let getCoordinates = coordinates{
                    
                    self.drawPath(coordinates: getCoordinates)
                }
                
                
            }
            
            
        }
    
        
    }
    
    func drawPath(coordinates: [CLLocationCoordinate2D]){
        
       
        //let path = GMSMutablePath()
        
    
        for coordinate in coordinates{
            path.add(coordinate)
            
        }
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = .black
        polyline.strokeWidth = 3
        polyline.map = mapView
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(animatePolylinePath), userInfo: nil, repeats: true)
        
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
        
        // mapView.changeStyle()
        
        let marker = GMSMarker()
        
        
        
        
        var locationManage = CLLocationManager()
        locationManage.location?.coordinate.latitude
        
        
        
        
        
        if let lat = locationManage.location?.coordinate.latitude, let long = locationManage.location?.coordinate.longitude {
            
            
            
            
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
        
        if userLocationCardHeightAnchor.constant == 0 {
            animateContainerView(heightToAnimate: (UIScreen.main.bounds.size.height - (UIScreen.main.bounds.size.height * 0.3)))
        }else{
            // 400
            userContainerView?.tableView.isScrollEnabled = true
            
            animateContainerView(heightToAnimate: 0)
        }
        
        
    }
    
    func animateContainerView(heightToAnimate height: CGFloat){
        
        UIView.animate(withDuration: 0.5) {
            if height == (UIScreen.main.bounds.size.height - (UIScreen.main.bounds.size.height * 0.3)){
                self.userLocationContainerView.backgroundColor = .clear
                
            }else{
                self.userLocationContainerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.9016010123)
            }
            
            self.userLocationCardHeightAnchor.constant = height
            self.view.layoutIfNeeded()
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MyTeamLocationDetailsSegue"{
            userContainerView = segue.destination as! NewCheckOutUserScreen
            userContainerView?.delegate = self
        }
    }
    
    
}



extension MyTeamLocationDetails: HandleUserViewDelegate{
    
    func handleOnSwipe() {
        // userLocationCardHeightAnchor.constant += 50
        self.view.layoutIfNeeded()
        handleTap()
    }
    
    
}
