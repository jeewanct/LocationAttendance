//
//  SearchGeoTagLocationController.swift
//  bdPresence
//
//  Created by Jeevan Tiwari on 21/08/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import UIKit
import BluedolphinCloudSdk

class SearchGeoTagLocationController:  UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var myLocationArray: [RMCPlace]?{
        didSet{
            myLocationSearchArray = myLocationArray
        }
    }
    var myLocationSearchArray: [RMCPlace]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeSearchBar()
        tableView.reloadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Search location"
    }
   
    func customizeSearchBar(){
        
        if let txfSearchField = searchBar.value(forKey: "_searchField") as? UITextField {
            txfSearchField.borderStyle = .none
            txfSearchField.backgroundColor = .clear
            txfSearchField.font = UIFont(name: "SourceSansPro-Regular", size: 13)
        }
        
        
    }
    
    
    
}

extension SearchGeoTagLocationController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let geoTagController = storyboard?.instantiateViewController(withIdentifier: "GeoTagController") as! GeoTagController
        // geoTagController.geoTagLocation = cllLocation
        // geoTagController.geoTagAddress = address
        geoTagController.editGeoTagPlace = myLocationSearchArray?[indexPath.item]
        
        navigationController?.pushViewController(geoTagController, animated: true)
    
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myLocationSearchArray?.count ?? 0
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchGeoTagCell", for: indexPath) as! SearchGeoTagCell
        cell.addressLabel.text = myLocationSearchArray?[indexPath.item].placeDetails?.address
        cell.nameLabel.text = myLocationSearchArray?[indexPath.item].geoTagName
        return cell
    }
}


extension SearchGeoTagLocationController: UISearchBarDelegate, UISearchDisplayDelegate{
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        myLocationSearchArray = searchText.isEmpty ? myLocationArray : myLocationArray?.filter({ (hotel) -> Bool in
            
            return hotel.geoTagName?.range(of: searchText, options: .caseInsensitive) != nil
            
        })
        
        tableView.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    
    
}
