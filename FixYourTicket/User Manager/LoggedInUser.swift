    
//  LoggedInUser.swift
//  Notv
//
//  Created by on 14/01/16.
//  Copyright © 2016 bitcot. All rights reserved.
//

import UIKit

class LoggedInUser: NSObject {

//    token for when user is logged in
    let kFirstNameKey = "FIRST_NAME_KEY"
    let kLastNameKey = "LAST_NAME_KEY"
    let kAuthTokenKey = "AUTH_TOKEN_KEY"
    let kEmailKey = "EMAIL_KEY"
    let kUserIDKey = "USER_ID_KEY"
    let kFBLogin = "FB_LOGIN"
    let kPhotoURLKey = "PHOTO_URL"
    let kBadgeCount = "Badge_Count"
    
    static let sharedInstance = LoggedInUser()
    
    var userID: Int?
    var authToken:String!
    var firstName: String?
    var lastName: String?
    var email: String?
    var photoURL:String?
    var isFBLoggedIn:Bool?
    var enableBadgeCount: Bool?
    
    override init() {
        super.init()
        self.loadLoggedInDetails()
    }
    
    var isLoggedIn: Bool {
        get {
            if (authToken != nil && authToken!.characters.count > 0) {
                return true
            } else {
                return false
            }
        }
    }
    
    func loadLoggedInDetails() {
        print("Loading login details...")
        userID = getUserDefault(key: kUserIDKey) as? Int
        firstName = getUserDefault(key: kFirstNameKey) as? String
        lastName = getUserDefault(key: kLastNameKey) as? String
        email = getUserDefault(key: kEmailKey) as? String
        authToken = getUserDefault(key: kAuthTokenKey) as? String
        photoURL = getUserDefault(key: kPhotoURLKey) as? String
        isFBLoggedIn =  getUserDefault(key: kFBLogin) as? Bool
        enableBadgeCount = getUserDefault(key: kBadgeCount) as? Bool
    }
    
    func storeUserDetails(response:[String:AnyObject]){
        let user = response["result"] as? [String:AnyObject]
        if let user = user{
            var userID: Int? = 0
            var email: String?
            if let userIdInString = user["ID"] as? String {
                userID = Int(userIdInString)!
            }else {
                userID = user["ID"] as? Int
            }
            let authToken = user["access_token"] as? String
            if let _ = user["user_email"] as? String {
                 email = user["user_email"] as? String
            }else {
                email = user["email"] as? String
            }
            let firstName = user["first_name"] as? String
            let lastName = user["last_name"] as? String
            let photoURL = user["photo"] as? String
            self.setUserDetails(firstName: firstName, lastName: lastName, email: email, userID: userID, authToken: authToken, photoURL: photoURL)
            save()
        }
    }

    func setUserDetails(firstName:String?, lastName:String?, email:String?, userID:Int?, authToken:String?, photoURL:String?){
        if let _ = firstName{
            self.firstName = firstName
        }
     
        if let _ = lastName{
            self.lastName = lastName
        }
        
        if let _ = email{
            self.email = email
        }
        
        if let _ = userID{
            self.userID = userID
        }
        
        if let _ = authToken{
            self.authToken = authToken
        }
        
        self.photoURL =  photoURL
        
        save()
    }
    
    func save() {
        print("Saving user details...")
        if let firstName = firstName {
            setUserDefault(key: kFirstNameKey, value: firstName as AnyObject)
        }
        
        if let lastName = lastName {
            setUserDefault(key: kLastNameKey, value: lastName as AnyObject)
        }
        
        if let email = email {
            setUserDefault(key: kEmailKey, value: email as AnyObject)
        }
        
        if let authToken = authToken {
            setUserDefault(key: kAuthTokenKey, value: authToken as AnyObject)
        }
        
        if let userID = userID{
            setUserDefault(key: kUserIDKey, value: userID as AnyObject)
        }
        
        if let photoURL =  photoURL{
            setUserDefault(key: kPhotoURLKey, value: photoURL as AnyObject)
        }
        
        if let enableBadgeCount = enableBadgeCount {
            setUserDefault(key: kBadgeCount, value: enableBadgeCount as AnyObject)
        }else {
            UserDefaults.standard.removeObject(forKey: kBadgeCount)
        }
        
        print("Details saved.")
    }
    
    func logout() {
        print("Log out.")
        self.deleteLoggedInDetails()
        // handle 3rd party logout
    }
    
    func deleteLoggedInDetails() {
        print("Deleting logged in details...")
        UserDefaults.standard.removeObject(forKey: kAuthTokenKey)
        UserDefaults.standard.removeObject(forKey: kFirstNameKey)
        UserDefaults.standard.removeObject(forKey: kLastNameKey)
        UserDefaults.standard.removeObject(forKey: kUserIDKey)
        UserDefaults.standard.removeObject(forKey: kEmailKey)
        UserDefaults.standard.removeObject(forKey: kFBLogin)
        UserDefaults.standard.removeObject(forKey: kBadgeCount)
        
        userID = nil
        firstName = nil
        lastName = nil
        isFBLoggedIn =  false
        photoURL = nil
        email = nil
        authToken = nil
        enableBadgeCount = nil
    }
}
