//
//  CheckinHolderClass.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 16/11/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation

open class CheckinHolder:NSObject{
    public var latitude:String?
    public var longitude:String?
    public var accuracy:String?
    public var altitude:String?
    public var organizationId:String?
    public var checkinId:String?
    public var time:String?
    public var checkinCategory:String?
    public var checkinType:String?
    public var checkinDetails:[String:AnyObject]?
    public var imageUrl:String?
    public var assignmentId:String?
    public var imageName:String?
    public var relativeUrl:String?
    public var jobNumber:String?
    public var beaconProximities:Array<Any>?
    
}
