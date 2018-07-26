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
            dump(data)
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
                   locationData.accuracy = String(accuracy)
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
            
            userContainerView?.locationData = teamData
            userContainerView?.tableView.reloadData()
            
            
            
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
