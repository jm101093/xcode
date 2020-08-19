//
//  EnterCitationViewController.swift
//  FixYourTicket
//
//  Created by Santosh on 16/08/18.
//  Copyright © 2018 Bitcot. All rights reserved.
//

import UIKit

class EnterCitationViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var phoneField: CustomTextField!
    
    @IBOutlet weak var fullAddressField: CustomTextField!
    
    @IBOutlet weak var ticketDueDateField: CustomTextField!
    
    @IBOutlet weak var dobField: CustomTextField!
    
    @IBOutlet weak var whatHappendedField: CustomTextField!
    
    @IBOutlet weak var schollView: UIView!
    
    @IBOutlet weak var agreementLabel: UILabel!
    
    
    
    var datePicker = UIDatePicker()
    var dueDatePicker = UIDatePicker()
    var activeField: CustomTextField!
    var toolBar = UIToolbar()
    var createTicket: Ticket {
        get {
            return AppData.sharedInstance.createTicket
        }
    }

    var loggedInUser = LoggedInUser.sharedInstance
    var address:String!
    var phone: String!
    var incident: String!
    var citationDueDate: String!
    var dob: String!
    var isPreScool: Bool = false
    var apiWrapper = AlamofireAPIWrapper.sharedInstance
    var iskeyBoardVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitials()
        loadNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    func loadInitials() {
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        dueDatePicker.datePickerMode = .date
        dueDatePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(self.updateDate(sender:)), for: .valueChanged)
        dueDatePicker.addTarget(self , action: #selector(self.updateDate(sender:)), for: .valueChanged)
        phoneField.configureField(placeholder: "PHONE", keyboardType: .numberPad, fontSize: 14)
        fullAddressField.configureField(placeholder: "CURRENT FULL ADDRESS", fontSize: 14)
        ticketDueDateField.configureField(placeholder: "TICKET DUE DATE", fontSize: 13)
        dobField.configureField(placeholder: "DOB", fontSize: 14)
        whatHappendedField.configureField(placeholder: "WHAT HAPPENDED", fontSize: 14)
        dobField.delegate = self
        phoneField.delegate = self
        ticketDueDateField.delegate = self
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addBorder(view: fullAddressField, withColor: .black)
        addBorder(view: dobField, withColor: .black)
        addBorder(view: phoneField, withColor: .black)
        addBorder(view: ticketDueDateField, withColor: .black)
        addBorder(view: whatHappendedField, withColor: .black)
        addBorder(view: schollView, withColor: .black)
    }
    
    
    func loadNavigationBar() {
        self.navigationController?.loadAttributes(navTintColor: .white)
        self.navigationController?.setNavigationTitle(title: Constants.AppTitleName, navigationItem: navigationItem)
        self.navigationController?.addLeftBarButtonImage(leftImage: #imageLiteral(resourceName: "back_icon"), navigationItem: navigationItem)
    }
    
    func addToolBar(sender: AnyObject) {
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.doneKeyPad(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let fixedSpaceButton = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
      //  doneButton.tintColor = AppPallette.secondaryColor
        toolBar.setItems([fixedSpaceButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        if let textField = sender as? UITextField {
            textField.inputAccessoryView =  toolBar
        } else if let textView = sender as? UITextView {
            toolBar.setItems([fixedSpaceButton, spaceButton, doneButton], animated: true)
            textView.inputAccessoryView = toolBar
            textView.autoresizingMask = .flexibleHeight
        }
    }
    
    @objc func doneKeyPad(_: UITextField) {
        view.endEditing(true)
    }

    
    @objc func updateDate(sender: UIDatePicker) {
        if activeField == dobField {
            dobField.setText(text: sender.date.toDateDMY())
        }else  {
            ticketDueDateField.setText(text: sender.date.toDateDMY())
        }
    }
    
    
    @objc func didTapOnLeftNavigationButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func submitTicket() {
        phone = phoneField.getText()
        address = fullAddressField.getText()
        dob = dobField.getText()
        citationDueDate = ticketDueDateField.getText()
        incident = whatHappendedField.getText()
        if phone == "" || address == "" || dob == "" || citationDueDate == "" {
            showAlert(target: self, message: "Incomplete Fields, Please try again!", title: nil, buttonTitle: "OK")
            return
        }else if phone.count != 10 {
            showAlert(target: self, message: "Please enter phone number with 10 digits length", title: nil, buttonTitle: "OK")
            return
        }
        
        var requestDict: JSONDictionary = ["uid": loggedInUser.userID! as AnyObject, "method": "upload_ticket" as AnyObject, "access_token": loggedInUser.authToken as AnyObject, "address1": address as AnyObject, "pre_school": isPreScool as AnyObject, "citation_due_date": citationDueDate as AnyObject, "full_name": loggedInUser.firstName! as AnyObject, "first_name": loggedInUser.firstName! as AnyObject, "last_name": loggedInUser.lastName! as AnyObject, "incident": incident as AnyObject, "pno": phone as AnyObject, "email": loggedInUser.email! as AnyObject, "dob": dob! as AnyObject]
        
        if let userTicketImage = createTicket.userTicketImage {
            if let userTicketBase64String = UIImageJPEGRepresentation(userTicketImage, 0.1)?.base64EncodedString() {
                // Upload base64String to your database
                requestDict["user_ticket"] = "data:image/png;base64,\(userTicketBase64String)" as AnyObject
            }
        }
        
        if let licenseTicketImage = createTicket.licenseTicketImage {
            if let licenseTicketImageBase64String = UIImageJPEGRepresentation(licenseTicketImage, 0.1)?.base64EncodedString() {
                // Upload base64String to your database
                requestDict["licenseimage"] = "data:image/png;base64,\(licenseTicketImageBase64String)" as AnyObject
            }
        }
        
        if let keydocTicketImage = createTicket.keydocTicketImage {
            if let keydocTicketImageBase64String = UIImageJPEGRepresentation(keydocTicketImage, 0.1)?.base64EncodedString() {
                // Upload base64String to your database
                requestDict["keydocimage"] = "data:image/png;base64,\(keydocTicketImageBase64String)" as AnyObject
            }
        }
        
//        print(requestDict)
        
        showProgress(message: nil)
        apiWrapper.uploadTicketWithRecords(request: requestDict) { (response) in
            let (success, _) = self.validateServerResponse(response: response, showErrorAlert: true)
            if success {
                self.navigateToThankYouVC()
            }
            self.hideProgress()
        }
    }
    
    func navigateToThankYouVC() {
        AppData.sharedInstance.resetTicket()
        let thakYouVC = storyboard?.instantiateViewController(withIdentifier: SegueIdentifier.ThankYouViewController) as! ThankYouViewController
        self.navigationController?.pushViewController(thakYouVC, animated: true)
    }
    
    @IBAction func trafficSchoolSwitchAction(_ sender: UISwitch) {
        isPreScool = sender.isOn
        agreementLabel.text = isPreScool ? "Have you taken traffic school in past 18 months? - Yes" : "Have you taken traffic school in past 18 months? - NO"
    }
    
    @IBAction func didTapOnSubmit(_ sender: Any) {
        submitTicket()
    }
    
    
}

extension EnterCitationViewController: CustomTextFieldDelegate {
    func customTextFieldDidBeginEditing(customView: CustomTextField) {
        addToolBar(sender: customView.textField)
        activeField = customView
        if customView == dobField {
            dobField.setText(text: Date().toDateDMY())
            customView.textField.inputView = datePicker
        }else if customView == ticketDueDateField {
            ticketDueDateField.setText(text: Date().toDateDMY())
            customView.textField.inputView = dueDatePicker
        }
    }
    
    func customTextFieldShouldClear(customView: CustomTextField) -> Bool {
        return true
    }
    
    func customTextFieldShouldReturn(customView: CustomTextField) -> Bool {
        return true
    }
    
    func customTextFieldShouldBeginEditing(customView: CustomTextField) -> Bool {
        return true
    }
    
    func customTextField(customView: CustomTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}

extension EnterCitationViewController {
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


