//
//  SignUpViewController.swift
//  FixYourTicket
//
//  Created by Santosh on 09/08/18.
//  Copyright © 2018 Bitcot. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

   
    @IBOutlet weak var firstNameField: CustomTextField!
    @IBOutlet weak var lastNameField: CustomTextField!
    
    @IBOutlet weak var emailField: CustomTextField!
    
    @IBOutlet weak var confirmEmailField: CustomTextField!
    
    @IBOutlet weak var passwordField: CustomTextField!
    
    @IBOutlet weak var confirmPasswordField: CustomTextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var firstName: String!
    var lastName: String!
    var email: String!
    var confrimEmail: String!
    var password: String!
    var confrimPassword: String!
    var apiWrapper = AlamofireAPIWrapper.sharedInstance
    var appSession = AppSession.sharedInstance
    let loggedInUser = LoggedInUser.sharedInstance
    var iskeyBoardVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitials()
        loadNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        emailField.configureField(placeholder: "EMAIL", keyboardType: .emailAddress, enableCorrection: false)
        passwordField.configureField(placeholder: "PASSWORD", isSecureTextEntry: true)
        firstNameField.configureField(placeholder: "FIRST NAME")
        lastNameField.configureField(placeholder: "LAST NAME")
        confirmEmailField.configureField(placeholder: "CONFIRM EMAIL ADDRESS", keyboardType: .emailAddress, enableCorrection: false)
        confirmPasswordField.configureField(placeholder: "CONFIRM PASSWORD", isSecureTextEntry: true)
    }
    
    func loadNavigationBar() {
        self.navigationController?.loadAttributes()
        self.navigationController?.applyBgTransparency()
        self.navigationController?.addLeftBarButtonTitle(title: "Back", navigationItem: navigationItem)
    }
    
    @objc func didTapOnLeftNavigationButton() {
        self.navigationController?.popViewController(animated: true)
    }

    
    func registerUser() {
        email = trimWhitespaces(text: emailField.getText())
        firstName = firstNameField.getText()
        lastName = lastNameField.getText()
        confrimEmail = trimWhitespaces(text: confirmEmailField.getText())
        password = passwordField.getText()
        confrimPassword = confirmPasswordField.getText()
        
        if firstName == "" {
            showAlert(target: self, message: Constants.Error.enterFirstNameErrorMsg, title: "Oops", buttonTitle: "OK")
            return
        }else if lastName == "" {
            showAlert(target: self, message: Constants.Error.enterLastNameErrorMsg, title: "Oops", buttonTitle: "OK")
            return
        }else if email == "" || !email.isValidEmail() {
            showAlert(target: self, message: Constants.Error.enterValidEmailErrorMsg, title: "Oops", buttonTitle: "OK")
            return
        }else if confrimEmail == "" || confrimEmail != email {
            showAlert(target: self, message: "Emails do not match, Please try again!", title: "Oops", buttonTitle: "OK")
            return
        }else if password == "" {
            showAlert(target: self, message: Constants.Error.enterPasswordErrorMsg, title: "Oops", buttonTitle: "OK")
            return
        }else if confrimPassword == "" || confrimPassword != password {
            showAlert(target: self, message: "Passwords do not match, Please try again!", title: "Oops", buttonTitle: "OK")
            return
        }
        
        var requestDict: JSONDictionary = ["first_name": firstName as AnyObject, "last_name": lastName as AnyObject, "email": email as AnyObject, "username": email as AnyObject, "password": password as AnyObject, "method": "register" as AnyObject]
        let deviceBody = APNS.sharedInstance.deviceRequest()
        if let _ = deviceBody {
            requestDict["device_token"] = deviceBody! as AnyObject
            requestDict["device_type"] = "ios" as AnyObject
        }

        
        showProgress(message: nil)
        apiWrapper.userSignUp(params: requestDict) { (response) in
            let (success, result) = self.validateServerResponse(response: response, showErrorAlert: true)
            if success {
                let responseObject = result?["result"] as? JSONArray
                let message = responseObject?.first?["message"] as? String
                if let _ = message {
                    showAlert(target: self, message: message!, title: "Oops", buttonTitle: "OK")
                }else {
                    self.loggedInUser.storeUserDetails(response: result!)
                    self.appSession.loadHomeVC()
                }
            }
            self.hideProgress()
        }

    }
  
    @IBAction func didTapOnRegister(_ sender: Any) {
        registerUser()
    }
}

extension SignUpViewController {
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

