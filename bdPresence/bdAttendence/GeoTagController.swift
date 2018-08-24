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
import GooglePlacesSearchController
import MapKit
class GeoTagController: UIViewController{
    
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var currenLocationTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var geoFenceRadiusSlider: UISlider!
    @IBOutlet weak var saveLocationTextField: UITextField!
    @IBOutlet weak var visualEffect: UIVisualEffectView!
    @IBOutlet weak var geoFenceRadiusDistance: UILabel!
    
    var geoTagLocation: CLLocation?
    var geoTagAddress: String?
    
    
    let marker = GMSMarker()
    
    var placeDetails: PlaceDetails?
    
    var editGeoTagPlace: RMCPlace?
    
    let activityIndicator = ActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        setupMap()
        setupFields()
        title = "Geo Tag"
        
        
        if let address = geoTagAddress,  let coordinates = geoTagLocation{
            
            marker.position = coordinates.coordinate
            geoFenceCircle.position = coordinates.coordinate
            currenLocationTextField.text = address
            mapView.animate(toLocation: coordinates.coordinate)
        }
        
        if let editPlace = editGeoTagPlace{
            
            setupEdit(place: editPlace)
        }
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        visualEffect.applyGradient(isTopBottom: false, colorArray: [APPColor.BlueGradient,APPColor.GreenGradient])
        visualEffect.layer.masksToBounds = true
        geoFenceRadiusSlider.maximumTrackTintColor = .white
        geoFenceRadiusSlider.minimumTrackTintColor = .white
        
        
    }
    
    @IBAction func handleClose(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleDone(_ sender: Any) {
        
        if checkEmpty() == ""{
            
            createServerBody()
            
        }else{
            
            let alerControlle = UIAlertController(title: "Warning", message: checkEmpty(), preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alerControlle.addAction(okButton)
            
            present(alerControlle, animated: true , completion: nil)
        }
        
        
    }
    
    
    func setupEdit(place: RMCPlace){
        
        currenLocationTextField.text = place.placeDetails?.address
        
        if let lat = place.location?.latitude, let long = place.location?.longitude{
            
            if let cllLat = CLLocationDegrees(lat), let cllLong = CLLocationDegrees(long){
                
                marker.position = CLLocationCoordinate2D(latitude: cllLat, longitude: cllLong)
                geoFenceCircle.position = CLLocationCoordinate2D(latitude: cllLat, longitude: cllLong)
                //currenLocationTextField.text = address
                mapView.animate(toLocation: CLLocationCoordinate2D(latitude: cllLat, longitude: cllLong))
                
            }
            
        }
        
        if let fenceRadius = place.placeDetails?.fenceRadius{
            
            geoFenceRadiusSlider.value = fenceRadius
            geoFenceRadiusDistance.text = "Geo fence radius - \(Int(fenceRadius))m"
        }
        
        
    }
    
    func geoTagOnMap(){
        
        
        
        
        
    }
    
    
    func createServerBody(){
        
      
        let geoTag = CreateGeoTagModel()
        
        let placeDetailsData = CreateGeoTagPlaceDetails()
        
        let addedOn = Date().formattedISO8601
        
        let placeId = UUID().uuidString
      
        
        placeDetailsData.editedBy = SDKSingleton.sharedInstance.userId
        placeDetailsData.addedBy = SDKSingleton.sharedInstance.userId
        placeDetailsData.fenceRadius = Int(geoFenceRadiusSlider.value)
        placeDetailsData.placeId = placeId
        placeDetailsData.placeType = "geofence"
        placeDetailsData.placeStatus = false
        
        
        
        geoTag.placeId = placeId
        geoTag.addedOn = addedOn
        geoTag.updateOn = addedOn
        geoTag.dObjectIds = []
        geoTag.userIds = [SDKSingleton.sharedInstance.userId]
        geoTag.PlaceLog = true
        geoTag.placeAddress = saveLocationTextField.text
        
        if let getPlacesFromGoogle = placeDetails{
            placeDetailsData.address = getPlacesFromGoogle.formattedAddress
            geoTag.latitude = getPlacesFromGoogle.coordinate?.latitude
            geoTag.longitude = getPlacesFromGoogle.coordinate?.longitude
            geoTag.placeAddress = getPlacesFromGoogle.formattedAddress
            geoTag.accuracy = "0"
            geoTag.altitude = "0"
            
        }else{
            
            geoTag.accuracy = CurrentLocation.accuracy
            geoTag.altitude = CurrentLocation.altitude
            
            
            geoTag.latitude = CurrentLocation.coordinate.latitude
            geoTag.longitude = CurrentLocation.coordinate.longitude
            
            LogicHelper.shared.reverseGeoCode(location: CLLocation(latitude: CurrentLocation.coordinate.latitude, longitude: CurrentLocation.coordinate.longitude)) { (address) in
                placeDetailsData.address = address
            }
            
            
        }
        
    
        
        geoTag.placeDetails = placeDetailsData
        
        
        callServer(geoTag: geoTag)
      
        
        
    }
    
    
    func callServer(geoTag: CreateGeoTagModel){
        
        view.showActivityIndicator(activityIndicator: activityIndicator)
        
        GeoTagManager.createGeoTag(geoTaggedData: [geoTag], completion: { (message) in
            self.view.removeActivityIndicator(activityIndicator: self.activityIndicator)
            
            self.showAlert(error: false, message: message)
            
        }) { (errorMessage) in
            self.view.removeActivityIndicator(activityIndicator: self.activityIndicator)
            self.showAlert(error: true, message: errorMessage)
        }
    }
    
    func createEditServerBody(){
        
        let geoTag = CreateGeoTagModel()
        
        let placeDetailsData = CreateGeoTagPlaceDetails()
        
        let updatedOn = Date().formattedISO8601
        
        //let placeId = UUID().uuidString
        
        
        placeDetailsData.editedBy = SDKSingleton.sharedInstance.userId
        
        if let addedBy = editGeoTagPlace?.placeDetails?.addedBy{
            placeDetailsData.addedBy = addedBy
            
        }
        
        placeDetailsData.fenceRadius = Int(geoFenceRadiusSlider.value)
        
        if let placeId = editGeoTagPlace?.placeId{
            placeDetailsData.placeId = placeId
            geoTag.placeId = placeId
            
        }
        
     
        placeDetailsData.placeType = "geofence"
        placeDetailsData.placeStatus = false
        
        
        if let addedOn = editGeoTagPlace?.addedOn{
            geoTag.addedOn = addedOn.formattedISO8601
        }
        
       // geoTag.addedOn = addedOn
        geoTag.updateOn = updatedOn
        geoTag.dObjectIds = []
        geoTag.userIds = [SDKSingleton.sharedInstance.userId]
        geoTag.PlaceLog = true
        geoTag.placeAddress = saveLocationTextField.text
        
        if let getPlacesFromGoogle = placeDetails{
            placeDetailsData.address = getPlacesFromGoogle.formattedAddress
            geoTag.latitude = getPlacesFromGoogle.coordinate?.latitude
            geoTag.longitude = getPlacesFromGoogle.coordinate?.longitude
            geoTag.placeAddress = getPlacesFromGoogle.formattedAddress
            geoTag.accuracy = "0"
            geoTag.altitude = "0"
            
        }else{
            
            geoTag.accuracy = CurrentLocation.accuracy
            geoTag.altitude = CurrentLocation.altitude
            
            
            geoTag.latitude = CurrentLocation.coordinate.latitude
            geoTag.longitude = CurrentLocation.coordinate.longitude
            
            LogicHelper.shared.reverseGeoCode(location: CLLocation(latitude: CurrentLocation.coordinate.latitude, longitude: CurrentLocation.coordinate.longitude)) { (address) in
                placeDetailsData.address = address
            }
            
            
        }
        
        
        
        geoTag.placeDetails = placeDetailsData
        
        
        callServer(geoTag: geoTag)
    }
    
    func showAlert(error: Bool, message: String){
        
        if error == true{
            
            AlertsController.shared.displayAlertWithoutAction(whereToShow: self, message: message)
            
        }else{
            
            AlertsController.shared.displayAlertWithoutAction(whereToShow: self, message: message)
        }
        
        
    }
    
    func checkEmpty() -> String{
        
        if currenLocationTextField.text == "" {
            return "Current Location cannot be empty"
        }
            
        else if saveLocationTextField.text == "" {
            return "Save as field cannot be empty"
        }
        
        return ""
        
        
        
    }
    
    @IBAction func handleGeoFenceSlider(_ sender: Any) {
        
        if let geoFenceSlider = sender as? UISlider{
            
            let fenceRadius = Double(geoFenceSlider.value)
            geoFenceRadiusDistance.text = "Geo fence radius - \(Int(fenceRadius))m"
            geoFenceCircle.radius = fenceRadius
            
        }
        
    }
    
    func setupZoom(sliderValue: Int){
        
        
    }
    
    
    func setupMap(){
        
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
    
    @IBAction func handleGoogePlaces(_ sender: Any) {
        present(placesSearchController, animated: true, completion: nil)
        
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
    
    
    lazy var placesSearchController: GooglePlacesSearchController = {
        let controller = GooglePlacesSearchController(delegate: self,
                                                      apiKey: AppConstants.GoogleConstants.GoogleApiKey,
                                                      placeType: .address,
                                                      
                                                      coordinate: CLLocationCoordinate2D(latitude: CurrentLocation.coordinate.latitude, longitude: CurrentLocation.coordinate.longitude)
            // Optional: radius: 10,
            // Optional: strictBounds: true,
            // Optional: searchBarPlaceholder: "Start typing..."
        )
        //Optional: controller.searchBar.isTranslucent = false
        //Optional: controller.searchBar.barStyle = .black
        //Optional: controller.searchBar.tintColor = .white
        //Optional: controller.searchBar.barTintColor = .black
        return controller
    }()
    
}


extension GeoTagController: GooglePlacesAutocompleteViewControllerDelegate {
    func viewController(didAutocompleteWith place: PlaceDetails) {
        print(place.description)
        
        placeDetails = place
        placesSearchController.isActive = false
        
        currenLocationTextField.text = place.formattedAddress
        
        if let coordinates = place.coordinate{
            marker.position = coordinates
            geoFenceCircle.position = coordinates
            
            mapView.animate(toLocation: coordinates)
        }
        
        // marker.position
        
    }
    
    
    
    
    
    //    func GeoTagController(didAutocompleteWith place: PlaceDetails) {
    //        print(place.description)
    //        placesSearchController.isActive = false
    //    }
    
}
