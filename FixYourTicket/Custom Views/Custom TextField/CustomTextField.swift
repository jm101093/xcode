//
//  CustomTextField.swift
//  iCampSavvy
//
//  Created by Santosh on 16/06/17.
//  Copyright © 2017 bitcot. All rights reserved.
//

import UIKit

@objc protocol CustomTextFieldDelegate:class {
    @objc optional func customTextFieldShouldReturn(customView: CustomTextField) -> Bool
    @objc optional func customTextFieldDidBeginEditing(customView: CustomTextField)
    @objc optional func customTextFieldShouldBeginEditing(customView: CustomTextField) -> Bool
    @objc optional func customTextField(customView: CustomTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    @objc optional func customTextFieldShouldClear(customView: CustomTextField) -> Bool
}

class CustomTextField: UIView{
    
    @IBOutlet weak var textFieldTopConstarint: NSLayoutConstraint!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet var view: UIView!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var placeHolderHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var placeHolderLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textFieldLeadingConstraint: NSLayoutConstraint!
    
    
    
    var delegate: CustomTextFieldDelegate? = nil
    var placeHolderRevertAnimationPoint: CGFloat?
    var placeHolderAnimationPoint: CGFloat?
    var textFieldTopConstraintAnimationPoint: CGFloat?
    var errorText = ""
    
    required  init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadView()
    }
    
    func loadView(){
        let _ = Bundle.main.loadNibNamed("CustomTextField", owner: self, options: nil)?.first
        view.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        textField.delegate = self
        addSubview(view)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func animatePlaceHolder() {
        textFieldTopConstarint.constant = textFieldTopConstraintAnimationPoint == nil ? 10 : textFieldTopConstraintAnimationPoint!
        UIView.animate(withDuration: 0.3) {
            self.placeHolderLabel.font = self.placeHolderLabel.font.withSize(12.0)
            self.placeHolderHorizontalConstraint.constant = self.placeHolderAnimationPoint == nil ? -13.0 : self.placeHolderAnimationPoint!
            self.layoutIfNeeded()
        }
    }
    
    func revertPlaceHolderAnimation() {
        textFieldTopConstarint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.placeHolderLabel.font = self.placeHolderLabel.font.withSize(17.0)
            self.placeHolderLabel.textColor = .darkGray
            self.placeHolderHorizontalConstraint.constant = self.placeHolderRevertAnimationPoint == nil ? 0 : self.placeHolderRevertAnimationPoint!
            self.layoutIfNeeded()
        }
    }
    
    func loadTextField(text: String) {
        animatePlaceHolder()
        textField.text = text
        placeHolderLabel.textColor = .darkGray
    }
    
    func revertTextFieldData() {
        revertPlaceHolderAnimation()
        textField.text = ""
    }
    
    func getText() -> String {
        return textField.text!
    }

    
    func placeHolderTextStartAnimation() {
       
    }
    
    func placeHolderTextReverseAnimation() {
        
    }
    
    func updateCornerRadius() {
        addCornerRadius(view: textField, radius: textField.frame.height/2.0)
    }
    
    func configureField(tag: Int = 0, placeholder: String, keyboardType: UIKeyboardType = .default, returnType: UIReturnKeyType = .done, isSecureTextEntry: Bool = false, fontSize: CGFloat = 17, enableCorrection: Bool = false ) {
        self.textField.tag = tag
        placeHolderLabel.text = placeholder
        self.textField.keyboardType = keyboardType
        self.textField.returnKeyType = returnType
        self.textField.isSecureTextEntry = isSecureTextEntry
        self.textField.font = textField.font?.withSize(fontSize)
        self.placeHolderLabel.textColor = UIColor.darkGray
        self.placeHolderLabel.font = placeHolderLabel.font.withSize(fontSize)
        if !enableCorrection {
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .none
        }
    }
    
    func enableErrorAppearance(enable: Bool, errorText: String = "", textColor: UIColor = .black, bgColor: UIColor = .clear, borderColor: UIColor = .clear) {
        if enable {
            addBorder(view: self, withColor: textColor)
            self.view.backgroundColor = bgColor
            placeHolderLabel.textColor = .darkGray
            if errorText != "" {
                animatePlaceHolder()
            }
            self.errorText = errorText
            textField.text = errorText
            textField.textColor = textColor
        } else {
            self.view.backgroundColor = .white
            textField.textColor = .darkGray
            if textField.text == self.errorText {
                textField.text = ""
            }
            addBorder(view: self, withColor: borderColor)
        }
    }
    
    func setText(text:String){
        textField.text = text
        placeHolderLabel.textColor = UIColor.darkGray
        animatePlaceHolder()
    }
}

extension CustomTextField:UITextFieldDelegate{
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        if textField.text == "" {
            revertPlaceHolderAnimation()
        }
        if let _ = delegate {
            return delegate!.customTextFieldShouldReturn!(customView: self)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            revertPlaceHolderAnimation()
        }else {
            if textField.resignFirstResponder() {
                placeHolderLabel.textColor = .darkGray
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animatePlaceHolder()
        if let _ = delegate {
            delegate?.customTextFieldDidBeginEditing!(customView: self)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let _ = delegate {
            let val = delegate?.customTextFieldShouldBeginEditing!(customView: self)
            return val ?? true
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(range.length,range.location)
        if let _ = delegate {
            return delegate!.customTextField!(customView: self, shouldChangeCharactersIn: range, replacementString: string)
        }else {
            return true
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    //MARK:end
}
