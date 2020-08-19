//
//  PasswordTextField.swift
//  help
//
//  Created by Santosh on 19/01/18.
//  Copyright © 2018 Bitcot. All rights reserved.
//

import UIKit

@objc protocol PasswordTextFieldDelegate:class {
    @objc optional func passwordTextFieldShouldReturn(customView: PasswordTextField) -> Bool
    @objc optional func passwordTextFieldDidBeginEditing(customView: PasswordTextField)
    @objc optional func passwordTextFieldShouldBeginEditing(customView: PasswordTextField) -> Bool
    @objc optional func passwordTextField(customView: PasswordTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    @objc optional func passwordTextFieldShouldClear(customView: PasswordTextField) -> Bool
}

class PasswordTextField: UIView, UITextFieldDelegate {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var placeHolderText: UILabel!
    
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var placeHolderHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldTopConstraint: NSLayoutConstraint!
    
    var delegate: PasswordTextFieldDelegate? = nil
    var showSecureText = true
    var errorText = ""

    
    required  init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadView()
    }
    
    func loadView(){
        let _ = Bundle.main.loadNibNamed("PasswordTextField", owner: self, options: nil)?.first
        view.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        textField.delegate = self
        addSubview(view)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func enableErrorAppearance(enable: Bool, errorText: String = "") {
//        if enable {
//            addBorder(view: self, withColor: AppPallette.errorBorderColor)
//            self.view.backgroundColor = AppPallette.error2
//            placeHolderText.textColor = .darkGray
//            if errorText != "" {
//                animatePlaceHolder()
//            }
//            textField.text = errorText
//            textField.isSecureTextEntry = false
//            self.errorText = errorText
//            textField.textColor = AppPallette.errorBorderColor
//        } else {
//            self.view.backgroundColor = .white
//            textField.textColor = .darkGray
//            if textField.text == self.errorText {
//                textField.text = ""
//            }
//            textField.isSecureTextEntry = true
//            addBorder(view: self, withColor: AppPallette.base3)
//        }
        
    }
    
    func configureField(tag: Int = 0, placeholder: String, keyboardType: UIKeyboardType = .default, returnType: UIReturnKeyType = .done) {
        self.textField.tag = tag
        placeHolderText.text = placeholder
        self.textField.keyboardType = keyboardType
        self.textField.returnKeyType = returnType
    }
    
    func setText(text:String){
        textField.text = text
        animatePlaceHolder()
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        if textField.text == "" {
            revertPlaceHolderAnimation()
        }
        if let _ = delegate {
            delegate?.passwordTextFieldShouldReturn!(customView: self)
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animatePlaceHolder()
        if let _ = delegate {
            delegate?.passwordTextFieldDidBeginEditing!(customView: self)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(range.length,range.location)
//        if range.length == 1 && range.location == 0{
//            placeHolderText.textColor = AppPallette.base4
//        }else  {
//            placeHolderText.textColor = AppPallette.lightBlue
//        }
        if let _ = delegate {
            return delegate!.passwordTextField!(customView: self, shouldChangeCharactersIn: range, replacementString: string)
        }else {
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            revertPlaceHolderAnimation()
        }else {
            if textField.resignFirstResponder() {
                placeHolderText.textColor = .darkGray
            }
        }
    }
    
    func animatePlaceHolder() {
        textFieldTopConstraint.constant = 8
        UIView.animate(withDuration: 0.3) {
            self.placeHolderText.font = self.placeHolderText.font.withSize(12.0)
            self.placeHolderHorizontalConstraint.constant = -13
            self.layoutIfNeeded()
        }
    }
    
    func revertPlaceHolderAnimation() {
        textFieldTopConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.placeHolderText.font = self.placeHolderText.font.withSize(17.0)
            self.placeHolderHorizontalConstraint.constant = 0
            self.placeHolderText.textColor = .darkGray
            self.layoutIfNeeded()
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func placeHolderTextStartAnimation() {
        
    }
    
    func placeHolderTextReverseAnimation() {
        
    }
    
    func updateCornerRadius(){
        addCornerRadius(view: textField, radius: textField.frame.height/2.0)
    }
    
    @IBAction func didTapOnShowPassword(_ sender: Any) {
        if showSecureText {
            showSecureText = false
            textField.isSecureTextEntry = false
            showPasswordButton.setImage(#imageLiteral(resourceName: "showPassword"), for: .normal)
        }else {
            showSecureText = true
            showPasswordButton.setImage(#imageLiteral(resourceName: "signIn_Eye"), for: .normal)
            textField.isSecureTextEntry = true
        }
    }
    
}
