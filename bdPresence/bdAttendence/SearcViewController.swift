//
//  SearchViewController.swift
//  PullUpControllerDemo
//
//  Created by Mario on 03/11/2017.
//  Copyright © 2017 Mario. All rights reserved.
//

import UIKit
import MapKit
import PullUpController

class SearchViewController: PullUpController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var secondPreviewHeight: NSLayoutConstraint!
    @IBOutlet private weak var visualEffectView: UIVisualEffectView!
    @IBOutlet private weak var searchBoxContainerView: UIView!
    @IBOutlet private weak var searchSeparatorView: UIView! {
        didSet {
            searchSeparatorView.layer.cornerRadius = searchSeparatorView.frame.height/2
        }
    }
    @IBOutlet private weak var firstPreviewView: UIView!
    @IBOutlet private weak var secondPreviewView: UIView!
   
    @IBOutlet weak var tableView: UITableView!
    
    
    var locationData: [[LocationDataModel]]?{
        didSet{
            
            makeRelevantData()
            // tableView.reloadData()
            
        }
    }
    
    var userDetails =  [UserDetailsDataModel](){
        
        didSet{
           // tableView.reloadData()
        }
    }
    
    var screenType: LocationDetailsScreenEnum?
    
    
    // MARK: - Lifecycle
    
    
    func setPreviewHeightConstant(){
        
        
        
        
        if screenType == LocationDetailsScreenEnum.dashBoardScreen{
             secondPreviewHeight.constant = UIScreen.main.bounds.height - 315
        }else if screenType == LocationDetailsScreenEnum.historyScreen{
            secondPreviewHeight.constant = UIScreen.main.bounds.height - 325
        }else{
            secondPreviewHeight.constant = UIScreen.main.bounds.height - 234
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(UIScreen.main.bounds.height)
        
       
        
        //visualEffectView.roundCorners([.topLeft, .topRight], radius: 15)
        setPreviewHeightConstant()
        tableView.estimatedRowHeight = 200
        
        tableView.attach(to: self)
        //setupDataSource()
        
        willMoveToStickyPoint = { point in
           
            print("willMoveToStickyPoint \(point)")
        }
        
        didMoveToStickyPoint = { point in
            
            print("didMoveToStickyPoint \(point)")
        }
        
        onDrag = { point in
            print("onDrag: \(point)")
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        visualEffectView.roundCorners([.topLeft, .topRight], radius: 15)
        visualEffectView.applyGradient(isTopBottom: false, colorArray:
            [#colorLiteral(red: 0.4470588235, green: 0.662745098, blue: 0.8705882353, alpha: 1),#colorLiteral(red: 0.5019607843, green: 0.9294117647, blue: 0.968627451, alpha: 1)])
        visualEffectView.alpha = 0.8
        
    }
    

    
    
    
    // MARK: - PullUpController
    
    override var pullUpControllerPreferredSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: secondPreviewView.frame.maxY)
    }
    
    override var pullUpControllerPreviewOffset: CGFloat {
        print(UIScreen.main.bounds.height * 0.2)
        return UIScreen.main.bounds.height * 0.2
    }
    
    override var pullUpControllerMiddleStickyPoints: [CGFloat] {
        return [firstPreviewView.frame.maxY]
    }
    
    
    override var pullUpControllerIsBouncingEnabled: Bool {
        return false
    }
    
    override var pullUpControllerPreferredLandscapeFrame: CGRect {
        return CGRect(x: 5, y: 5, width: 280, height: UIScreen.main.bounds.height - 10)
    }

}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if let lastStickyPoint = pullUpControllerAllStickyPoints.last {
            pullUpControllerMoveToVisiblePoint(lastStickyPoint, animated: true, completion: nil)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       // view.endEditing(true)
        ///pullUpControllerMoveToVisiblePoint(pullUpControllerMiddleStickyPoints[0], animated: true, completion: nil)
        
        //(parent as? MapViewController)?.zoom(to: locations[indexPath.row].location)
    }
}




extension SearchViewController{
    
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




extension SearchViewController: GeoTagLocationDelegate{
    
    func handleTap(currentIndex: Int) {
        
        let cllLocation = userDetails[currentIndex].cllLocation
        let address = userDetails[currentIndex].address
        
        let geoTagController = GeoTagController()
        geoTagController.geoTagLocation = cllLocation
        geoTagController.geoTagAddress = address
        
        navigationController?.pushViewController(geoTagController, animated: true)
        
    }
    
    
    
}


class SearchResultCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    func configure(title: String) {
        titleLabel.text = title
    }
}



