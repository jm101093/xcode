//
//  UIViewController+Progress.swift
//  NimbusCard
//
//  Created by Bitcot Inc on 17/12/15.
//  Copyright © 2015 Bitcot. All rights reserved.
//

import UIKit
import Branch
import Social
import MessageUI
import SVProgressHUD

extension UIViewController:CustomNavigationBarProtocol,MFMailComposeViewControllerDelegate{
    var isModal: Bool {
        return self.presentingViewController?.presentedViewController == self
            || (self.navigationController != nil && self.navigationController?.presentingViewController?.presentedViewController == self.navigationController)
            || self.tabBarController?.presentingViewController is UITabBarController
    }
    
    //        MARK: progress bar functionality
    func showProgress(message: String?) {
        self.setUp()
        if let msg = message {
            SVProgressHUD.show(withStatus: msg)
        } else {
            SVProgressHUD.show()
        }
    }
    
    func showProgressForCompletion(completed: Float) {
        self.setUp()
        SVProgressHUD.showProgress(completed)
    }
    
    func hideProgress() {
        SVProgressHUD.dismiss()
    }
    
    func hideProgressWithSuccess(message: String?) {
        setUp()
        SVProgressHUD.showSuccess(withStatus: message)
    }
    
    func hideProgressWithFailure(message: String?) {
        setUp()
        SVProgressHUD.showError(withStatus: message)
    }
    
    private func setUp() {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setDefaultStyle(.custom)
        // SVProgressHUD.setSuccessImage(UIImage(named: "Checkmark")!)
        SVProgressHUD.setBackgroundColor(UIColor.black.withAlphaComponent(0.85))
        SVProgressHUD.setForegroundColor(UIColor.white)
    }
    
    
    //MARK: alert functionality
    func showErrorAlertWithMsg(msg:String){
        showAlert(target: self, message: msg, title: "Oops...", buttonTitle: "OK")
    }
    
    func showErrorAlert(){
        showAlert(target: self, message: Constants.Error.generalMsg, title: "Oops...", buttonTitle: "OK")
    }
    
    func showNetworkAlert(){
        showAlert(target: self, message: Constants.Error.networkMsg, title: "Network Error", buttonTitle: "OK")
    }
    
    func showLoginErrorAlert(){
        showAlert(target: self, message: Constants.Error.loginMsg, title: "Login Error", buttonTitle: "OK")
    }
    
    func showLocationNotAllowedAlert(){
        var msg:String = ""
        showAlert(target: self, message: msg, title: "No Location Access", buttonTitle: "Got it!", buttonTitle2: "Settings", completionBlock: {
            index in
            if index == 2{
             //   UIApplication.shared.openURL(URL(string:UIApplicationOpenSettingsURLString)!)
                UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                
                
            }
        })
    }
    
    // MARK: default protocol optional functions
    
    @objc  func didTapOnLeftNavigationButton(customNavigationBar:CustomNavigationBar){
        
    }
    
    @objc  func didTapOnRightNavigationButton(customNavigationBar:CustomNavigationBar){
        
    }
    
    @objc  func didTapOnSearchButton(customNavigationBar:CustomNavigationBar){
        
    }
    
    @objc  func didTapOnMenuButton(customNavigationBar:CustomNavigationBar){
        
    }
    
    
    //    MARK:
    func addProgressLoadingToView(view:UIView){
        
    }
    
    func navigateWithSuccessfulMsg(msg:String,title:String, isPresented:Bool){
        let alert = showAlert(message: msg, title: title)
        let action = UIAlertAction(title: "OK", style:UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
            if isPresented{
                self.dismiss(animated: true, completion: nil)
            }
            else{
                self.navigationController?.popViewController(animated: true)
            }
        })
        alert.addAction(action)
        alert.view.tintColor = UIColor.black
        _ = UIApplication.shared.keyWindow?.rootViewController
        self.present(alert, animated: true, completion: {
            //            if isPresented{
            //                self.dismissViewControllerAnimated(true, completion: nil)
            //            }
            //            else{
            //                self.navigationController?.popViewControllerAnimated(true)
            //            }
        })
    }
    
    func navigateAfterShowingPrompt(msg:String,title:String, isPresented:Bool){
        let alert = showAlert(message: msg, title: title)
        let action = UIAlertAction(title: "OK", style:UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
            if isPresented{
                self.dismiss(animated: true, completion: nil)
            }
            else{
                let _ = self.navigationController?.popViewController(animated: true)
            }
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: {
        })
    }
    
    func loadViewControllerWithTabTitle(title:String!,image:UIImage){
        tabBarItem = UITabBarItem(title: title, image: image, tag: 0)
    }
    
    func addBGImageToView(view:UIView, image:UIImage){
        UIGraphicsBeginImageContext(view.frame.size)
        image.draw(in: view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        view.backgroundColor = UIColor(patternImage: image)
    }
    
    
    func loadActivityController(desc:String?,isBranchParamEnabled:Bool,branchParam:[String:AnyObject]?,image:UIImage?,sourceView:UIView?){
        showProgress(message: nil)
        #if DEBUG
            let branch: Branch = Branch.getInstance()
        #elseif ADHOC
            let branch: Branch = Branch.getInstance()
        #else
            //            distribution
            let branch: Branch = Branch.getInstance()
        #endif
        var objectsToShare = [AnyObject]()
        if let _ = image{
            objectsToShare.append(image!)
        }
        if let _ = desc{
            // objectsToShare.append(desc! as AnyObject)
        }
        
        branch.getShortURL(withParams: ["":""]) { (url, error) in
            self.hideProgress()
            if (error == nil) {
                // Now we can do something with the URL...
                var branchURL:AnyObject!
                if let urlLink = url{
                    // objectsToShare.append(urlLink as AnyObject)
                    branchURL = urlLink as AnyObject
                }
                let activityItem = CustomActivityProvider(placeholderItem: "" as AnyObject, facebookMessage: desc!, twitterMessage: desc!, emailMessage: desc!,url:branchURL)
                objectsToShare.append(activityItem)
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                
                if activityVC.responds(to: #selector(getter: UIViewController.popoverPresentationController)) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
                    activityVC.popoverPresentationController!.sourceView = sourceView
                    //activityVC.popoverPresentationController!.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                }
                
                self.present(activityVC, animated: true, completion: nil)
            }
        }
    }
    
    
    
    func loadActivityController(subject: String?, desc:String?, image:UIImage?, popOverFrame:CGRect?, sourceView:UIView?){
        
        var objectsToShare = [AnyObject]()
        if let _ = image{
            objectsToShare.append(image!)
        }
        if let _ = desc{
            objectsToShare.append(desc! as AnyObject)
        }
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.setValue(subject, forKey: "subject")
        let SHARETEXT = "Mr.Citation Man® Roberts & Roberts Law Firm. Download Fix Your Ticket® App!"
        activityVC.setValue(SHARETEXT, forKey: "subject")
        if activityVC.responds(to: #selector(getter: UIViewController.popoverPresentationController)) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            activityVC.popoverPresentationController!.sourceView = sourceView
        }
        
        self.present(activityVC, animated: true, completion: nil)
        
    }
    
    
    func shareViaTwitter(description:String, image:UIImage?){
        let moreString = "...\n()"
        let appLinkLength = moreString.characters.count + 6 //adding 6 as rought count for newlines on twitter dialog
        var modifiedDescription:String!
        let extraCharacters = appLinkLength + description.characters.count - 140
        if extraCharacters > 0{
            let charactersToBeRemoved = extraCharacters
            let index: String.Index = description.index(description.startIndex, offsetBy: description.characters.count - charactersToBeRemoved)
            print(index)
            modifiedDescription = description.substring(to: index)
            modifiedDescription = modifiedDescription + moreString
        }
        else{
            modifiedDescription = description + moreString
        }
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            let tweetShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            tweetShare.setInitialText(modifiedDescription)
            if let _ = image{
                tweetShare.add(image!)
            }
            self.present(tweetShare, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to tweet.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func isSuccessful(responseObject:[String:AnyObject]?) -> Bool{
        if let resultDict = responseObject?[ServerResponseKey.RESULT]{
            if let _  = resultDict["Code"] as? String {
                return false
            }else{
                return true
            }
        }
        return false
    }
    
    func validateServerResponse(response:AlamofireAPIResponse, showErrorAlert:Bool) -> (Bool, JSONDictionary?){
        if response.isSuccessful{
            let responseObject = response.responseObject as? JSONDictionary
            if self.isSuccessful(responseObject: responseObject){
                return (true, responseObject)
            }
            else{
                if let _ = responseObject{
                    if let error = responseObject!["error"] as? JSONDictionary{
                        let errorCode = error["code"] as? Int
                        let errorMsg = error["message"] as? String
                        self.hideProgress()
                        if let _ =  errorCode{
                            if showErrorAlert{
                                if errorMsg != nil {
                                    self.showErrorAlertWithMsg(msg: errorMsg!)
                                }
                            }
                            
                            if errorCode == 401 {
                                AppSession.sharedInstance.logout()
                            }
                        }
                    }else if let error = responseObject!["error"] as? String {
                        self.hideProgress()
                        if showErrorAlert {
                            showAlert(target: self, message: error, title: "Oops...", buttonTitle: "OK")
                        }
                    }else if let errorResutl = responseObject![ServerResponseKey.RESULT] as? JSONArray {
                        self.hideProgress()
                        if showErrorAlert {
                            let message = errorResutl.first?["message"] as? String
                            showAlert(target: self, message: message, title: "Oops...", buttonTitle: "OK")
                        }
                    }else{
                        self.hideProgress()
                        if showErrorAlert{
                            self.showErrorAlert()
                        }
                    }
                }
                else{
                    self.hideProgress()
                    if showErrorAlert{
                        self.showErrorAlert()
                    }
                }
                return (false, responseObject)
            }
        }
        else{
            self.hideProgress()
            if showErrorAlert{
                self.showErrorAlert()
            }
            return (false,nil)
        }
    }
    
    func loadEmailSupport(sender:String, subject:String ){
        //  let mailController = mailComposeController()
        let mailController  = MFMailComposeViewController()
        mailController.mailComposeDelegate = self
        mailController.setSubject(subject)
        mailController.setToRecipients([sender])
        
        var messageBody = "Find a bug? Have a question or suggestion? Need help?\n\nYour feedback is very important to us\nand can help make this app better for everyone!\n\nThank you for telling us how we can help.\nPlease enter your message below, between the dotted lines:\n----------------------------------------\n\n\n\n\n\n----------------------------------------\nDevice : " + UIDevice.current.localizedModel + "\niOS Version: " + UIDevice.current.systemVersion
        
        if let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String{
            messageBody = messageBody + "\n  App version: " + appVersion
        }
        
        mailController.setMessageBody(messageBody, isHTML: false)
        if MFMailComposeViewController.canSendMail() {
            self.present(mailController, animated: true, completion: nil)
        }
        else{
            showAlert(target: self, message: "Sorry cannot send mail", title: "Error", buttonTitle: "Ok")
        }
        
    }
    
    //MARK: MFMailComposeViewControllerDelegate
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    //MARK:end
    
    func currentScreenshot() -> UIImage{
        //Create the UIImage
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
        //        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    //Age
    func getAge(birthDate:Date) -> Int {
        let calendar = NSCalendar.current
        //let ageComponents = calendar.components(.Year,fromDate: birthDate,toDate: NSDate(),options: [])
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: Date())
        return ageComponents.year!
    }
    
}
