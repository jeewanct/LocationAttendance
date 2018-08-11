//
//  ProtocolsForController.swift
//  bdPresence
//
//  Created by Raghvendra on 11/07/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import Foundation
import MapKit


protocol HandleUserViewDelegate {
    func handleOnSwipe()
}


protocol LocationsFilterDelegate{
    
    func finalLocations(locations: [LocationDataModel])
    
}


protocol PolylineStringDelegate {
    func drawPolyline(coordinates: [CLLocationCoordinate2D])
}
