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
    var fenceRadius:  Float?
    var placeType: String?
    var address: String?
    
}


class UserPlace{
    
    
    class func getPlacesData(location: LocationDataModel, rmcPlaces: [RMCPlace]) -> GeoTagLocationModel?{
        
        
        var geoTagLocation: GeoTagLocationModel?
        
        var nearestDistance = -1.0
      
        
       
        //let places = realm.objects(RMCPlace.self)
        
        
        for place in rmcPlaces{
            
            
            if let firstLat = place.location?.latitude, let firstLong = place.location?.longitude, let fenceRadius = place.placeDetails?.fenceRadius{
                
                
                    
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
      //  print(places)
        
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
    
    
    
    class func getGeoTagData(location: [LocationDataModel]? ) -> [[LocationDataModel]]{
        
        
        var geoTaggedLocations = [LocationDataModel]()
        
        let realm = try! Realm()
        let rmcPlaces  = realm.objects(RMCPlace.self).filter("SELF.placeDetails.placeStatus = %@",true)
        
        var allGeoTagLocations = [RMCPlace]()
        
        
        for place in rmcPlaces{
            
            allGeoTagLocations.append(place)
        }
        
        
        
        if let locationData = location{
            
            for locationIndex in 0..<locationData.count{
                if let geoTagged = UserPlace.getPlacesData(location: locationData[locationIndex], rmcPlaces: allGeoTagLocations){
                    locationData[locationIndex].geoTaggedLocations = geoTagged
                    geoTaggedLocations.append(locationData[locationIndex])
                }else{
                    geoTaggedLocations.append(locationData[locationIndex])
                }
                
            }
            
            
            
        }
        
        
        
        return locationAccordingToGeoTag(locations: geoTaggedLocations)
        
        
        
        
    }
    
    class func locationAccordingToGeoTag(locations: [LocationDataModel]) -> [[LocationDataModel]]{
        
        
        var clusteringData = [[LocationDataModel]]()
        var tempData = [LocationDataModel]()
        var lastGeoTagId = "temp"
        
        for location in locations{
            
            if let geoTagId = location.geoTaggedLocations?.placeDetails?.placeId{
                
                if geoTagId == lastGeoTagId{
                    tempData.append(location)
                }else{
                    lastGeoTagId = geoTagId
                    if tempData.count == 0{
                        tempData.append(location)
                    }else{
                        let locationData = tempData
                        clusteringData.append(locationData)
                        tempData.removeAll()
                    }
                    
                }
                
            }else{
                lastGeoTagId = "temp"
                clusteringData.append([location])
            }
            
            
            
        }
        
        if tempData.count != 0 {
            clusteringData.append(tempData)
        }
        
        print("The location is ", clusteringData)
        
        return clusteringData
        
    }
    
    
    
    
    
    //    func locationAccordingToGeoTag(locations: [LocationDataModel]){
    //
    //
    //        var geoTaggedLocations = [GeoTagLocationModel]()
    //        var ordinaryLocations  = [LocationDataModel]()
    //
    //        for index in 0..<locations.count {
    //
    //            var geolocations = [LocationDataModel]()
    //
    //            for index1 in index + 1..<locations.count{
    //
    //
    //                if locations[index1].isRepeated == false || locations[index1].isRepeated == nil{
    //
    //                if locations[index].geoTaggedLocations?.placeDetails?.placeId == locations[index1].geoTaggedLocations?.placeDetails?.placeId{
    //
    //                    geolocations.append(locations[index])
    //                    locations[index1].isRepeated = true
    //                    if index != 0 {
    //                      geolocations[index].isRepeated = true
    //                    }
    //                   // geolocations[index].isRepeated = true
    //
    //
    //                }else{
    //                    if geolocations[index].isRepeated != true{
    //                        geolocations[index].isRepeated = false
    //                    }
    //
    //
    //                    }
    //
    //                }
    //
    //            }
    //
    //            if geolocations.count == 0 && locations[index].isRepeated == false{
    //                ordinaryLocations.append(locations[index])
    //
    //            }else{
    //
    //                if locations[index].isRepeated == false || locations[index].isRepeated == nil {
    //
    //                    if let geoTaggedLocation = setClusterTaggedLocation(currentGeoLocation: locations[index], location: geolocations){
    //                        geoTaggedLocations.append(geoTaggedLocation)
    //
    //
    //                    }
    //                }
    //
    //
    //                //geoTaggedLocations.append(setClusterTaggedLocation(currentGeoLocation: locations[index], location: geolocations))
    //
    //            }
    //
    //
    //
    //        }
    //
    //        print("Jeevan the geoTagged Dta", dump(geoTaggedLocations))
    //        print("Jeevan the location Dta", dump(ordinaryLocations))
    //
    //        plotMarkersInMap(geoTaggedLocation: geoTaggedLocations, ordinarylocations: ordinaryLocations)
    //
    //
    //    }
    
    func setClusterTaggedLocation(currentGeoLocation: LocationDataModel,location: [LocationDataModel]) -> GeoTagLocationModel?{
        
        
        
        if let taggedLocation = currentGeoLocation.geoTaggedLocations{
            var geoTaggedModel = GeoTagLocationModel()
            geoTaggedModel = taggedLocation
            geoTaggedModel.locations = location
            
            return geoTaggedModel
            
        }
        
        
        return nil
        
        
    }
    
    
    
    
}
