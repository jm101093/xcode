//
//  NSDate+Utility.swift
//  danceplus
//
//  Created by Bitcot Inc on 5/3/16.
//  Copyright © 2016 Bitcot Inc. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    func dayOfWeek() -> Int? {
            let cal: Calendar = Calendar.current
            let comp:DateComponents = cal.dateComponents([.weekday], from: self)
            return comp.weekday
        }
    
    func stringToDate() -> Date{
        
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        let date = dateFormatter.date(from: self.toString())
        return date!
    }
    
    func removeSeconds() -> Date{ //
        let calendar = Calendar.current
       // let currentDateComp = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], fromDate: self)
        let currentDateComp = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: self)
        var newDateComponents = DateComponents()
        newDateComponents.day = currentDateComp.day!
        newDateComponents.month = currentDateComp.month!
        newDateComponents.year = currentDateComp.year!
        newDateComponents.hour = currentDateComp.hour!
        newDateComponents.minute = currentDateComp.minute!
        newDateComponents.second = 0
        //let tempDate = calendar.dateFromComponents(newDateComponents)
        let  tempDate = calendar.date(from: newDateComponents)
        return tempDate!
    }
    
    func startDateOfTheDay() -> Date{
        let startOfToday = Calendar.current.startOfDay(for: self)
        return startOfToday
    }
    
    func TZFormat() -> String{
        let timezone = TimeZone(abbreviation: "GMT")
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timezone
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let dateStr = dateFormatter.string(from: self)
        return dateStr
    }
    
    func defaultZoneTZFormat() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let dateStr = dateFormatter.string(from: self)
        return dateStr
    }
    
    func emptyTZFormat() -> Date{
        let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
        let now = Date()
        var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from:now)
        
        components.hour = 0
        components.minute = 0
        components.second = 0
        let date =  gregorian.date(from: components)
        return date!
    }
    
    func TZDate() -> Date{
        let timezone =  TimeZone(abbreviation: "GMT")
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timezone
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return dateFormatter.defaultDate!
    }
    
    func TZFormatForClassCreation() -> String{
        let timezone = TimeZone(abbreviation: "GMT")
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timezone
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:00'Z'"
        let dateStr = dateFormatter.string(from: self)
        return dateStr
    }
    
    func nextClassDateFormat() -> String{ // 29 May, 12:00 AM
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: self)
    }
    func quoteCreatedOn() -> String{ // August 21, 2016.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: self)
    }
    
    func toTime() -> String{ // August 21, 2016.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm aa"
        return dateFormatter.string(from: self)
    }
    
    func toDate() -> String{ // August 21, 2016.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd"
        return dateFormatter.string(from: self)
    }
    
    func toDateDMY() -> String{ // August 21, 2016.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter.string(from: self)
    }
    
    func profileCreatedOn() -> String{ // May 2016
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    func addDays(days:Int) -> Date{
       // let date = self.dateByAddingTimeInterval(Double(days) * 24 * 60.0 * 60.0)
        let date = self.addingTimeInterval(Double(days) * 24 * 60.0 * 60.0)
        return date
    }
    
    func serverKey() -> String{ // 2013-May-29
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MMM-dd"
        return dateFormatter.string(from: self)
    }
    
    func profileDateFormate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: self)
    }
    
    func headerKey() -> String{ // 2013-May-29
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM"
        return dateFormatter.string(from: self)
    }
    
    func serverKey2() -> String{ // 2013-05-29
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    func toString() -> String{ // 2013-05-29
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, YYYY"
        return dateFormatter.string(from: self)
    }
    
    func timeFromDate() -> String{ 
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm aa"
        return dateFormatter.string(from: self)
    }
    
    func fetchMonthAndDate() -> String{ //01/12
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        return dateFormatter.string(from: self)
    }
    
    
    func fetchDay() -> String{ //Mon
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: self)
    }
    
//    func day() -> String{ //Monday
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "EEEE"
//        return dateFormatter.string(from: self)
//    }
    
//    func month() -> String{ //Monday
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMMM"
//        return dateFormatter.string(from: self)
//    }
    
//    func year() -> String{ //Monday
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "YYYY"
//        return dateFormatter.string(from: self)
//    }
    
//    func isToday() -> Bool{
//        let currentDate = Date().serverKey2()
//        let classDate = self.serverKey2()
//        return currentDate == classDate
//    }
    
    func addDaysToRecurringDate(days:NSInteger, recurring:NSInteger) -> [Date]{
        var dates = [Date]()
        let calendar = Calendar.current
        for i in 1...recurring{
           // dates.append(calendar.dateByAddingUnit(.Day, value: days*i, toDate: self, options: [])!)
            dates.append(calendar.date(byAdding: .day, value: days*i, to: self)!)
        }
        return dates
    }
    
    func addTime(date:Date) -> Date{
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute,.second], from: date)
        let currentDateComp = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: self)
        var newDateComponents = DateComponents()
        newDateComponents.day = currentDateComp.day
        newDateComponents.month = currentDateComp.month
        newDateComponents.year = currentDateComp.year
        newDateComponents.hour = comp.hour
        newDateComponents.minute = comp.minute
        newDateComponents.second = 0
        let tempDate = calendar.date(from: newDateComponents)
        //        let calendar = NSCalendar.currentCalendar()
//        let components = NSDateComponents()
//        components.minute = 5
//        components.hour = 0
//        components.second = 0
//        let date = calendar.dateByAddingComponents(comp, toDate: self, options: [])
        return tempDate!
    }
    
    //Previous years.
    func pastYear() -> Date{
        let gregorian: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let currentDate: Date = Date()
        var components: DateComponents = DateComponents()
        components.year =  -150 //Positive for future no.of years.
        //let maxDate: Date = gregorian.dateByAddingComponents(components as DateComponents, toDate: currentDate, options: NSCalendar.Options(rawValue: 0))!
        let maxDate: Date = gregorian.date(byAdding: components, to: currentDate, wrappingComponents: false)!
        return maxDate
    }
    
    func secondsBetween(date:Date) -> Int{
        let timeElapsed = self.timeIntervalSince(date)
        let duration = Int(timeElapsed)
        return duration
    }
    
//    func isGreaterThanDate(dateToCompare: Date) -> Bool {
//        //Declare Variables
//        var isGreater = false
//        
//        //Compare Values
//        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
//            isGreater = true
//        }
//        
//        //Return Result
//        return isGreater
//    }
//    
//    func isLessThanDate(dateToCompare: Date) -> Bool{
//        var isLess = false
//        if self.compare(dateToCompare) == ComparisonResult.orderedAscending{
//            isLess = true
//        }
//        return isLess
//        
//    }
//    
//    func isEqualThanDate(dateToCompare:Date) -> Bool{
//        var isEqual = false
//        
//        if self.compare(dateToCompare) == ComparisonResult.orderedSame{
//            isEqual = true
//        }
//        
//        return isEqual
//    }
  
}
