//
//  UserPlaceModel.swift
//  bdPresence
//
//  Created by Jeevan Tiwari on 31/07/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//


import BluedolphinCloudSdk
import Foundation
import RealmSwift


class GeoTagLocationModel{
    
    var latitude: String?
    var longitude: String?
    var addedOn: Date?
    var updatedOn: Date?
    var placeDetails: GeoTagPlaceDetails?
    var locations: [LocationDataModel]?
}

class GeoTagPlaceDetails{
    
     var placeId: String?
     var editedBy: String?
    var addedBy: String?
    var fenceRadius =  RealmOptional<Int>()
     var placeType: String?
     var address: String?
    
}


class UserPlace{
    
    
    class func getPlacesData(location: LocationDataModel) -> GeoTagLocationModel?{
        
        
        var geoTagLocation: GeoTagLocationModel?
        
        var nearestDistance = -1.0
        let realm = try! Realm()
        
        let places = realm.objects(RMCPlace.self).filter("SELF.placeDetails.placeStatus = %@",true)
        //let places = realm.objects(RMCPlace.self)
        
        
        for place in places{
            
            
            if let firstLat = place.location?.latitude, let firstLong = place.location?.longitude, let fenceRadius = place.placeDetails?.fenceRadius.value {
                
                
                    
                    if  let secondLat = location.latitude, let secondLong = location.longitude{
                        
                       let distance = LogicHelper.shared.distanceBetween(firstLat: firstLat, firstLong: firstLong, secondLat: secondLat, secondLong: secondLong)
                        
                        
                        if distance <= Double(fenceRadius){
                        
                        if nearestDistance == -1.0 {
                            nearestDistance = distance
                            geoTagLocation = setGeoTagData(place: place)
                        }else if nearestDistance > distance{
                            nearestDistance = distance
                            geoTagLocation = setGeoTagData(place: place)
                        }
                    }
                        
                    }
                
                
            }
            
            
            
        }
        print(places)
        
        return geoTagLocation
        
        
    }
    
    
    class  func setGeoTagData(place : RMCPlace) -> GeoTagLocationModel{
        
        let geoTagPlace = GeoTagLocationModel()
        geoTagPlace.addedOn = place.addedOn
        geoTagPlace.updatedOn = place.updatedOn
        geoTagPlace.latitude = place.location?.latitude
        geoTagPlace.longitude = place.location?.longitude
        
        let geoPlaceDetails = GeoTagPlaceDetails()
        geoPlaceDetails.addedBy = place.placeDetails?.addedBy
        geoPlaceDetails.address = place.placeDetails?.address
        geoPlaceDetails.editedBy = place.placeDetails?.editedBy
        
        if let fenceRadius = place.placeDetails?.fenceRadius{
             geoPlaceDetails.fenceRadius = fenceRadius
        }
        
       
        geoPlaceDetails.placeId = place.placeDetails?.placeId
        geoPlaceDetails.placeType = place.placeDetails?.placeType
        
        geoTagPlace.placeDetails = geoPlaceDetails
        
        return geoTagPlace
        
    }
    
}
