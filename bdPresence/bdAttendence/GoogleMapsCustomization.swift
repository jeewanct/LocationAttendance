//
//  GoogleMapsCustomization.swift
//  bdPresence
//
//  Created by Raghvendra on 10/07/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import UIKit
import GoogleMaps

extension GMSMapView{
    
    func changeStyle(){
        do{
            guard let stylePath = Bundle.main.url(forResource: "CustomMap", withExtension: "json") else { return }
            mapStyle = try GMSMapStyle(contentsOfFileURL: stylePath)
            
        }catch let styleLoadError{
            print(styleLoadError.localizedDescription)
        }
    }
}
