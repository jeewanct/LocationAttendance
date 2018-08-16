//
//  MyLocationViewController.swift
//  bdPresence
//
//  Created by Raghvendra on 11/07/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import UIKit
import GoogleMaps
import BluedolphinCloudSdk
import RealmSwift



class POIItem: NSObject, GMUClusterItem {
    var position: CLLocationCoordinate2D
    var name: String!
    
    init(position: CLLocationCoordinate2D, name: String) {
        self.position = position
        self.name = name
    }
}


class MyLocationViewController: UIViewController{
    
    @IBOutlet weak var userLocationContainerView: UIView!
    
    @IBOutlet weak var userLocationCardHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var mapView: GMSMapView!
    var myLocationArray: [RMCPlace]?
    var userContainerView: MyLocationTableView?
    
     var clusterManager: GMUClusterManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureInContainerView()
        setupNavigation()
        setupMap()
        setupClustering()
        getUserLocation()
        userLocationCardHeightAnchor.constant = UIScreen.main.bounds.size.height - (UIScreen.main.bounds.size.height * 0.3)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "My Location"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        title = ""
    }
    
    
    
    func setupClustering(){
        
        // Set up the cluster manager with default icon generator and renderer.
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
    
        
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
        
        // Generate and add random items to the cluster manager.
        //generateClusterItems()
        
        // Call cluster() after items have been added to perform the clustering and rendering on map.
       // clusterManager.cluster()
        
        // Register self to listen to both GMUClusterManagerDelegate and GMSMapViewDelegate events.
        clusterManager.setDelegate(self, mapDelegate: self)
        
        
    }
}


extension MyLocationViewController{
    
    func setupNavigation(){
        navigationController?.removeTransparency()
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: APPFONT.DAYHEADER!]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu")?.withRenderingMode(.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(menuAction(sender:)))
    }
    
    func menuAction(sender:UIBarButtonItem){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowSideMenu"), object: nil)
        
    }
}


extension MyLocationViewController{
    
    func setupMap(){
        
        mapView.changeStyle()
        mapView.delegate = self
        
        let camera = GMSCameraPosition.camera(withLatitude: CurrentLocation.coordinate.latitude, longitude: CurrentLocation.coordinate.longitude, zoom: 1.0)
        mapView.camera = camera
        
        
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
        
        if userLocationCardHeightAnchor.constant == 49 + 25 + 5 {
            animateContainerView(heightToAnimate: UIScreen.main.bounds.size.height - (UIScreen.main.bounds.size.height * 0.3))
        }else{
            // 400
             userContainerView?.tableView.isScrollEnabled = true
            animateContainerView(heightToAnimate: 49 + 25)
        }
    }
    
    func animateContainerView(heightToAnimate height: CGFloat){
        
        UIView.animate(withDuration: 0.5) {
            self.userLocationCardHeightAnchor.constant = height
            self.view.layoutIfNeeded()
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userLocationSegue"{
            userContainerView = segue.destination as! MyLocationTableView
            userContainerView?.delegate = self
        }
    }
}


extension MyLocationViewController: HandleUserViewDelegate{
    
    func handleOnSwipe() {
        userLocationCardHeightAnchor.constant += 5
        self.view.layoutIfNeeded()
        handleTap()
    }
    
    
    
}


extension MyLocationViewController: GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        
    }
    
    func getUserLocation(){
        
        let realm = try! Realm()
        let rmcPlaces = realm.objects(RMCPlace.self)
        
        var myLocations = [RMCPlace]()
        for places in rmcPlaces{
            myLocations.append(places)
            
        }
        
        //addMarkersGeoTaggedArea(locations: myLocations)
        generateClusterItems(location: myLocations)
        userContainerView?.places = myLocations
        
    }
    
    func addMarkersGeoTaggedArea(locations: [RMCPlace]){

        for location in locations{

            let marker = GMSMarker()

            if let lat = location.location?.latitude, let long = location.location?.longitude{

                if let locationLat = CLLocationDegrees(lat), let locationLong = CLLocationDegrees(long){

                    marker.position = CLLocationCoordinate2D(latitude:  locationLat, longitude: locationLong)

                    let iconImageView = UIImageView(image: #imageLiteral(resourceName: "locationBlack").withRenderingMode(.alwaysOriginal))
                    marker.iconView = iconImageView

                    marker.map = mapView


                    let camera = GMSCameraPosition.camera(withLatitude: locationLat, longitude: locationLong, zoom: 15.0)
                    mapView.camera = camera


                    //path.add(CLLocationCoordinate2D(latitude: locationLat, longitude: locationLong))

                }

            }

        }
    }
    
    
}


extension MyLocationViewController:  GMUClusterManagerDelegate{
    
    // MARK: - GMUClusterManagerDelegate
    
    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,
                                                 zoom: mapView.camera.zoom + 1)
        let update = GMSCameraUpdate.setCamera(newCamera)
        mapView.moveCamera(update)
        return false
    }
    
    // MARK: - GMUMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let poiItem = marker.userData as? POIItem {
            NSLog("Did tap marker for cluster item \(poiItem.name)")
        } else {
            NSLog("Did tap a normal marker")
        }
        return false
    }
    
    // MARK: - Private
    
    /// Randomly generates cluster items within some extent of the camera and adds them to the
    /// cluster manager.
    func generateClusterItems(location: [RMCPlace]) {
      
        for index in location{
            
            if let latString = index.location?.latitude, let longString = index.location?.longitude{
                
                if let lat = CLLocationDegrees(latString), let long = CLLocationDegrees(longString), let name = index.geoTagName{
                    
                    let item = POIItem(position: CLLocationCoordinate2D(latitude: lat, longitude: long), name: name)
                     clusterManager.add(item)
                    
                }
                
            }
            
        }
        
        clusterManager.cluster()
        
    }
    
    
    
    
   
}

 



