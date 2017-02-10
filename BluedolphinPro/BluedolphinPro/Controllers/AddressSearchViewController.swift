//
//  AddressSearchViewController.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 03/02/17.
//  Copyright © 2017 raremediacompany. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import CoreLocation



class AddressSearchViewController: UIViewController,UISearchBarDelegate {
    
    var resultsArray = [String]()
   
    
    @IBOutlet weak var mapView: UIView!
   
    @IBOutlet weak var searchBar: UISearchBar!
    var changeAddress: SelectedAddress!
    var searchResultController: SearchResultsController!
    var searchController:UISearchController!

   var selectedLocation = CLLocation()
    
    
    var saveButton :UIBarButtonItem?
    override func viewDidLoad() {
        super.viewDidLoad()
        GMSPlacesClient.provideAPIKey(GOOGLE_MAPS.ApiKey)
        searchBar.delegate = self
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
        
        searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction(_:)))
        saveButton   = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(saveAction(_:)))
        
        
        navigationItem.rightBarButtonItem = nil
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 104/255, green: 168/255, blue: 220/25, alpha: 1)
        
        
        
       
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            googleMapUsage.sharedInstance.globalMapView = GMSMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.mapView.frame.height))
            self.mapView.addSubview(googleMapUsage.sharedInstance.globalMapView)
            //googleMapUsage.sharedInstance.globalMapView.delegate=self
            googleMapUsage.sharedInstance.globalMapView.animate(toZoom: 20)
            googleMapUsage.sharedInstance.globalMapView.clipsToBounds = true
            googleMapUsage.sharedInstance.globalMapView.settings.myLocationButton = true
            
            //self.view.sendSubviewToBack(googleMapUsage.sharedInstance.globalMapView)
        }
    }
    
    func saveAction(_ sender: AnyObject) {
        if CLLocationCoordinate2DIsValid(selectedLocation.coordinate) && !searchBar.text!.isBlank{
            if let delegate = self.changeAddress {
                delegate.showSelectedAddress(searchBar.text!,location: selectedLocation)
            }
            self.view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
            //self.dismissViewControllerAnimated(true, completion: nil)
        }else{
            self.showAlert("Not a valid address")
        }
        
    }
    
     func cancelAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func showAlert(_ message : String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (action) in
            return        }
        alertController.addAction(OkAction)
        self.present(alertController, animated: true) {
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String){
        if !searchText.isBlank{
            placeAutocomplete(text: searchText)
        }
        
        
        
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar == self.searchBar{
            self.present(searchController, animated: true, completion: nil)
        }
        
    }
    
    func placeAutocomplete(text:String) {
//        let filter = GMSAutocompleteFilter()
//        filter.type = .establishment
        let placesClient = GMSPlacesClient()
        placesClient.autocompleteQuery(text, bounds: nil, filter: nil, callback: {(results, error) -> Void in
            if let error = error {
                print("Autocomplete error \(error)")
                return
            }
            if let results = results {
                self.resultsArray.removeAll()
                for result in results {
                    if let result = result as? GMSAutocompletePrediction{
                        self.resultsArray.append(result.attributedFullText.string)
                    }
                }
            }
            
            self.searchResultController.reloadDataWithArray(self.resultsArray)
        })
    }
    
    
    
   
    
    // Do any additional setup after loading the view.
}
extension AddressSearchViewController:LocateOnTheMap {
    
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        
        
        
        DispatchQueue.main.async { () -> Void in
            self.searchBar.text = title
            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker(position: position)
            
            
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 10)
            googleMapUsage.sharedInstance.globalMapView.camera = camera
            
            marker.title = title
            marker.map = googleMapUsage.sharedInstance.globalMapView
            
        }
        
    }
    
    //MARK: -get location from address
    func getLocationFromAddress(_ address:String){
        self.searchBar.text = address
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error)
            }
            if let placemark = placemarks?.first {
                let location:CLLocation = placemark.location!
                
                
                // self.locationTableView.isHidden = true
                self.view.endEditing(true)
                self.updateLocationMarker(location)
            }
        })
    }
    
    
    
    
    func updateLocationMarker(_ location : CLLocation) {
        googleMapUsage.sharedInstance.globalMapView.clear()
        //    locationMarker = GMSMarker()
        
        selectedLocation = location
        let cameraUpdate = GMSCameraUpdate.setTarget(location.coordinate, zoom: Float(18))
        
        navigationItem.rightBarButtonItem = saveButton
        googleMapUsage.sharedInstance.globalMapView.animate(with: cameraUpdate)
        let locationMarker = GMSMarker()
        let markerIcon = UIImage(named: "default_marker")
        locationMarker.icon = markerIcon
        locationMarker.position = location.coordinate
        locationMarker.appearAnimation = kGMSMarkerAnimationPop
        locationMarker.map = googleMapUsage.sharedInstance.globalMapView
        
    }
}




protocol LocateOnTheMap{
     func getLocationFromAddress(_ address:String)
    // func locateWithLongitude(_ lon:Double, andLatitude lat:Double, andTitle title: String)
}

class SearchResultsController: UITableViewController {
    
    var searchResults: [String]!
    var delegate: LocateOnTheMap!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchResults = Array()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.searchResults.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        
        cell.textLabel?.text = self.searchResults[indexPath.row]
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath){
        // 1
        self.dismiss(animated: true, completion: nil)
//        // 2
//        let urlpath = "https://maps.googleapis.com/maps/api/geocode/json?address=\(self.searchResults[indexPath.row])&sensor=false".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//        
//        let url = URL(string: urlpath!)
//        // print(url!)
//        let task = URLSession.shared.dataTask(with: url! as URL) { (data, response, error) -> Void in
//            // 3
//            
//            do {
//                if data != nil{
//                    let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
//                    
//                    let lat =   (((((dic.value(forKey: "results") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "geometry") as! NSDictionary).value(forKey: "location") as! NSDictionary).value(forKey: "lat")) as! Double
//                    
//                    let lon =   (((((dic.value(forKey: "results") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "geometry") as! NSDictionary).value(forKey: "location") as! NSDictionary).value(forKey: "lng")) as! Double
//                    // 4
//                    self.delegate.locateWithLongitude(lon, andLatitude: lat, andTitle: self.searchResults[indexPath.row])
//                }
//                
//            }catch {
//                print("Error")
//            }
//        }
//        // 5
//        task.resume()
        
        self.delegate.getLocationFromAddress(self.searchResults[indexPath.row])
    }
    
    
    func reloadDataWithArray(_ array:[String]){
        self.searchResults = array
        self.tableView.reloadData()
    }
    
}






/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */




