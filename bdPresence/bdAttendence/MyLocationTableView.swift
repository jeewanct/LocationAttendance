//
//  MyLocationTableView.swift
//  bdPresence
//
//  Created by Raghvendra on 11/07/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import UIKit
import BluedolphinCloudSdk
import PullUpController

class MyLocationTableView: PullUpController{

    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var secondPreviewHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var secondPreviewHeight: UIView!
    @IBOutlet weak var secondPreviewView: UIView!
    
    @IBOutlet weak var firstPreviewView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: UIButton!
    
    var places: [RMCPlace]?{
        didSet{
            myLocationSearchArray = places
        }
    }
    
    var myLocationSearchArray: [RMCPlace]?
    
    
    var delegate: HandleUserViewDelegate?
  
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
         secondPreviewHeightAnchor.constant = UIScreen.main.bounds.height - 214
       //  tableView.reloadData()
        visualEffectView.effect = nil
        
        navigationController?.removeTransparency()
        setupController()
        self.tableView.isScrollEnabled = false
        willMoveToStickyPoint = { point in
            
            print("willMoveToStickyPoint \(point)")
            
            if point > UIScreen.main.bounds.height / 2{
                self.addBlurEffect()
                self.tableView.isScrollEnabled = true
               //  self.setupConstraint()
            }else{
                self.visualEffectView.effect = nil
                
                if let getPlaces = self.myLocationSearchArray?.count{
                    if getPlaces > 0{
                        let indexPath = IndexPath(item: 0, section: 0)
                        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    }
                }
                
                self.tableView.isScrollEnabled = false
                // self.setupConstraint()
            }
            
        }
        
        didMoveToStickyPoint = { point in
            
            print("didMoveToStickyPoint \(point)")
        }
        
        onDrag = { point in
            
            
            
            
            print("onDrag: \(point)")
        }
        
      
        
        
    }
    
    @IBAction func handleAdd(_ sender: Any) {
        let geoTagController = storyboard?.instantiateViewController(withIdentifier: "GeoTagController") as! GeoTagController
        navigationController?.pushViewController(geoTagController, animated: true)
    }
    
    
    func addBlurEffect(){
        
        let blurEffect = UIBlurEffect(style: .regular)
        visualEffectView.effect = blurEffect
    }
    
//    func setupConstraint(){
//        if locationTopAnchor.constant == 24.5{
//                locationTopAnchor.constant = 24.5 + 49 + 8
//            searchBar.isHidden = false
//            self.addButton.isHidden = false
//
//        }else{
//            locationTopAnchor.constant = 24.5
//            self.addButton.isHidden = false
//            searchBar.isHidden = true
//
//        }
//
//    }
    
    // MARK: - PullUpController
    
    override var pullUpControllerPreferredSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64)
    }
    
    override var pullUpControllerPreviewOffset: CGFloat {
        print(UIScreen.main.bounds.height * 0.2)
        return UIScreen.main.bounds.height * 0.2 + 64
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




extension MyLocationTableView: UITableViewDelegate, UITableViewDataSource{
    
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset)
//
//        if scrollView.contentOffset.y < -5 {
//            tableView.isScrollEnabled = false
//            delegate?.handleOnSwipe()
//        }
//
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        if let canGeoTag = UserDefaults.standard.value(forKey: "canGeoTag") as? Bool{
            if canGeoTag == true{
                let geoTagController = storyboard?.instantiateViewController(withIdentifier: "GeoTagController") as! GeoTagController
                geoTagController.editGeoTagPlace = myLocationSearchArray?[indexPath.item]
                navigationController?.pushViewController(geoTagController, animated: true)
            }else{
                
            }
        }
          
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myLocationSearchArray?.count ?? 0
    
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102.5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyLocationIdentifier", for: indexPath) as! LocationTableViewCell
        cell.addressLabel.text = myLocationSearchArray?[indexPath.item].placeDetails?.address
        cell.nameLabel.text = myLocationSearchArray?[indexPath.item].geoTagName
        return cell
    }
}


extension MyLocationTableView{
    
    func setupController(){
        if let canGeoTag = UserDefaults.standard.value(forKey: "canGeoTag") as? Bool{
           
            if canGeoTag == true{
                addButton.isHidden = false
            }else{
                addButton.isHidden = true
            }
            
        }else{
            addButton.isHidden = true
        }
        
    }
}



