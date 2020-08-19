//
//  ForgotViewController.swift
//  FixYourTicket
//
//  Created by Santosh on 10/08/18.
//  Copyright © 2018 Bitcot. All rights reserved.
//

import UIKit

class ForgotViewController: UIViewController {

    @IBOutlet weak var emailField: CustomTextField!
    
    var email: String!
    var apiWrapper = AlamofireAPIWrapper.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNavigationBar()
        emailField.configureField(placeholder: "Email", keyboardType: .emailAddress, enableCorrection: false)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addBorder(view: emailField, withColor: .black)
    }
    
    func loadNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.loadAttributes(navTintColor: .white)
        self.navigationController?.setNavigationTitle(title: Constants.AppTitleName, navigationItem: navigationItem)
        self.navigationController?.addLeftBarButtonImage(leftImage: #imageLiteral(resourceName: "back_icon"), navigationItem: navigationItem)
    }
    
    
    @objc func didTapOnLeftNavigationButton() {
        self.navigationController?.popViewController(animated: true)
    }

    
    @IBAction func didTapOnSend(_ sender: Any) {
        if !ReachabilityManager.sharedInstance.isReachable() {
            showNetworkAlert()
            return
        }
        
        email = trimWhitespaces(text: emailField.getText())
        if email == "" || !email.isValidEmail() {
            showAlert(target: self, message: Constants.Error.enterValidEmailErrorMsg, title: "Oops", buttonTitle: "OK")
            return
        }
        
        let requestDict: JSONDictionary = ["email": email as AnyObject, "method": "reset_password" as AnyObject]
        showProgress(message: nil)
        apiWrapper.forgotPassword(requestDict: requestDict) { (response) in
            if response.isSuccessful == true {
                let responseObject = response.responseObject!
                if let result = responseObject["result"] as? JSONDictionary {
                    let message = result["message"] as! String
                    if message != "Invalid email" {
                        self.showAlertPopController(target: self, message: "Please check your email to proceed!", title: "Success", buttonTitle: "OK")
                    }else {
                        showAlert(target: self, message: "Invalid Email.", title: "Oops..", buttonTitle: "OK")
                    }
                }else {
                    self.showErrorAlert()
                }
            }else {
                self.showErrorAlert()
            }
            self.hideProgress()
        }
    }
    
}
