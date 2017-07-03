//
//  Extensions.swift
//  bdAttendence
//
//  Created by Raghvendra on 19/04/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import Foundation
import UIKit

func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    Swift.print(items[0], separator:separator, terminator: terminator)
}
extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}


public extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    public class func once(token: String, block:(Void)->Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}

enum NotificationType:String{
    case NewAssignment = "New-Assignment"
    case Welcome = "Welcome-Message"
    case UpdatedAssignment = "Updated-Assignment"
    case FirstCheckin
    case NoCheckin

}

enum LocalNotifcation:String{
    case Profile = "MyProfile"
    case Assignment = "MyAssignments"
    case VirtualBeacon = "VirtualBeacon"
    case Pushreceived = "Pushreceived"
    case NewAssignment = "NewAssignment"
    case Draft = "Draft"
    case BaseAnalytics
    case Attendance
    case Background
    case TimeUpdate
    case LocationUpdate
    case FirstBeaconCheckin
    case Dashboard
}
enum ErrorMessage:String{
    case UserNotFound = "User not found with that phone number in system,Please contact your administrator"
    case InternalServer = "We are facing some internal issue please try again after sometime"
    case NotValidData = "Input you send is not valid"
    case emailError = "Please enter the valid email"
    case FECodeError = "Please enter the mobile number"
    case NetError = "Could not connect to internet please try again."
    case InvalidFECode = "Please enter valid mobile  number"
    case InvalidOtp = "Please enter valid otpcode"
}
enum NotificationMessage:String{
    case AttendanceMarked  = "We've marked you present for today. Have a wonderful day!"
}

extension String {
    var toProper:String {
        if self.characters.count == 0 {
            return self
        }
        return String(self[self.startIndex]).capitalized + String(self.characters.dropFirst())
    }
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.characters.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.characters.index(startIndex, offsetBy: r.upperBound - r.lowerBound)
            
            return self[startIndex..<endIndex]
        }
    }
    
    //To check text field or String is blank or not
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    //Validate Email
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    //validate PhoneNumber
    var isPhoneNumber: Bool {
        
        let charcter  = CharacterSet(charactersIn: "+0123456789").inverted
        var filtered:String!
        
        let inputString:[String] = self.components(separatedBy: charcter)
        
        
        filtered = inputString.joined(separator: "") as String!
        return  self == filtered
        
    }
    var isMobile:Bool{
        let phoneRegExp = "[0123456789][0-9]{9}"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegExp)
        if phoneTest.evaluate(with: self) {
            
            if (self as NSString).hasPrefix("0") {
                
                return false
            }
            
            return true
        }
        return false
    }
    
    var parseJSONString: AnyObject?
    {
        
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if let jsonData = data
        {
            // Will return an object or nil if JSON decoding fails
            do
            {
                let message = try JSONSerialization.jsonObject(with: jsonData, options:[])
                if let jsonResult = message as? AnyObject
                {
                    //print(jsonResult)
                    
                    return jsonResult //Will return the json array output
                }
                else
                {
                    return nil
                }
            }
            catch let error as NSError
            {
                print("An error occurred: \(error)")
                return nil
            }
        }
        else
        {
            // Lossless conversion of the string was not possible
            return nil
        }
    }
    
    
    func stringByAddingPercentEncodingForRFC3986() -> String? {
        //        let unreserved = "-._~/?"
        //        let allowed = NSMutableCharacterSet.alphanumericCharacterSet()
        //        allowed.addCharactersInString(unreserved)
        //        urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        return addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    }
}
