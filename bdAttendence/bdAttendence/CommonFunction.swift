//
//  CommonFunction.swift
//  bdAttendence
//
//  Created by Raghvendra on 18/04/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import Foundation

func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
    }
}
func isShiftStart(time:String)->Bool{
    
    return false
    
}
func isShiftEnd(time:String)->Bool{
    return false
    
}
