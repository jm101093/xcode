//
//  APNS.swift
//  danceplus
//
//  Created by Bitcot Inc on 5/27/16.
//  Copyright © 2016 Bitcot Inc. All rights reserved.
//

import UIKit
class APNS: NSObject {
    static let sharedInstance = APNS()
    let apiWrapper = AlamofireAPIWrapper.sharedInstance
    var deviceToken:String?{
        didSet{
            syncDeviceToken()
        }
    }
    var isNotificationReceived = false
    var isDeviceTokenSynced = false
    let user = LoggedInUser.sharedInstance
    var notificationType:NotificationOption!
    var isAppLaunched = false
    var sessionID:Int?
    var notificationMsg:String?
    
    func syncDeviceToken(){
        if user.isLoggedIn{
            let deviceToken = deviceRequest()!
            let requestBody: JSONDictionary = ["device_token":deviceToken as AnyObject, "access_token": user.authToken as AnyObject, "uid": user.userID as AnyObject, "method": "update_token" as AnyObject, "device_type": "ios" as AnyObject]
            apiWrapper.syncDeviceToken(requestDict: requestBody, responseBlock: ({(response:AlamofireAPIResponse) in
                if let responseObject = response.responseObject{
                    var eval:Bool = false
                    if let result  = responseObject["result"] as? JSONDictionary{
                        if let _ = result["updated_device_token"] as? String {
                            eval = true
                        }else{
                            eval = false
                        }
                    }
                    else{
                        if let _ = responseObject[ServerResponseKey.SUCCESS] as? Int{
                            let result  = responseObject[ServerResponseKey.SUCCESS] as! Int
                            eval = result.toBool()!
                        }
                    }
                    if eval{
                        self.isDeviceTokenSynced = true
                    }
                    else{
                        //failed
                        self.isDeviceTokenSynced = false
                    }
                }
            }))
        }
    }
    
    func deviceRequest() -> String?{
        if let _ = APNS.sharedInstance.deviceToken{
            return APNS.sharedInstance.deviceToken
        }
        return nil
    }
    
    
    func reset(){
        isNotificationReceived = false
        sessionID = nil
    }
    
    func handleAPNSNotification(userInfo:[NSObject:AnyObject], isAppInforeground:Bool, isAppLaunched:Bool){
        self.isAppLaunched = isAppLaunched
        let apsDict = userInfo as! [String:AnyObject]
        let apsBody = apsDict["aps"]!
        user.enableBadgeCount = true
        
        user.save()
        
        print("apsBody:",apsBody)

        if let badgeCount = apsBody["badge"] as? Int{
           // notificationType = NotificationOption(rawValue: type)
            
            if let msg = apsBody["alert"] as? String{
                notificationMsg = msg
            }
            
            UIApplication.shared.applicationIconBadgeNumber = badgeCount
            
            if !isAppLaunched{
                handleAPNSDetailWhenIsActive(apsBody: apsBody as! [String:AnyObject], isAppInBackground: !isAppInforeground)
            }else{
                isNotificationReceived = true
            }
        }
    }
    
    /**********************Handling of Notifications
     Logic to handle notification, in background/foreground/When the App is killed
     *************************/
    
    //this function is called only if app is launched from notification
    //respective viewcontrollers will be passed as param for any specific action on the same
    
    
    func processNotificationDetailsOnInitialization(controller:AnyObject?){
        AppSession.sharedInstance.navigateToTicketHistory()
    }
    

    //Function is called only when app is active
    func handleAPNSDetailWhenIsActive(apsBody:[String:AnyObject], isAppInBackground:Bool) {
        //this if block should run irrespective of app state
        if isAppInBackground{
            //When is active in the background and opened through notification
            AppSession.sharedInstance.navigateToTicketHistory()
        }else{
            //When the app is open
            
            if let _ = notificationMsg{
                showInAppAlert(message: notificationMsg!, title: "You have a Notification!")
            }
        }
        let showNotification = true
        NotificationCenter.default.post(name: Notification.Name.kButtonHighlationNotification, object: showNotification)

    }
    
    
    func topViewController() -> UIViewController?{
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
            // topController should now be your topmost view controller
        }
        return nil
    }
    
    func showInAppAlert(message:String, title:String){
        showAlert(target: topViewController()!, message: message, title: title, buttonTitle: "OK")
    }
    
}
