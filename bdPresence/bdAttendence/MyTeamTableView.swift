//
//  MyTeamTableView.swift
//  bdPresence
//
//  Created by Raghvendra on 12/07/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import UIKit
import BluedolphinCloudSdk
import CoreLocation


class MyTeamDetailsScreen{
    
    var name: String?
    var address: String?
    var cllocation = CLLocation()
}


class MyTeamTableView: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    var teamData: [MyTeamData]?{
        didSet{
            setData()
            tableView.reloadData()
        }
    }
    var delegate: HandleUserViewDelegate?
    var myTeamLocations = [MyTeamDetailsScreen]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setData(){
    
        
        if let myTeamData = teamData{
            
            
            
            for location in myTeamData{
                
                let locations = MyTeamDetailsScreen()
                
                if let teamMember = location.userOb?.userDetails?.name{
                    
                    var userName = ""
                    if let firstname = teamMember.first{
                        userName = firstname + " "
                    }
                    
                    if let lastname = teamMember.last{
                        userName = userName + lastname
                    }
                    
                    locations.name = userName
                }
                
                
                if let coordinates = location.userOb?.userStatus?.location?.coordinates{
                    
                    if coordinates.count > 0 {
                        
                        
                        locations.cllocation = CLLocation(latitude: CLLocationDegrees(coordinates[1]), longitude: CLLocationDegrees(coordinates[0]))
                        
                    }
                    
                    
                }
                
                
                myTeamLocations.append(locations)
            }
            
            tableView.reloadData()
            
        }
    
    }
}


extension MyTeamTableView: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "MyTeamLocationDetails") as! MyTeamLocationDetails
        viewController.teamMemberUserId = teamData?[indexPath.item].userId
        viewController.teamMemberUserName = teamData?[indexPath.item].userOb?.userDetails?.name
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
}

extension MyTeamTableView: UITableViewDataSource{
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
        
        if scrollView.contentOffset.y < -5 {
            tableView.isScrollEnabled = false
            delegate?.handleOnSwipe()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTeamTableViewCell", for: indexPath) as! MyLocationTableViewCell
        setTeamDetails(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func setTeamDetails(cell: MyLocationTableViewCell, indexPath: IndexPath){
        
        cell.nameLabel.text = myTeamLocations[indexPath.item].name
        
        if let address = myTeamLocations[indexPath.item].address{
            cell.locationLabel.text = myTeamLocations[indexPath.item].address
        }else{
            LogicHelper.shared.reverseGeoCodeGeoLocations(location: myTeamLocations[indexPath.item].cllocation, index1: indexPath.item, index2: 0) { (address, first, last) in
                self.myTeamLocations[first].address = address
                cell.locationLabel.text = address
                
            }
        }
        
    }
    
    
}
