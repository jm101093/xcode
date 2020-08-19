//
//  Ticket.swift
//  FixYourTicket
//
//  Created by Santosh on 14/08/18.
//  Copyright © 2018 Bitcot. All rights reserved.
//

import UIKit
import ObjectMapper

class Ticket: NSObject, Mappable {
    
    var address: String!
    var isUpdated: Bool! = false
    var toHighLight: String!
    var createdAt: Date!
    var citationNumber: String!
    var confirmation_image: URL!
    var confirmation_image2: URL!
    var citationDueDate: Date!
    var dob: String!
    var email: String!
    var incident: String!
    var keydocimage: URL!
    var licenseimage: URL!
    var logged_in_id: Int!
    var phone: Int!
    var isPreSchool: Bool!
    var status: String!
    var status_desc: String!
    var ticket_id: Int!
    var ticketNumber: String!
    var user_tickets: URL!
    
    var licenseTicketImage: UIImage!
    var userTicketImage: UIImage!
    var keydocTicketImage: UIImage!
    
    var didSelecteAtleastOneTicketImage: Bool {
        get {
            return userTicketImage != nil || keydocTicketImage != nil
        }
    }
    
    
    convenience override init() {
        self.init(response: nil)
    }
    
    init(response:[AnyObject]?){
        
    }

    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        address <- map["address1"]
        if let boolString = map["badge_count"].currentValue as? String {
            isUpdated = boolString.toBool()
        }
        if let dateString = map["citation_due_date"].currentValue as? String {
            citationDueDate = convertStringToDate(date: dateString)
        }
        citationNumber <- map["citation_number"]
        confirmation_image <- (map["confirmation_image"], URLTransform())
        confirmation_image2 <- (map["confirmation_image2"], URLTransform())
        if let unixTime = map["created_datetime"].currentValue as? String {
            let dateInTime = Double(unixTime)
            createdAt = Date(timeIntervalSince1970: TimeInterval(dateInTime!))
        }
        dob <- map["dob"]
        email <- map["email"]
        incident <- map["incident"]
        keydocimage <- (map["keydocimage"], URLTransform())
        licenseimage <- (map["licenseimage"], URLTransform())
        logged_in_id <- (map["logged_in_id"])
        phone <- map["pno"]
        if (map["pre_school"].currentValue! as! String) == "1"{
            isPreSchool = true
        }else{
            isPreSchool = false
        }
        status <- map["status"]
        status_desc <- map["status_desc"]
        ticket_id <- map["ticket_id"]
        ticketNumber <- map["ticket_number"]
        user_tickets <- (map["user_tickets"], URLTransform())
    }

}
