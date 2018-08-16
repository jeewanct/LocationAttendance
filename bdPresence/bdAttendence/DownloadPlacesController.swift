//
//  DownloadPlacesController.swift
//  bdPresence
//
//  Created by Jeevan Tiwari on 14/08/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import UIKit
import BluedolphinCloudSdk




class DownloadPlaceController: UIViewController{
    
    let activityIndicator = ActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        NotificationCenter.default.addObserver(self, selector: #selector(DownloadPlaceController.goToHome), name: NSNotification.Name(rawValue: LocalNotifcation.RMCPlacesFetched.rawValue), object: nil)
       
        view.showActivityIndicator(activityIndicator: activityIndicator)
         RMCPlacesManager.getPlaces()
        
        
    }
    func goToHome(){
        view.removeActivityIndicator(activityIndicator: activityIndicator)
        let destVC = self.storyboard?.instantiateViewController(withIdentifier: "Main") as! UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = destVC
        
    }
    

    
    
}
