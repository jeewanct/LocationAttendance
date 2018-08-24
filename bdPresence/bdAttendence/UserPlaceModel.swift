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
    var locationName: String?
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
        geoTagPlace.locationName = place.placeAddress
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
        
        let clusterGeoTagLocatins = locationAccordingToGeoTag(locations: geoTaggedLocations)
    
        return clusterNonGeoLocations(locations: clusterGeoTagLocatins)
    
        
    }
    
    class func locationAccordingToGeoTag(locations: [LocationDataModel]) -> [[LocationDataModel]]{
        
        
        var clusteringData = [[LocationDataModel]]()
        var tempData = [LocationDataModel]()
        var lastGeoTagId = "temp"
        
        for location in locations{
            
            if let geoTagId = location.geoTaggedLocations?.placeDetails?.placeId{
                
                if geoTagId == lastGeoTagId{
                    
                    
                    // Changes here for breaks
                    
                    if let lastLocation = tempData.last{
                        
                        if let firstlastSeen = lastLocation.lastSeen, let secondLastSeen = location.lastSeen{
                            
                            let firstTime = LogicHelper.shared.getTime(date: firstlastSeen)
                            let secondTime = LogicHelper.shared.getTime(date: secondLastSeen)
                            
                            if abs(firstTime - secondTime) >= 1800{
                                let locationData = tempData
                                clusteringData.append(locationData)
                                tempData.removeAll()
                            }else{
                                 tempData.append(location)
                            }
                            
                        }
                        
                        
                    }else{
                       tempData.append(location)
                    }
                    
                    // Changes here
                    
                   
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
                
                if tempData.count > 0 {
                    clusteringData.append(tempData)
                    tempData.removeAll()
                }
                
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
    
    
    class func clusterNonGeoLocations(locations: [[LocationDataModel]]) -> [[LocationDataModel]]{
        
    
        var finalLocations = [[LocationDataModel]]()
      
        var firstLocation = LocationDataModel()
        
        var tempLocations = [LocationDataModel]()
        
        for index in locations{
            
            if let firstLoc = index.first{
                
                if let _ = firstLoc.geoTaggedLocations{
                    
                    if tempLocations.count > 0 {
                        finalLocations.append(tempLocations)
                        tempLocations.removeAll()
                        firstLocation = LocationDataModel()
                    }
                    finalLocations.append(index)
                }else{
                    
                    if let _ = firstLocation.lastSeen{
                       
                       let distance = LogicHelper.shared.distanceBetween(firstLat: firstLocation.latitude, firstLong: firstLocation.longitude, secondLat: firstLoc.latitude, secondLong: firstLoc.longitude)
                        
                        if distance <= 100 {
                            
                            tempLocations.append(firstLoc)
                        }else{
                            
                            //tempLocations.append(firstLocation)
                            
                            firstLocation = firstLoc
                            
                            finalLocations.append(tempLocations)
                            
                            tempLocations.removeAll()
                            tempLocations.append(firstLocation)
                            
                            
                           // firstLocation =  LocationDataModel()
                            
                        }
                        
                        
                    }else{
                            firstLocation = firstLoc
                            tempLocations.append(firstLocation)
                    }
                    
                }
                
            }
       
        
        }
        
        if tempLocations.count > 0 {
            finalLocations.append(tempLocations)
        }
        
        return finalLocations
        
        
    }
    
    
   

    
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
