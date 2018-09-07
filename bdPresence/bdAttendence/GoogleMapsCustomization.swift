//
//  GoogleMapsCustomization.swift
//  bdPresence
//
//  Created by Raghvendra on 10/07/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit


extension GMSMapView{
    
    func changeStyle(){
        do{
            guard let stylePath = Bundle.main.url(forResource: "CustomMap", withExtension: "json") else { return }
            mapStyle = try GMSMapStyle(contentsOfFileURL: stylePath)
            
        }catch let styleLoadError{
            print(styleLoadError.localizedDescription)
        }
    }
    
    func setupCamera(){
        let currentLocation = CLLocationManager()
        if let coordinates = currentLocation.location?.coordinate{
            
            let camera = GMSCameraPosition.camera(withLatitude: coordinates.latitude, longitude: coordinates.longitude, zoom: 15.0)
            self.camera = camera
            
        }
    }
    
    func addMarkersInMap(allLocations: [[LocationDataModel]]){
        
        for locations in allLocations{
            
            if let firstLocation = locations.first{
                
                if let firstLoc = firstLocation.geoTaggedLocations{
                    
                    self.addMarker(latitude: firstLoc.latitude, longitude: firstLoc.longitude, markerColor: #colorLiteral(red: 0.4431372549, green: 0.7176470588, blue: 0.8235294118, alpha: 1))
                }else{
                    self.addMarker(latitude: firstLocation.latitude, longitude: firstLocation.longitude, markerColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                }
                
                
            }
            
        }

    }
    
    
    func addMarker(latitude: String?, longitude: String?, markerColor: UIColor){
        let marker = GMSMarker()
        if let lat = latitude, let long = longitude{
            
            if let locationLat = CLLocationDegrees(lat), let locationLong = CLLocationDegrees(long){
                
                marker.position = CLLocationCoordinate2D(latitude:  locationLat, longitude: locationLong)
                
                let iconImageView = UIImageView(image: #imageLiteral(resourceName: "locationBlack").withRenderingMode(.alwaysTemplate))
                iconImageView.tintColor = markerColor
                marker.iconView = iconImageView
                
                marker.map = self
                
                
                let camera = GMSCameraPosition.camera(withLatitude: locationLat, longitude: locationLong, zoom: 15.0)
                self.camera = camera
                
                
                //path.add(CLLocationCoordinate2D(latitude: locationLat, longitude: locationLong))
            }
        }
        
    }
    
    func drawPath(coordinates: [CLLocationCoordinate2D]){
        
        var path = GMSMutablePath()
        for coordinate in coordinates{
            path.add(coordinate)
            
        }
        
        if coordinates.count > 1 {
            let bounds = GMSCoordinateBounds(path: path)
            self.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 40))
        }
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = .black
        polyline.strokeWidth = 3
        polyline.map = self
        
        
        
    }
}
