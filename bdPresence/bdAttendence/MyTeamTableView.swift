//
//  MyTeamTableView.swift
//  bdPresence
//
//  Created by Raghvendra on 12/07/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import UIKit
import BluedolphinCloudSdk
class MyTeamTableView: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    var teamData: [MyTeamDocument]?{
        didSet{
            tableView.reloadData()
        }
    }
    var delegate: HandleUserViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}


extension MyTeamTableView: UITableViewDelegate, UITableViewDataSource{
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
        
        if scrollView.contentOffset.y < -50 {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "MyTeamLocationDetails") as! MyTeamLocationDetails
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTeamTableViewCell", for: indexPath) as! MyLocationTableViewCell
        setTeamDetails(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func setTeamDetails(cell: MyLocationTableViewCell, indexPath: IndexPath){
        
        if let teamMember = teamData?[indexPath.item].userDetails?.name{
            
            var userName = ""
            if let firstname = teamMember["first"]{
                userName = firstname + " "
            }
            
            if let lastname = teamMember["last"]{
                userName = userName + lastname
            }
            
            cell.nameLabel.text = userName
        }
        
    }
    
    
}
