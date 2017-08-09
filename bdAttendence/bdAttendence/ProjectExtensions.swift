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
    //Swift.print(items[0], separator:separator, terminator: terminator)
}


extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
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


extension Date{
    
    func startOfWeek() -> Foundation.Date? {
        let comp :DateComponents = Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        
        return Calendar.current.date(from: comp)!
    }
    func dayOfWeekFull() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or capitalized(with: locale)
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
