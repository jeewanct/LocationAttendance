//
//  MyLocationTableView.swift
//  bdPresence
//
//  Created by Raghvendra on 11/07/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import UIKit
import BluedolphinCloudSdk


class MyLocationTableView: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    var places: [RMCPlace]?{
        didSet{
            tableView.reloadData()
        }
    }
    var delegate: HandleUserViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}


extension MyLocationTableView: UITableViewDelegate, UITableViewDataSource{
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
        
        if scrollView.contentOffset.y < -5 {
            tableView.isScrollEnabled = false
            delegate?.handleOnSwipe()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places?.count ?? 0
    
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102.5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyLocationIdentifier", for: indexPath) as! LocationTableViewCell
        cell.addressLabel.text = places?[indexPath.item].placeDetails?.address
        cell.nameLabel.text = places?[indexPath.item].geoTagName
        return cell
    }
}



