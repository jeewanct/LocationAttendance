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
import PullUpController

class MyTeamDetailsScreen{
    
    var name: String?
    var address: String?
    var cllocation = CLLocation()
}


class MyTeamTableView: PullUpController{
    
    
   
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var secondPreviewHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var secondPreviewHeight: UIView!
   @IBOutlet weak var secondPreviewView: UIView!
    
    @IBOutlet weak var firstPreviewView: UIView!
  
  
    @IBOutlet weak var tableView: UITableView!
    
    var teamData: [MyTeamData]?{
        didSet{
            setData()
           // tableView.reloadData()
        }
    }
    var delegate: HandleUserViewDelegate?
  
    var myTeamLocations = [MyTeamDetailsScreen]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // tableView.attach(to: self)
        //setupDataSource()
        
        secondPreviewHeightAnchor.constant = UIScreen.main.bounds.height - 214
        
        willMoveToStickyPoint = { point in
            if point == UIScreen.main.bounds.height - 64{
          //      self.visualEffectView.isHidden = false
            }else{
            //    self.visualEffectView.isHidden = true
            }
            print("willMoveToStickyPoint \(point)")
        }
        
        didMoveToStickyPoint = { point in
            
            print("didMoveToStickyPoint \(point)")
            
        }
        
        // New change - Sourabh
        onDrag = { point in
            print("onDrag: \(point)")
            if point > 100 {
                self.tableView.isScrollEnabled = true
            } else {
                self.tableView.isScrollEnabled = false
                self.delegate?.handleOnSwipe()
            }
        }
        
        tableView.reloadData()
        
    }
    
    
    
    // MARK: - PullUpController
    
    override var pullUpControllerPreferredSize: CGSize {
         return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64)
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
                
               // Change here coordinate not finding
                
                if let coordinates = location.checkinData?.location?.coordinates {

                    if coordinates.count > 0 {

                        if Int(coordinates[0]) == 0 &&  Int(coordinates[0]) == 0 {

                            locations.address = "No location found"

                        }else{
                            locations.cllocation = CLLocation(latitude: CLLocationDegrees(coordinates[1]), longitude: CLLocationDegrees(coordinates[0]))
                        }

                    }


                }
                
//                if let coordinates = location.userOb?.userStatus?.location?.coordinates{
//
//                    if coordinates.count > 0 {
//
//                        if Int(coordinates[0]) == 0 &&  Int(coordinates[0]) == 0 {
//
//                            locations.address = "No location found"
//
//                        }else{
//                        locations.cllocation = CLLocation(latitude: CLLocationDegrees(coordinates[1]), longitude: CLLocationDegrees(coordinates[0]))
//                        }
//
//                    }
//
//
//                }
                
                myTeamLocations.append(locations)
            }
            
            
            
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

        if let _ = myTeamLocations[indexPath.item].address{
            cell.locationLabel.text = myTeamLocations[indexPath.item].address
        }else{
            LogicHelper.shared.reverseGeoCodeGeoLocations(location: myTeamLocations[indexPath.item].cllocation, index1: indexPath.item, index2: 0) { (address, first, last) in
                self.myTeamLocations[first].address = address
                cell.locationLabel.text = address

            }
        }
        
    }
    
    
}
