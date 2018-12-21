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
import RealmSwift
class MyTeamViewController: UIViewController{
    
   
    @IBOutlet weak var mapView: GMSMapView!
    

    var teamData: [MyTeamData]?
    //var errorView :ErrorScanView!
    let activityIndicator = ActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        setupNavigation()
        getTeamLocation()
    }
    
    func addPullController(teamData: [MyTeamData]?){
        guard let pullController = UIStoryboard(name: "NewDesign", bundle: nil)
            
            .instantiateViewController(withIdentifier: "MyTeamTableView") as? MyTeamTableView else{
                return 
        }
        pullController.teamData = teamData
        self.addPullUpController(pullController, initialStickyPointOffset: UIScreen.main.bounds.height * 0.3, animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "My Team"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        title = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

extension MyTeamViewController{
    
    func addMarkersInMap(teamDetails: [MyTeamData]?){
        
        guard let getTeamDetails = teamDetails else {
            return
        }
        
        
       
        
        for teams in getTeamDetails{
            
            if let coordinates = teams.userOb?.userStatus?.location?.coordinates{
                
                if coordinates.count == 2 {
                    let long = coordinates[0]
                    let lat = coordinates[1]
                   
                    
                    
                    
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
                    
                   // marker.title = "Sydney"
                    marker.icon = #imageLiteral(resourceName: "employeeImage")
                    //marker.snippet = "Australia"
                    marker.map = mapView
                    
                    if let name = teams.userOb?.userDetails?.name{
                        
                        var userName = ""
                        if let firstname = name.first{
                            userName = firstname + " "
                        }
                        
                        if let lastname = name.last{
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
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: APPFONT.DAYHEADER!]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(menuAction(sender:)))
    }
    
  @objc  func menuAction(sender:UIBarButtonItem){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowSideMenu"), object: nil)
        
    }
    
   
    
    
}



extension MyTeamViewController{
    
    
    
    
    
    func setupMap(){
        
         mapView.changeStyle()
        
       
        let locationManage = CLLocationManager()
        
        if let lat = locationManage.location?.coordinate.latitude, let long = locationManage.location?.coordinate.longitude {
            

            
            
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
            mapView.camera = camera
        }
        
        
        
        
    }
    
   
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "MyTeamSegueIdentifier"{
//            userContainerView = segue.destination as! MyTeamTableView
//            userContainerView?.delegate = self
//        }
//    }
    
    
}


//extension MyTeamViewController: HandleUserViewDelegate{
//
////    func handleOnSwipe() {
////         userLocationCardHeightAnchor.constant += 5
////        self.view.layoutIfNeeded()
////        handleTap()
////    }
//
//
//}


extension MyTeamViewController{
    func getTeamLocation(){
        
        view.showActivityIndicator(activityIndicator: activityIndicator)
        
        MyTeamModel.getTeamMember(completion: { (data) in
            
            self.performOperations(data: data)
        }) { (error) in
            self.hideActivityIndicator()
        }
        
    }
    
    func performOperations(data: [MyTeamData]?){
        
        self.hideActivityIndicator()
        
        if let myTeamData = data{
            self.teamData = myTeamData
            if myTeamData.count > 0 {
                addMarkersInMap(teamDetails: myTeamData)
                addPullController(teamData: myTeamData)
            }
            
        }
       
        
    }
    
  
    
    func hideActivityIndicator(){
        self.view.removeActivityIndicator(activityIndicator: activityIndicator)
    }
    
    
}
