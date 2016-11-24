//
//  NotificationClass.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 17/11/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation

class AppNotify {
    private static var notificationCenter: NotificationCenter {
        return NotificationCenter.default
    }
    
    /// Post the specified notification with the given object
    static func postNotification(_ name: String, object: AnyObject? = nil) {
        notificationCenter.post(name: NSNotification.Name(rawValue: name), object: object)
    }
    
    /// Post the specified NSNotification with the given object
    static func postNotification(_ name: NSNotification.Name, object: AnyObject? = nil) {
        notificationCenter.post(name: name, object: object)
    }
    
    /// Observe the notification with the specified name
    static func observeNotification(_ observer: AnyObject, selector: Selector, name: String, object: AnyObject? = nil) {
        notificationCenter.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: name), object: object)
    }
    
    /// Observe the NSNotification with the specified name
    static func observeNotification(_ observer: AnyObject, selector: Selector, name: NSNotification.Name, object: AnyObject? = nil) {
        notificationCenter.addObserver(observer, selector: selector, name: name, object: object)
    }
    
    /// Remove the object from the observers
    static func removeObserver(_ object: AnyObject) {
        notificationCenter.removeObserver(object)
    }
}
