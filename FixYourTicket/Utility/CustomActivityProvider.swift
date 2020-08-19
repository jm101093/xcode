//
//  MyStringItemSource.swift
//  stompsessions
//
//  Created by Ashish on 15/02/17.
//  Copyright © 2017 Bitcot Inc. All rights reserved.
//

import Foundation
import UIKit

class CustomActivityProvider:UIActivityItemProvider{
    var facebookMessage : String!
    var twitterMessage : String!
    var emailMessage : String!
    var url:AnyObject!
    
    init(placeholderItem: AnyObject, facebookMessage : String, twitterMessage : String, emailMessage : String, url:AnyObject!) {
        super.init(placeholderItem: placeholderItem)
        self.facebookMessage = facebookMessage
        self.twitterMessage = twitterMessage
        self.emailMessage = emailMessage
        self.url = url
    }
    
    override var item: Any {
        switch (self.activityType!) {
        case UIActivityType.postToFacebook:
            return "\(self.facebookMessage!)\n\(self.url!)"
        case UIActivityType.postToTwitter:
            return "\(self.twitterMessage)\n\(self.url)"
        default:
            return "\(self.emailMessage!)\n\(self.url!)"
        }
    }
    
    override func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivityType?) -> String {
        if activityType == UIActivityType.mail{
            return self.emailMessage
        }else{
            return "Stomp Sessions"
        }
    }
}
