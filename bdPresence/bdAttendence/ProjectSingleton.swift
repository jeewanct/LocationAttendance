//
//  ProjectSingleton.swift
//  bdAttendence
//
//  Created by Raghvendra on 29/05/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import Foundation

 class ProjectSingleton {
    
    public static let sharedInstance: ProjectSingleton = ProjectSingleton()
    var internetAvailable = true
    var bluetoothAvaliable = true
    var locationAvailable = true
}
