//
//  NewCheckOutUserScreen.swift
//  bdPresence
//
//  Created by Raghvendra on 11/07/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import UIKit
import CoreLocation
class NewCheckOutUserScreen: UIViewController{
    
    
    var delegate: HandleUserViewDelegate?
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var tableView: UITableView!
    
    
    var locationData: [LocationDataModel]?{
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
        visualEffectView.applyGradient(isTopBottom: false, colorArray: [APPColor.BlueGradient,APPColor.GreenGradient])
        //visualEffectView.layer.masksToBounds = true
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
        
        if scrollView.contentOffset.y < -50 {
            tableView.isScrollEnabled = false
            delegate?.handleOnSwipe()
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewCheckOutUserScreenCell", for: indexPath) as! NewCheckoutCell
       setTeamDetails(cell: cell, indexPath: indexPath)

        
        return cell
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
    
    func setTeamDetails(cell: NewCheckoutCell, indexPath: IndexPath){
        
        
//        if indexPath.item == 0 {
//          cell.locationDetailLabel.text = "Current Location"
//        }else{
//          cell.locationDetailLabel.text = "Location name"
//        }
        
        
        if let location = locationData?[indexPath.item].address{
            
            cell.addressLabel.text = location
            
        }else{
            
            if let lat = locationData?[indexPath.item].latitude, let long = locationData?[indexPath.item].longitude{
                
                
                if let locationLat = CLLocationDegrees(lat),let locationLong = CLLocationDegrees(long){
                   
                    let location = CLLocation(latitude: CLLocationDegrees(locationLat), longitude: CLLocationDegrees(locationLong))
                    LogicHelper.shared.reverseGeoCode(location: location) { (address) in
                        self.locationData?[indexPath.item].address = address
                        cell.addressLabel.text = address
                    }
                    
                }
                
                
            }
            
        }
    
        
    }
    
    
}
