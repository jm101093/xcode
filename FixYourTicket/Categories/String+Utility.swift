//
//  String+Utility.swift
//  golog
//
//  Created by Bitcot Inc on 3/23/16.
//  Copyright © 2016 Sahil. All rights reserved.
//

import Foundation
extension String{
    
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
     subscript (i: Int) -> String {
       return String(self[i] as Character)
    }
    
//     subscript (r: Range<Int>) -> String {
//        let substring = self[self.startIndex..<self.index(self.startIndex, offsetBy: 3)] // prints: ful
//        
//        // Convert the result to a String for long-term storage.
//        let newString = String(substring)
//        return newString
//        
//    }
    
    func stringToDate() -> NSDate{
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        let date = dateFormatter.date(from: self)
        return date! as NSDate
    }
    
    func stringToTZ() -> NSDate{
        let dateFormatter =  DateFormatter()
        dateFormatter.timeZone =  NSTimeZone(abbreviation: "GMT") as TimeZone!
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let date = dateFormatter.date(from: self)
        return date! as NSDate
    }
 
    func isValidEmail() -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isValidPhoneNumber() -> Bool {
        let charcter  = NSCharacterSet(charactersIn: "+0123456789").inverted
        var filtered:NSString!
        let inputString:NSArray = self.components(separatedBy: charcter) as NSArray
        filtered = inputString.componentsJoined(by: "") as NSString!
        return  (self == filtered as String && self.characters.count >= 10)
    }
    
    func isValidPincode() -> Bool {
        if self.characters.count <= 4{
            return true
        }
        else{
            return false
        }
    }
    
    func validateLength() -> Bool{
        if self.characters.count > 0{
            return true
        }
        return false
    }
    
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}
