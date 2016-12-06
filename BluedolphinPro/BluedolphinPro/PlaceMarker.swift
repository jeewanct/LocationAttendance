//
//  PlaceMarker.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 06/12/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class PlaceMarker: GMSMarker {
    
    let markerIcon = UIImage(named: "default_marker")
    init(coordinate: CLLocationCoordinate2D) {
        
        super.init()
        position = coordinate
        icon =  self.markerIcon
        groundAnchor = CGPoint(x: 0.5, y: 1)
        appearAnimation = kGMSMarkerAnimationPop
        
    }
}

