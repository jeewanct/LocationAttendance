//
//  AddressSearchViewController.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 03/02/17.
//  Copyright © 2017 raremediacompany. All rights reserved.
//

import UIKit

class AddressSearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let controller = GooglePlacesSearchController(
            apiKey: GOOGLE_MAPS.ApiKey,
            placeType: PlaceType.address
        )
        
        //        Or if you want to use autocompletion for specific coordinate and radius (in meters)
        //        let coord = CLLocationCoordinate2D(latitude: 55.751244, longitude: 37.618423)
        //        let controller = GooglePlacesSearchController(
        //            apiKey: GoogleMapsAPIServerKey,
        //            placeType: PlaceType.Address,
        //            coordinate: coord,
        //            radius: 10
        //        )
        
        controller.didSelectGooglePlace { (place) -> Void in
            print(place.description)
            
            //Dismiss Search
            controller.isActive = false
        }
        
        present(controller, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        // Do any additional setup after loading the view.
    }


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


