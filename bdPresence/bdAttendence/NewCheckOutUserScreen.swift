//
//  NewCheckOutUserScreen.swift
//  bdPresence
//
//  Created by Raghvendra on 11/07/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import UIKit
import CoreLocation
import PullUpController

class UserDetailsDataModel{
    
    var lastSeen: String?
    var address: String?
    var isGeoTagged: Bool?
    var lat: CLLocationDegrees = 0
    var long: CLLocationDegrees = 0
    var cllLocation:  CLLocation = CLLocation()
    var geoLocationName =  ""
    var canGeoTag = false
    var checkInId = ""
    var latitude: String?
    var longitude: String?
    var distance: Double?
    var startTime: Date?
    
}




class NewCheckOutUserScreen: PullUpController{
    
    
    var delegate: HandleUserViewDelegate?
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var tableView: UITableView!
    
    
    var locationData: [[LocationDataModel]]?{
        didSet{
            
            makeRelevantData()
            // tableView.reloadData()
            
        }
    }
    
    var userDetails =  [UserDetailsDataModel](){
        
        didSet{
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.attach(to: self)
        tableView.estimatedRowHeight = 50
        
    }
    
    override var pullUpControllerPreferredSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 300.0)
    }
    
    override var pullUpControllerPreviewOffset: CGFloat {
        return 500
    }
    
    override var pullUpControllerMiddleStickyPoints: [CGFloat] {
        return [40.0]
    }
    
    override var pullUpControllerIsBouncingEnabled: Bool {
        return false
    }
    
    override var pullUpControllerPreferredLandscapeFrame: CGRect {
        return CGRect(x: 5, y: 5, width: 280, height: UIScreen.main.bounds.height - 10)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //visualEffectView.layer.masksToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        visualEffectView.applyGradient(isTopBottom: false, colorArray:
            [#colorLiteral(red: 0.4470588235, green: 0.662745098, blue: 0.8705882353, alpha: 1),#colorLiteral(red: 0.5019607843, green: 0.9294117647, blue: 0.968627451, alpha: 1)])
        
        
    }
    
    func makeRelevantData(){
        
        var user = [UserDetailsDataModel]()
        if let locations = locationData{
            
            
            
            for location in locations{
                
                let userData = UserDetailsDataModel()
                
                for locationDetail in location{
                    
                    if let geoTagged = locationDetail.geoTaggedLocations{
                        var lastSeenString = ""
                        userData.isGeoTagged = true
                        if let lastGeoTaggedElement = location.last{
                            
                            if let lastSeen = lastGeoTaggedElement.lastSeen{
                                lastSeenString.append(LogicHelper.shared.getLocationDate(date: lastSeen))
                            }
                            //userData.address = geoTagged.placeDetails?.address
                            
                        }
                        
                        
                        if let lastGeoTaggedElement = location.first{
                            
                            lastSeenString.append("-")
                            if let lastSeen = lastGeoTaggedElement.lastSeen{
                                lastSeenString.append(LogicHelper.shared.getLocationDate(date: lastSeen))
                            }
                            //userData.address = geoTagged.placeDetails?.address
                            
                        }
                        if let locationName = locationDetail.geoTaggedLocations?.locationName{
                           userData.geoLocationName = locationName
                        }
                        
                        userData.address = geoTagged.placeDetails?.address
                        userData.lastSeen = lastSeenString
                        
                        
                    }else{
                        
                        userData.isGeoTagged = false
                        if let lastSeen = locationDetail.lastSeen{
                            userData.lastSeen = LogicHelper.shared.getLocationDate(date: lastSeen)
                        }
                        
                        if let lat = locationDetail.latitude, let long = locationDetail.longitude{
                            
                            if let latitude = CLLocationDegrees(lat), let longitude = CLLocationDegrees(long){
                                userData.cllLocation = CLLocation(latitude: latitude, longitude: longitude)
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    
                }
                
                user.append(userData)
                
                
            }
            
            userDetails = user
            
            
            
        }
        
        
        
        
    }
    
    
    
}

extension NewCheckOutUserScreen: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationData?.count ?? 0 
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
        
        if scrollView.contentOffset.y < -5 {
            tableView.isScrollEnabled = false
            delegate?.handleOnSwipe()
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewCheckOutUserScreenCell", for: indexPath) as! NewCheckoutCell
        //setTeamDetails(cell: cell, indexPath: indexPath)
        //setTeamDetails(cell: cell, indexPath: indexPath)
        cell.delegate = self
        cell.currentIndex = indexPath.item
        setTeamDetails(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func setTeamDetails(cell: NewCheckoutCell, indexPath: IndexPath){
        
        if userDetails[indexPath.item].isGeoTagged == true{
            cell.geoTagButton.setTitle("", for: .normal)
           // cell.geoTagLabel.text = ""
        }else{
            cell.geoTagButton.setTitle("Geo-Tag this location", for: .normal)
          //  cell.geoTagLabel.text = "Geo-Tag this location"
        }
        
        
        cell.timeLabel.text = userDetails[indexPath.item].lastSeen
        if let address = userDetails[indexPath.item].address{
            cell.addressLabel.text = address
            
        }else{
            
            LogicHelper.shared.reverseGeoCodeGeoLocations(location: userDetails[indexPath.item].cllLocation, index1: indexPath.item, index2: 0) { (addrress, start, end) in
                
               /// self.userDetails[start].address =  addrress
                cell.addressLabel.text = addrress
                
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        if let getCell = cell as? NewCheckoutCell{
            if indexPath.item == 0 {
                getCell.locationDetailLabel.text = "Current Location"
            }else{
                getCell.locationDetailLabel.text = "Location name"
            }
            
        }
        
    }
    
    
}



extension NewCheckOutUserScreen: GeoTagLocationDelegate{
    
    func handleTap(currentIndex: Int) {
        
        let cllLocation = userDetails[currentIndex].cllLocation
        let address = userDetails[currentIndex].address
        
        let geoTagController = GeoTagController()
        geoTagController.geoTagLocation = cllLocation
        geoTagController.geoTagAddress = address
        
        navigationController?.pushViewController(geoTagController, animated: true)
        
    }
    
    
    
}


extension NewCheckOutUserScreen{
   
    
    
}
