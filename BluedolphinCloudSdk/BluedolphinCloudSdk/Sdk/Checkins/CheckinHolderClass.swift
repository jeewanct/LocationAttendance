//
//  CheckinHolderClass.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 16/11/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation

 class CheckinHolder:NSObject{
     var latitude:String?
     var longitude:String?
     var accuracy:String?
     var altitude:String?
     var organizationId:String?
     var checkinId:String?
     var time:String?
     var checkinCategory:String?
     var checkinType:String?
     var checkinDetails:[String:AnyObject]?
     var imageUrl:String?
     var assignmentId:String?
     var imageName:String?
     var relativeUrl:String?
     var jobNumber:String?
     var beaconProximities:Array<Any>?
    
}
