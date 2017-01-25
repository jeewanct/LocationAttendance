//
//  ProjectSingelton.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 24/01/17.
//  Copyright © 2017 raremediacompany. All rights reserved.
//

import Foundation
class Singleton {
    
    static let sharedInstance: Singleton = Singleton()
    var startToDate:String?
    var startFromDate:String?
    var endToDate:String?
    var endFromDate:String?
    var assignedByValue:String?
    var sortBy:String?
}
