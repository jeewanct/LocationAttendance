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

class MyTeamLocationDetails: UIViewController{
    
    @IBOutlet weak var userLocationCardHeightAnchor: NSLayoutConstraint!
    var userContainerView: NewCheckOutUserScreen?
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var userLocationContainerView: UIView!
    
    var teamMemberUserId: String?{
        didSet{
            getTeamMemberDetails()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        addGestureInContainerView()
    }
    
    
}


extension MyTeamLocationDetails{
    
    func getTeamMemberDetails(){
        
        guard let getUserId = teamMemberUserId else{
            return
        }
        
        MyTeamDetailsModel.getTeamMember(userId: getUserId, completion: { (data) in
           // dump(data)
            self.makeTeamLocationData(teamLocationData: data)
        }, inError: { (error) in
            
        })
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
            
//            userContainerView?.locationData = teamData
//            userContainerView?.tableView.reloadData()
            
            
            
        }
        
        setLocationOnMap(location: teamData)
        
        
        
        
    }
    
    func setLocationOnMap(location: [LocationDataModel]){
        
        
        LogicHelper.shared.plotMarkerInMap(locations: location) { (data) in
            self.plotMarkersInMap(location: data)
            
        }
        
    }
    
    
    func plotMarkersInMap(location: [LocationDataModel]){
        
        let allLocations = UserPlace.getGeoTagData(location: location)
        
        
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
    
    
    func addMarker(latitude: String?, longitude: String?,markerColor: UIColor){
        let marker = GMSMarker()
        if let lat = latitude, let long = longitude{
            
            if let locationLat = CLLocationDegrees(lat), let locationLong = CLLocationDegrees(long){
                
                marker.position = CLLocationCoordinate2D(latitude:  locationLat, longitude: locationLong)
                
                
                marker.title = "Sydney"
                marker.snippet = "Australia"
                marker.icon = #imageLiteral(resourceName: "locationBlack")
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
        
        if userLocationCardHeightAnchor.constant == 49 {
            animateContainerView(heightToAnimate: 400)
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
