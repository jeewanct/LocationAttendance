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
    var teamData: [MyTeamDocument]?
    //var errorView :ErrorScanView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        addGestureInContainerView()
        setupNavigation()
        getTeamLocation()
        
       
        
    }
    
}

extension MyTeamViewController{
    
    func addMarkersInMap(teamDetails: [MyTeamDocument]?){
        
        guard let getTeamDetails = teamDetails else {
            return
        }
        
        for teams in getTeamDetails{
            
            if let coordinates = teams.userStatus?.location?.coordinates{
                
                if coordinates.count == 2 {
                    let long = coordinates[0]
                    let lat = coordinates[1]
                   
                    
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
                    
                   // marker.title = "Sydney"
                    marker.icon = #imageLiteral(resourceName: "employeeImage")
                    marker.snippet = "Australia"
                    marker.map = mapView
                    
                    if let name = teams.userDetails?.name{
                        
                        var userName = ""
                        if let firstname = name["first"]{
                            userName = firstname + " "
                        }
                        
                        if let lastname = name["last"]{
                            userName = userName + lastname
                        }
                        
                        marker.title = userName
                        
                    }
                    
                    
                    
//                    let camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long), zoom: 17.0)
//                    mapView.camera = camera
                }
            }
        }
        
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
    
    func showLoader(text:String = "Loading ..." ){
        AlertView.sharedInstance.setLabelText(text)
        AlertView.sharedInstance.showActivityIndicator(self.view)
        let delay = 10.0 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            AlertView.sharedInstance.hideActivityIndicator(self.view)
            //self.dismiss(animated: true, completion: nil)
        })
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            AlertView.sharedInstance.hideActivityIndicator(self.view)
        }
    }
    
    
}



extension MyTeamViewController{
    
    
    
    
    
    func setupMap(){
        
        // mapView.changeStyle()
        
       
        let locationManage = CLLocationManager()
        
        if let lat = locationManage.location?.coordinate.latitude, let long = locationManage.location?.coordinate.longitude {
            

            
            
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
        
        self.showLoader()
        
        
        MyTeamModel.getTeamMember(completion: {[weak self] (myTeamData) in
            print("Team Member data is ",dump(myTeamData))
            self?.hideLoader()
            self?.teamData = myTeamData
            self?.addMarkersInMap(teamDetails: self?.teamData)
            self?.userContainerView?.teamData = self?.teamData
            
        }) { (error) in
            self.hideLoader()
            print("the error in fetching team", error)
        }
        
    }
}
