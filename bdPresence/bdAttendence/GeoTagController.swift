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
    @IBOutlet weak var currenLocationTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var geoFenceRadiusSlider: UISlider!
    @IBOutlet weak var saveLocationTextField: UITextField!
    @IBOutlet weak var visualEffect: UIVisualEffectView!
    @IBOutlet weak var geoFenceRadiusDistance: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        setupFields()
        title = "Geo Tag"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        visualEffect.applyGradient(isTopBottom: false, colorArray: [APPColor.BlueGradient,APPColor.GreenGradient])
        visualEffect.layer.masksToBounds = true

    }
    
    @IBAction func handleClose(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleGeoFenceSlider(_ sender: Any) {
        
        if let geoFenceSlider = sender as? UISlider{
            
            let fenceRadius = Double(geoFenceSlider.value)
            geoFenceRadiusDistance.text = "Geo fence radius - \(Int(fenceRadius))m"
            geoFenceCircle.radius = fenceRadius
            
        }
        
    }
    
    
    func setupMap(){
        
    
        let marker = GMSMarker()
        
    
        marker.position = CurrentLocation.coordinate
        marker.title = "\(CurrentLocation.time)"
        marker.snippet = CurrentLocation.address
        marker.icon = #imageLiteral(resourceName: "geoMarker")
        marker.map = mapView
        
        // Draw Geo Fence
        geoFenceCircle.map = mapView

        
        let camera = GMSCameraPosition.camera(withLatitude: CurrentLocation.coordinate.latitude, longitude: CurrentLocation.coordinate.longitude, zoom: 17.0)
        mapView.camera = camera
        
        
    }
    
    
    
    func setupFields(){
        currenLocationTextField.text = CurrentLocation.address
        
        geoFenceRadiusSlider.minimumValue = 0
        geoFenceRadiusSlider.maximumValue = 500
        geoFenceRadiusSlider.value = 50
        
        
        //visualEffect.applyGradient(isTopBottom: false, colorArray: [APPColor.BlueGradient,APPColor.GreenGradient])
        visualEffect.layer.masksToBounds = true
    }
    
    
    
    lazy var geoFenceCircle: GMSCircle = {
       let circle = GMSCircle()
        circle.radius = 50
        circle.fillColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 0.5)
        circle.position = CurrentLocation.coordinate
        circle.strokeWidth = 0
        return circle
    }()
   
    
}
