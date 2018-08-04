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


class MyLocationViewController: UIViewController{
    
    @IBOutlet weak var userLocationContainerView: UIView!
    
    @IBOutlet weak var userLocationCardHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var mapView: GMSMapView!
    var userContainerView: MyLocationTableView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureInContainerView()
        setupNavigation()
        setupMap()
        userLocationCardHeightAnchor.constant = UIScreen.main.bounds.size.height - (UIScreen.main.bounds.size.height * 0.2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "My Location"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        title = ""
    }
    
    
}


extension MyLocationViewController{
    
    func setupNavigation(){
        //navigationController?.removeTransparency()
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: APPFONT.DAYHEADER!]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu")?.withRenderingMode(.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(menuAction(sender:)))
    }
    
    func menuAction(sender:UIBarButtonItem){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowSideMenu"), object: nil)
        
    }
}


extension MyLocationViewController{
    
    func setupMap(){
        
        //mapView.changeStyle()
        mapView.delegate = self
        let marker = GMSMarker()
        marker.position = CurrentLocation.coordinate
        
        marker.title = "\(CurrentLocation.time)"
        marker.snippet = CurrentLocation.address
        marker.isDraggable = true
        marker.map = mapView
        
        let camera = GMSCameraPosition.camera(withLatitude: CurrentLocation.coordinate.latitude, longitude: CurrentLocation.coordinate.longitude, zoom: 17.0)
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
        
        if userLocationCardHeightAnchor.constant == 49 + 50 {
            animateContainerView(heightToAnimate: UIScreen.main.bounds.size.height - (UIScreen.main.bounds.size.height * 0.2))
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
        if segue.identifier == "userLocationSegue"{
            userContainerView = segue.destination as! MyLocationTableView
            userContainerView?.delegate = self
        }
    }
}


extension MyLocationViewController: HandleUserViewDelegate{
    
    func handleOnSwipe() {
        userLocationCardHeightAnchor.constant += 50
        self.view.layoutIfNeeded()
        handleTap()
    }
    
    
    
}


extension MyLocationViewController: GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        
    }
    
    
    
}
