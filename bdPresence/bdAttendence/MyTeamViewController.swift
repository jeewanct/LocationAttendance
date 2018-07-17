//
//  MyTeamViewController.swift
//  bdPresence
//
//  Created by Raghvendra on 12/07/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import UIKit
import GoogleMaps
import BluedolphinCloudSdk

class MyTeamViewController: UIViewController{
    
    @IBOutlet weak var userLocationContainerView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var userLocationCardHeightAnchor: NSLayoutConstraint!
    var userContainerView: MyTeamTableView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        addGestureInContainerView()
        setupNavigation()
        getTeamLocation()
        print("the base url is ", CONFIG.APIURL)
    }
    
}


extension MyTeamViewController{
    
    func setupNavigation(){
        navigationController?.removeTransparency()
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: APPFONT.DAYHEADER!]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu")?.withRenderingMode(.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(menuAction(sender:)))
    }
    
    func menuAction(sender:UIBarButtonItem){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowSideMenu"), object: nil)
        
    }
    
    
}



extension MyTeamViewController{
    
    
    
    
    
    func setupMap(){
        
        // mapView.changeStyle()
        
        let marker = GMSMarker()
        let locationManage = CLLocationManager()
        
        if let lat = locationManage.location?.coordinate.latitude, let long = locationManage.location?.coordinate.longitude {
            
            marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
            marker.title = "Sydney"
            marker.icon = #imageLiteral(resourceName: "employeeImage")
            marker.snippet = "Australia"
            marker.map = mapView
            
            
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
            mapView.camera = camera
        }
        
        
        
        
    }
    
    func addGestureInContainerView(){
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//        userLocationContainerView.addGestureRecognizer(tapGesture)
        
        let downGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleTap))
        downGesture.direction = .up
        
        userLocationContainerView.addGestureRecognizer(downGesture)
        
    }
    
    @objc func handleTap(){
        
        print("View Tapped")
        
        if userLocationCardHeightAnchor.constant == 50{
            animateContainerView(heightToAnimate: 376)
        }else{
            // 400
            userContainerView?.tableView.isScrollEnabled = true
            animateContainerView(heightToAnimate: 0)
        }
        
        
    }
    
    func animateContainerView(heightToAnimate height: CGFloat){
        
        UIView.animate(withDuration: 0.5) {
            self.userLocationCardHeightAnchor.constant = height
            self.view.layoutIfNeeded()
            
        }
 
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MyTeamSegueIdentifier"{
            userContainerView = segue.destination as! MyTeamTableView
            userContainerView?.delegate = self
        }
    }
    
    
}


extension MyTeamViewController: HandleUserViewDelegate{
    
    func handleOnSwipe() {
         userLocationCardHeightAnchor.constant += 50
        self.view.layoutIfNeeded()
        handleTap()
    }
    
    
}


extension MyTeamViewController{
    func getTeamLocation(){
        
        
    }
}
