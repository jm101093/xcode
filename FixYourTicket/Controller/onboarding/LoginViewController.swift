//
//  LoginViewController.swift
//  FixYourTicket
//
//  Created by Santosh on 09/08/18.
//  Copyright © 2018 Bitcot. All rights reserved.
//

import UIKit
import UserNotifications
class LoginViewController: UIViewController , UNUserNotificationCenterDelegate {

    @IBOutlet weak var emailFieldView: CustomTextField!
    @IBOutlet weak var passwordFieldView: CustomTextField!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var password: String!
    var email: String!
    let appSession = AppSession.sharedInstance
    let apiWrapper = AlamofireAPIWrapper.sharedInstance
    let loggedInUser = LoggedInUser.sharedInstance
     var iskeyBoardVisible = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitials()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNavigationBar()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillShow(sender:)), name:.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillHide(sender:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    
    func loadInitials() {
//        emailFieldView.configureField(placeholder: "Email", enableCorrection: false)
        passwordFieldView.configureField(placeholder: "Password", isSecureTextEntry: true)
        emailFieldView.configureField(tag: 0, placeholder: "Email", keyboardType: .emailAddress, returnType: .done, isSecureTextEntry: false, fontSize: 17.0, enableCorrection: false)
    }
    
    func loadNavigationBar() {
        self.navigationController?.loadAttributes()
        self.navigationController?.applyBgTransparency()
    }
    
    func loginUser() {
        email = trimWhitespaces(text: emailFieldView.getText())
        password = passwordFieldView.getText()
        
        if email == "" {
            showAlert(target: self, message: Constants.Error.loginMsg, title: "Oops!", buttonTitle: "OK")
            return
        }else if password == "" {
            showAlert(target: self, message: Constants.Error.enterPasswordErrorMsg, title: "Oops!", buttonTitle: "OK")
            return
        }
        
        if !ReachabilityManager.sharedInstance.isReachable() {
            showNetworkAlert()
            return
        }
       
        var requestDict: JSONDictionary = ["username": email! as AnyObject, "password": password! as AnyObject, "method": "login" as AnyObject]
        
        let deviceBody = APNS.sharedInstance.deviceRequest()
        if let _ = deviceBody {
            requestDict["device_token"] = deviceBody! as AnyObject
            requestDict["device_type"] = "ios" as AnyObject
        }
        login(requestJSON: requestDict)
    }
    
    func login(requestJSON: JSONDictionary) {
        showProgress(message: nil)
        self.apiWrapper.userSignIn(requestDict: requestJSON , responseBlock: {
            (response: AlamofireAPIResponse) in
            let(isSuccessful,responseObject) =  self.validateServerResponse(response: response, showErrorAlert: true)
            if isSuccessful {
                print(responseObject)
    
                
                
                let result = responseObject?["result"] as? JSONArray
                let message = result?.first?["message"] as? String
                if let _ = message {
                    showAlert(target: self, message: message!, title: "Oops", buttonTitle: "OK")
                }else {
                    self.loggedInUser.storeUserDetails(response: responseObject!)
                    self.onSuccessfulLogin()
                    self.hideProgress()
                }
            }else {
                
            }
            self.hideProgress()
        })
    }
    
    func onSuccessfulLogin(){
        loadHomeVC()
    }
    
    func loadHomeVC() {
        self.appSession.loadHomeVC()
    }

    @IBAction func didTapOnLogIn(_ sender: Any) {
        loginUser()
     //   self.scheduleLocalNotification(date:Date() as NSDate,title:"Message",alertAction:"hello",userInfo:[:])
    }
    
    @IBAction func didTapOnSignUp(_ sender: Any) {
        let signUpVC = storyboard?.instantiateViewController(withIdentifier: SegueIdentifier.SignUpViewController) as! SignUpViewController
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    
    @IBAction func didTapOnForgotPassword(_ sender: Any) {
        let forgotPasswordVC = storyboard?.instantiateViewController(withIdentifier: SegueIdentifier.ForgotViewController) as! ForgotViewController
        self.navigationController?.pushViewController(forgotPasswordVC, animated: true)
    }
    
    func removeLocationNotification(localNotification:String){
        //   let app = UIApplication.shared
        //  app.cancelLocalNotification(localNotification)
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [localNotification])
    }
    
    func removeAllLocationNotification(){
        //  let app = UIApplication.shared
        //  app.cancelAllLocalNotifications()
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
    /*
    func scheduleLocalNotification(date:NSDate,title:String,alertAction:String,userInfo:[String:String]){
        print(date)
        print(date as Date)
        let content = UNMutableNotificationContent()
        content.body = NSString.localizedUserNotificationString(forKey: "You are on \(title) activity rahul jain", arguments: nil)
        content.sound = UNNotificationSound.default()
        content.userInfo = userInfo
        // let dateComponents = DateComponents(year: year, month: month, day: day)
        // let yourFireDate = Calendar.current.date(from: date as Date as Date)
        let today = date as Date
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: today)
        
        var dateComp:DateComponents = DateComponents()
        dateComp.day = components.day
        dateComp.month = components.month
        dateComp.year = components.year
        // dateComp.hour = 10
        // dateComp.minute = 00
        // let date = calendar.date(from: dateComp)
      //  let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
        //  content.alertAction = alertAction
        // content.categoryIdentifier = "Your notification category"
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 60.0, repeats: true)
        let request = UNNotificationRequest(identifier: "Your notification identifier", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if let error = error {
                //handle error
                print(error.localizedDescription)
            } else {
                //notification set up successfully
            }
        })
        
        //      let notification =   UILocalNotification()
        //      notification.fireDate = date as Date
        //  notification.alertBody = "You are on \(title) activity"
        //      notification.alertAction = alertAction
        //   notification.soundName = UILocalNotificationDefaultSoundName
        //   notification.userInfo = userInfo
        //       UIApplication.shared.scheduleLocalNotification(notification)
        
        // UNUserNotificationCenter.current()
        //    let notification =   UILocalNotification()
        //    notification.fireDate = date as Date
        //    notification.alertBody = "You are on \(title) activity"
        //    notification.alertAction = alertAction
        //    notification.soundName = UILocalNotificationDefaultSoundName
        //    notification.userInfo = userInfo
        //    UIApplication.shared.scheduleLocalNotification(notification)
    }
 */
    
}

extension LoginViewController {
    //MARK: - Keyboard show/hide adjust scrollview.
    @objc func keyBoardWillShow(sender:NSNotification){
        if iskeyBoardVisible == false{
            iskeyBoardVisible = true
            let userInfo = sender.userInfo!
            let keyBoardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let ownFrame = view.window?.convert(view.frame, from: view.superview)
            if let _ = ownFrame {
                let coverFrame = ownFrame!.intersection(keyBoardFrame)
                scrollView.contentInset = UIEdgeInsetsMake(0, 0, scrollView.contentInset.bottom + coverFrame.size.height, 0)
                //  scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentInset.bottom)
                self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset
            }
        }
    }
    
    @objc func keyBoardWillHide(sender: NSNotification) {
        iskeyBoardVisible = false
        self.scrollView.contentInset = UIEdgeInsets.zero;
        self.scrollView.setContentOffset(CGPoint.zero, animated: true)
        self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
    }
}
