//
//  Constants.swift
// 
//
//  Created by Bitcot Inc on 13/01/16.
//  Copyright © 2016 bitcot. All rights reserved.
//

import Foundation
import UIKit

typealias CompletionBlock = (AlamofireAPIResponse) -> Void
typealias JSON = AnyObject
typealias JSONDictionary = Dictionary<String, JSON>
typealias JSONArray = Array<JSON>

//MARK:SegueIdentifier
struct SegueIdentifier {
    static let LoginViewController = "LoginViewController"
    static let SignUpViewController = "SignUpViewController"
    static let ForgotViewController = "ForgotViewController"
    static let HomeViewController = "HomeViewController"
    static let MenuViewController = "MenuViewController"
    static let TicketHistoryViewController = "TicketHistoryViewController"
    static let HowToCaptureTicketViewController = "HowToCaptureTicketViewController"
    static let CreateNewTicketViewController = "CreateNewTicketViewController"
    static let CaptureMediaViewController = "CaptureMediaViewController"
    static let PreviewImageViewController = "PreviewImageViewController"
    static let OurApologyViewController = "OurApologyViewController"
    static let EnterCitationViewController = "EnterCitationViewController"
    static let ThankYouViewController = "ThankYouViewController"
    static let ServicesViewController = "ServicesViewController"
    static let TicketLocationViewController = "TicketLocationViewController"
    static let TicketHistoryDetailsViewController = "TicketHistoryDetailsViewController"
    static let SingleImageViewController = "SingleImageViewController"
}

//MARK:NotificationName
extension Notification.Name {
    static let kExampleNotification = Notification.Name("ExampleNotification")
    static let kButtonHighlationNotification = Notification.Name("ButtonHighlationNotification")
}

//MARK:APIKeys
struct Keys{
   
}

struct UserDefaultKeys{
    static let kLaunchedFirstTime = "kLaunchedFirstTime"
}


//MARK:days


//MARK:SettingsOptions
enum SettingsType:String{
    case option1
}


//MARK:Remote Notifications

enum NotificationOption:String{
    case sample_notification = "s:rq"
    
}


// MARK :General Constants
struct Constants {
    
    static let AppTitleName = "FIX YOUR TICKET"
    struct PlaceHolderImage {
        
    }
    
    struct Error {
        static let networkMsg = "Please check your internet connection and try again!"
        static let generalMsg = "Error while processing your request, Please try again later"
        static let loginMsg = "Error While Logging in, Please try again"
        static let enterFirstNameErrorMsg = "Please enter first name"
        static let enterValidEmailErrorMsg = "Please enter valid email"
        static let enterPasswordErrorMsg = "Please enter your password"
        static let enterConfirmPasswordErrorMsg = "Please confirm your passsword"
        static let confirmPasswordMatchErrorMsg = "Confirm pasword do not match"
        static let enterLastNameErrorMsg = "Please enter your last name"
        static let enterDOBErrorMsg = "Please enter date of birth"
        static let cameraPermissionMsg = "Please enable camera permission from settings and try again"
        static let enterMobileNumberMsg = "mobile number is a must"
        static let enterValidPhoneErrorMsg = "enter a valid mobile number"
        static let enterValidPhoneErrorMsgInEditMode = "Mobile number please"
        static let enterValidCityOrZipCodeMsg = "City or zip"
        static let photoLibraryPermissionMsg = "Please enable access to Photos from settings and try again"
        static let selectGenderErrorMsg = "Please select your gender"
        static let talentMediaLimitMsg = "Upload limit, choose only 5 media items to upload"
        static let businessnamepleaseMsg = "Business name please"
        static let taxIDpleaseMsg = "Tax ID please"
        static let venmoUsernamePleaseMsg = "Venmo username please"
        static let userNameTooShortMessage = "Username must be at least 5 char"
        static let userNameTooLongMessage = "User name is too long, max should be 20 characters"
        static let passWordErrorMessageForSignUp = "Password must be at least 8 char"
        static let passwordErrorMessageForChangePassword = "Password is a must"
        static let serverErrorMsg = "We are notified and working on it, we will be back soon!"
        static let noMsgs = "No Messages to show!"
        static let noPhotosMsgs = "Add photos from your gallery!"
    }
}

enum MenuOption: String {
    case home,
    location,
    share,
    services
    
    var title: String {
        get {
            switch self {
            case .home:
                return "Home"
            case .location:
                return "Location"
            case .share:
                return "Share"
            case .services:
                return "Services"
            }
        }
    }
}

enum TicketStatus: String {
    case Open, Closed
}

enum CreateTicketFlow: Int {
    case driverLicence,
    originalCitation,
    courtNotice
    
    var title: String {
        get {
            switch self {
            case .driverLicence:
                return "DO YOU HAVE YOUR DRIVER LICENCE OR ID IN YOUR POSSESSION ?"
            case .originalCitation:
                return "DO YOU HAVE YOUR ORIGINAL CITATION?"
            case .courtNotice:
                return "DO YOU HAVE YOUR COURT NOTICE OR ANY DOCUMENT THAT SHOWS THE CITATION OR CASE NUMBER ?"
            }
        }
    }
    
    var subTitle: String {
        get {
            switch self {
            case .originalCitation:
                return "(THE TICKET OFFICER GAVE YOU WHEN YOU GOT PULLED OVER)"
            default:
                return ""
            }
        }
    }
    
    var titleFont: UIFont {
        get {
            switch self {
            case .driverLicence:
                return UIFont(name: "Montserrat-ExtraBold", size: 27)!
            case .originalCitation:
                return UIFont(name: "Montserrat-Bold", size: 30)!
            case .courtNotice:
                return UIFont(name: "Montserrat-ExtraBold", size: 24)!
            }
        }
    }
}

enum TicketHistoryLabel: String {
    case status,
    statusdetail,
    citation,
    createdAt,
    address,
    incident,
    license,
    ticket,
    document,
    confirmation,
    confirmation2,
    trafficSchool
    
    var title: String {
        get {
            switch self {
            case .status:
                return "Status"
            case .statusdetail:
                return "Status Detail"
            case .citation:
                return "Citation"
            case .createdAt:
                return "Created At"
            case .address:
                return "Address"
            case .incident:
                return "Incident"
            case .license:
                return "License"
            case .ticket:
                return "Ticket"
            case .document:
                return "Document"
            case .confirmation:
                return "Confirmation"
            case .confirmation2:
                return "Confirmation"
            case .trafficSchool:
                return "Have you taken traffic school in past 18 months?"
            }
        }
    }
}

//MARK:Placeholder Images
struct PlaceholderImages{
    static let StylePlaceholderIcon = "style_placeholder_icon"
    static let Profile = "profile_placeholder"
    static let ImagePlaceholder = "image_placeholder"
}

//MARK:Server Response Key
struct ServerResponseKey {
    static let SUCCESS = "success"
    static let ERROR = "error"
    static let RESULT = "result"
}

