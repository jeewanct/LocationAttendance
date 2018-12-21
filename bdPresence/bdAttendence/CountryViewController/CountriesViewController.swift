//
//  CountriesViewController.swift
//  bdPresence
//
//  Created by Jeevan Tiwari on 29/10/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import UIKit
import BluedolphinCloudSdk


class CountryListModel: Decodable{
    var name: String?
    var dial_code: String?
    var code: String?
}

class CountriesViewController: UIViewController{
    
    var countryList: [CountryListModel]?{
        didSet{
            countrySearchList = countryList
        }
    }
    var countrySearchList: [CountryListModel]?
    var delegate: ServerResponseDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
        tableView.estimatedRowHeight = UIScreen.main.bounds.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCountryList()
    }
    
    @IBAction func handleClose(_ sender: Any) {
   
        self.dismiss(animated: true, completion: nil)
        
    }
    func getCountryList(){
        if let path = Bundle.main.path(forResource: "CountryList", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                countryList = try JSONDecoder().decode([CountryListModel].self, from: data)
                tableView.reloadData()
            } catch {
                // handle error
            }
        }
    }
    
    
}



extension CountriesViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return countrySearchList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        delegate?.successData(data: countrySearchList?[indexPath.item])
        dismiss(animated: false, completion: nil)
        //handleClose((Any).self)
      
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as! CountryCell
        cell.countryName.text = countrySearchList?[indexPath.item].name
        cell.countryCode.text = countrySearchList?[indexPath.item].code
        return cell
        
    }
    
    
}


extension CountriesViewController: UISearchBarDelegate, UISearchDisplayDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        countrySearchList = searchText.isEmpty ? countryList : countryList?.filter({ (country) -> Bool in
            return country.name?.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        tableView.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
