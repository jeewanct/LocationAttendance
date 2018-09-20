//
//  ProtocolsForController.swift
//  bdPresence
//
//  Created by Raghvendra on 11/07/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import Foundation
import MapKit


enum ErrorMessages: String{
    case noInternetAvailable = "Internet connection appears to be offline!"
    case noCheckInFound = "No checkin found!"
    
    
}

protocol HandleUserViewDelegate {
    func handleOnSwipe()
}


protocol LocationsFilterDelegate{
    
    func finalLocations(locations: [LocationDataModel])
    func onFailure(type: ErrorMessages)
    
}


protocol PolylineStringDelegate {
    func drawPolyline(coordinates: [CLLocationCoordinate2D])
}


protocol GeoTagLocationDelegate {
    func handleTap(currentIndex: Int)
}
