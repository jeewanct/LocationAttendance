//
//  NewCheckOutUserScreen.swift
//  bdPresence
//
//  Created by Raghvendra on 11/07/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import UIKit
import CoreLocation


class UserDetailsDataModel{
    
    var lastSeen: String?
    var address: String?
    var isGeoTagged: Bool?
    var lat: CLLocationDegrees = 0
    var long: CLLocationDegrees = 0
    var cllLocation:  CLLocation = CLLocation()
}




class NewCheckOutUserScreen: UIViewController{
    
    
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
       
        
            tableView.estimatedRowHeight = 50
        
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
                        if let lastGeoTaggedElement = location.first{
                            
                            if let lastSeen = lastGeoTaggedElement.lastSeen{
                                lastSeenString.append(LogicHelper.shared.getLocationDate(date: lastSeen))
                            }
                            //userData.address = geoTagged.placeDetails?.address
                            
                        }
                        
                        
                        if let lastGeoTaggedElement = location.last{
                          
                            lastSeenString.append("-")
                            if let lastSeen = lastGeoTaggedElement.lastSeen{
                                lastSeenString.append(LogicHelper.shared.getLocationDate(date: lastSeen))
                            }
                            //userData.address = geoTagged.placeDetails?.address
                            
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
        setTeamDetails(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func setTeamDetails(cell: NewCheckoutCell, indexPath: IndexPath){
        
        if userDetails[indexPath.item].isGeoTagged == true{
            cell.geoTagLabel.text = ""
        }else{
            cell.geoTagLabel.text = "Geo-Tag this location"
        }
        
        
        cell.timeLabel.text = userDetails[indexPath.item].lastSeen
        if let address = userDetails[indexPath.item].address{
            cell.addressLabel.text = address
            
        }else{
            
            LogicHelper.shared.reverseGeoCodeGeoLocations(location: userDetails[indexPath.item].cllLocation, index1: indexPath.item, index2: 0) { (addrress, start, end) in
                
                self.userDetails[start].address =  addrress
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
    
    
//    func setTeamDetails(cell: NewCheckoutCell, indexPath: IndexPath){
//        if let locations = locationData{
//
//            for index in 0..<locations.count{
//
//                if locations[index].count > 1{
//                    setTimeSpend(locationData: locations[index], indexPath: indexPath, cell: cell)
//                    cell.addressLabel.text = locations[index][0].geoTaggedLocations?.placeDetails?.address
//                }
//
//                if locations[index].count == 1 {
//
//                    setTimeSpend(locationData: locations[index], indexPath: indexPath, cell: cell)
//                    if let address = locations[index][0].address{
//                        cell.addressLabel.text = address
//                    }else{
//
//                        if let lat = locations[index][0].latitude, let long = locations[index][0].longitude{
//
//                            if let cllLat = CLLocationDegrees(lat), let cllLong = CLLocationDegrees(long){
//                                LogicHelper.shared.reverseGeoCode(location: CLLocation(latitude: cllLat, longitude: cllLong)) { (address) in
//
//                                    self.locationData?[index][0].address = address
//                                    cell.addressLabel.text = address
//
//                                }
//
//                            }
//                        }
//
//
//                    }
//
//
//                }
//
//
//            }
//
//
//        }
//    }
//
//    func setTimeSpend(locationData: [LocationDataModel], indexPath: IndexPath, cell: NewCheckoutCell){
//
//        if locationData.count == 1{
//
//            if let firstLocation = locationData.first{
//                if let startingDate = firstLocation.lastSeen{
//                   cell.timeLabel.text = LogicHelper.shared.getLocationDate(date: startingDate)
//                }
//
//            }
//
//        }else{
//
//
//        if let firstLocation = locationData.first, let lastLocation = locationData.last{
//
//            var time = ""
//
//            if let startingDate = firstLocation.lastSeen{
//                time.append(LogicHelper.shared.getLocationDate(date: startingDate))
//            }
//
//            time.append("-")
//            if let endingDate = lastLocation.lastSeen{
//                time.append(LogicHelper.shared.getLocationDate(date: endingDate))
//            }
//
//
//            cell.timeLabel.text = time
//        }
//
//        }
//
//    }
    
//    func setTeamDetails(cell: NewCheckoutCell, indexPath: IndexPath){
//
//        if let locations = locationData{
//
//            for index in 0..<locations.count{
//
//
//                var firstDate = Date()
//                for index1 in 0..<locations[index].count{
//
//                    if let geoTag = locations[index][index1].geoTaggedLocations{
//
//                         cell.addressLabel.text = locations[index][index1].address
//
//                    }else{
//                         cell.addressLabel.text = locations[index][index1].address
//
//                        if let lastSeen = locations[index][index1].lastSeen{
//
//
//                            cell.timeLabel.text = LogicHelper.shared.getLocationDate(date: lastSeen)
//                        }
//
//
//                    }
//
//
//                }
//
//            }
//
//
//        }
//
//    }
    
//    func setTeamDetails(cell: NewCheckoutCell, indexPath: IndexPath){
//
//
////        if indexPath.item == 0 {
////          cell.locationDetailLabel.text = "Current Location"
////        }else{
////          cell.locationDetailLabel.text = "Location name"
////        }
//
//
//        if let location = locationData?[indexPath.item].address{
//
//            cell.addressLabel.text = location
//
//        }else{
//
//            if let lat = locationData?[indexPath.item].latitude, let long = locationData?[indexPath.item].longitude{
//
//
//                if let locationLat = CLLocationDegrees(lat),let locationLong = CLLocationDegrees(long){
//
//                    let location = CLLocation(latitude: CLLocationDegrees(locationLat), longitude: CLLocationDegrees(locationLong))
//                    LogicHelper.shared.reverseGeoCode(location: location) { (address) in
//                        self.locationData?[indexPath.item].address = address
//                        cell.addressLabel.text = address
//                    }
//
//                }
//
//
//            }
//
//        }
//
//
//    }
    
    
}
