//
//  GeoTagController.swift
//  bdPresence
//
//  Created by Raghvendra on 11/07/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import UIKit
import GoogleMaps
import BluedolphinCloudSdk


class GeoTagController: UIViewController{
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
    }
    
    func setupMap(){
        
        mapView.changeStyle()
        
        let marker = GMSMarker()
        
        
        marker.position = CurrentLocation.coordinate
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        let camera = GMSCameraPosition.camera(withLatitude: CurrentLocation.coordinate.latitude, longitude: CurrentLocation.coordinate.longitude, zoom: 12.0)
        mapView.camera = camera
        
        
    }
}
