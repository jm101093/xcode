//
//  AppData.swift
//  aboutairportparking
//
//  Created by Bitcot Inc on 6/7/16.
//  Copyright © 2016 Bitcot Inc. All rights reserved.
//

import UIKit

class AppData: NSObject {
    
    //static let sharedInstance = AppData()
    
    private static var privateShared : AppData?
    static var sharedInstance: AppData {
        if privateShared == nil { privateShared = AppData() }
        return privateShared!
    }
    
    var createTicket: Ticket = Ticket()
    
    var ticketTrackCounter = 0
    var createTicketFlow: CreateTicketFlow {
        get {
            return CreateTicketFlow(rawValue: ticketTrackCounter)!
        }
    }
    
    func resetTicket(){
        createTicket = Ticket()
        ticketTrackCounter = 0
    }
    
    func logout(){
//        AppData.privateShared = nil
    }
    
    
    
}
