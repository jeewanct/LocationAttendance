//
//  UserGeoTagAuthentication.swift
//  bdPresence
//
//  Created by Jeevan Tiwari on 29/08/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import Foundation
import BluedolphinCloudSdk


struct AuthenticationGeoTagModel: Decodable{
    let data: [AuthenticatinGeoTagData]?
}

struct AuthenticatinGeoTagData : Decodable {
    let count : Int?
    let documents : AuthenticatinGeoTagDocuments?
}

struct AuthenticatinGeoTagDocuments : Decodable {
    let organization : AuthenticatinGeoTagOrganization?
}

struct AuthenticatinGeoTagOrganization : Decodable {
    let metaInfo : AuthenticatinGeoTagMetaInfo?
}

struct AuthenticatinGeoTagMetaInfo : Codable {
    let empId : String?
    let status : String?
    let countryCode : String?
    let geotags: Bool?
}


class UserGeoTagAuthentication{
    
    class func getGeoTagAccess(completion:@escaping (Bool) -> Void){
        
        let url = AppConstants.baseUrl + SDKSingleton.sharedInstance.organizationId + AppConstants.GeotTags.geoTagCreationPermission + SDKSingleton.sharedInstance.userId
        
        Networking.fetchGenericData(url, header: url.getHeader(), success: { (authentication: AuthenticationGeoTagModel) in
            
            if let documents = authentication.data{
                
                if documents.count > 0 {
                    
                    if let status = documents[0].documents?.organization?.metaInfo?.geotags{
                        completion(status)
                    }else{
                        completion(false)
                    }
                    
                }
            }
            
        }) { (error) in
            
            print("Error on savign data")
        }
        
    }
    
}

