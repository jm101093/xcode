//
//  CustomNavigationBar.swift
//  Notv
//
//  Created by Bitcot Inc on 1/30/16.
//  Copyright © 2016 bitcot. All rights reserved.
//

import UIKit

extension UINavigationController{
    func setNavigationTitle(title:String, navigationItem:UINavigationItem){
        navigationItem.title = title;
    }
    
    func addLeftBarButtonImage(leftImage:UIImage, navigationItem:UINavigationItem){
        let barButton = UIBarButtonItem(image: leftImage, style: UIBarButtonItemStyle.plain, target: self.topViewController, action: Selector(("didTapOnLeftNavigationButton")))
        navigationItem.leftBarButtonItem = barButton
    }
    
    func addCustomLeftBarViewWithImageURL(leftImage:URL, navigationItem:UINavigationItem){
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.image = UIImage(named:PlaceholderImages.Profile)
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self.topViewController, action: #selector(UIViewController.didTapOnLeftNavigationButton)))
        
        //let barButton = UIBarButtonItem(image: leftImage, style: UIBarButtonItemStyle.plain, target: self.topViewController, action: Selector(("didTapOnLeftNavigationButton")))
        let barButton = UIBarButtonItem(customView: imageView)
        navigationItem.leftBarButtonItem = barButton
    }
    
    func addLeftBarButtonTitle(title:String,navigationItem:UINavigationItem){
        let barButton = UIBarButtonItem(title: title, style: .plain, target: self.topViewController, action: Selector(("didTapOnLeftNavigationButton")))
        barButton.setTitleTextAttributes([NSAttributedStringKey.font:navigationBarButtonTitleFont()], for: UIControlState.normal)
        // barButton.setTitleTextAttributes(NSFontAttributeName:, for: UIControlState)
        navigationItem.leftBarButtonItem = barButton
    }
    
    func addLeftBarButtonImage(image:UIImage, title:String, navigationItem:UINavigationItem){
        let searchButton = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self.topViewController, action: Selector(("didTapOnLeftNavigationButton")))
        let menuButton = UIBarButtonItem(title: title, style: .plain, target: self.topViewController, action: Selector(("didTapOnLeftNavigationButton")))
        navigationItem.leftBarButtonItems = [searchButton,menuButton]
    }
    
    @objc func addRightBarButtonImage(rightImage:UIImage,navigationItem:UINavigationItem){
        let barButton = UIBarButtonItem(image: rightImage, style: UIBarButtonItemStyle.plain, target: self.topViewController, action: Selector(("didTapOnRightNavigationButton")))
        navigationItem.rightBarButtonItem = barButton
    }
    
    func addRightBarButtonTitle(title:String,navigationItem:UINavigationItem){
        let barButton = UIBarButtonItem(title: title, style: .plain, target: self.topViewController, action: Selector(("didTapOnRightNavigationButton")))
        barButton.setTitleTextAttributes([NSAttributedStringKey.font:navigationBarButtonTitleFont()], for: UIControlState.normal)
        navigationItem.rightBarButtonItem = barButton
    }
    
    func addRightBarButtonItems(buttons:[UIBarButtonItem],navigationItem:UINavigationItem){
        navigationItem.rightBarButtonItems = buttons
    }
    
    func addRightBarButtonImages(rightIcon:UIImage, title:String,navigationItem:UINavigationItem){
        let searchButton = UIBarButtonItem(image: rightIcon, style: UIBarButtonItemStyle.plain, target: self, action: Selector(("didTapOnRightNavigationButton:")))
        let menuButton = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.plain, target: self, action: Selector(("didTapOnRightNavigationButton:")))
        navigationItem.rightBarButtonItems = [searchButton,menuButton]
    }
    
    func applyBgTransparency(){
        navigationBar.isTranslucent = true
        navigationBar.shadowImage = UIImage()
        view.backgroundColor = UIColor.clear
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.backgroundColor = UIColor.clear
    }
    
    func applyBgTransparencyWithExtendedBG(){
        navigationBar.isTranslucent = true
        navigationBar.barStyle = .default;
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }
    
    func loadAttributes(navTintColor: UIColor = AppPallette.navigationTintColor){
        isNavigationBarHidden = false
        navigationBar.isTranslucent = false
        let navBarTintColor = AppPallette.navigationBarTintColor;
        let navTintColor = navTintColor
        let titleAttributes:[NSAttributedStringKey:AnyObject] = [NSAttributedStringKey.font:navigationTitleFont(),NSAttributedStringKey.foregroundColor:AppPallette.navigationTitleColor]
        applyNavigationBarAttributes(navigationBarTintColor: navBarTintColor, navigationTintColor: navTintColor, navigationTitleAttributes: titleAttributes)
    }
    
    func applyNavigationBarAttributes(navigationBarTintColor: UIColor, navigationTintColor: UIColor, navigationTitleAttributes: [NSAttributedStringKey:AnyObject]){
        navigationBar.barTintColor = navigationBarTintColor
        navigationBar.tintColor = navigationTintColor
        navigationBar.titleTextAttributes = navigationTitleAttributes
    }
    
    func addTitleView(titleView:UIView,navigationItem:UINavigationItem){
        navigationItem.titleView = titleView
        navigationItem.titleView?.backgroundColor = UIColor.black
    }
    
    func hideBottomHairline() {
        self.navigationBar.setBackgroundImage(UIImage(),
                                              for: .any,
                                              barMetrics: .default)
        self.navigationBar.shadowImage = UIImage()
    }
}

protocol CustomNavigationBarProtocol : AnyObject{
    func didTapOnLeftNavigationButton(customNavigationBar:CustomNavigationBar)
    func didTapOnRightNavigationButton(customNavigationBar:CustomNavigationBar)
}

class CustomNavigationBar: UINavigationBar {
    
    var navigationItem:UINavigationItem?
    var delgate : CustomNavigationBarProtocol? = nil
    
    convenience init() {
        self.init(frame: CGRect.zero, target:nil)
    }
    
    init(frame:CGRect,target:UIViewController?){
        super.init(frame:frame)
        self.frame = frame;
        delgate = target
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        navigationItem = UINavigationItem()
        isTranslucent = false
        loadAttributes()
    }
    
    func loadAttributes(){
        let navBarTintColor = AppPallette.navigationBarTintColor;
        let navTintColor = AppPallette.navigationTintColor;
        let titleAttributes = [NSAttributedStringKey.font:navigationTitleFont(),NSAttributedStringKey.foregroundColor:AppPallette.navigationTitleColor]
        applyNavigationBarAttributes(navigationBarTintColor: navBarTintColor, navigationTintColor: navTintColor, navigationTitleAttributes: titleAttributes)
    }
    
    func applyNavigationBarAttributes(navigationBarTintColor: UIColor, navigationTintColor: UIColor, navigationTitleAttributes: [NSAttributedStringKey:AnyObject]){
        barTintColor = navigationBarTintColor
        tintColor = navigationTintColor
        titleTextAttributes = navigationTitleAttributes
    }
    
    func applyBgTransparency(){
        UINavigationBar.appearance().setBackgroundImage(
            UIImage(),
            for: .any,
            barMetrics: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        self.isTranslucent = true
    }
    
    func addLeftButtonTitle(title:String){
        let barButton = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.plain, target: self, action: #selector(CustomNavigationBar.didTapOnLeftButton))
        barButton.setTitleTextAttributes([NSAttributedStringKey.font:navigationBarButtonTitleFont()], for: UIControlState.normal)
        navigationItem?.leftBarButtonItem = barButton
        items = [navigationItem!]
    }
    
    func addRightButtonTitle(title:String){
        let barButton = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.plain, target: self, action:#selector(CustomNavigationBar.didTapOnRightButton))
        barButton.setTitleTextAttributes([NSAttributedStringKey.font:navigationBarButtonTitleFont()], for: UIControlState.normal)
        navigationItem?.rightBarButtonItem = barButton
        items = [navigationItem!]
    }
    
    func addLeftBarButtonImage(leftImage:UIImage){
        let barButton = UIBarButtonItem(image: leftImage, style: UIBarButtonItemStyle.plain, target: self, action:#selector(CustomNavigationBar.didTapOnLeftButton))
        navigationItem?.leftBarButtonItem = barButton
        items = [navigationItem!]
    }
    
    func addCustomRightBarViewWithImageURL(rightImageURL:URL?){
        let imageView = UIImageView(frame: CGRect(x: 0, y: -5, width: 37, height: 37))
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CustomNavigationBar.didTapOnRightButton)))
        addCornerRadius(view: imageView, radius: imageView.frame.width/2.0)
        addBorder(view: imageView, withColor: UIColor.white)
        
        // iOS 11 changes
        
        let widthConstraint = imageView.widthAnchor.constraint(equalToConstant: 40)
        let heightConstraint = imageView.heightAnchor.constraint(equalToConstant: 40)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        
        /////////////end
        
        if let url = rightImageURL{
            imageView.setImageWithUrl(url, placeHolderImage: UIImage(named:PlaceholderImages.Profile))
        }else{
            imageView.image = UIImage(named:PlaceholderImages.Profile)
        }
        let barButton = UIBarButtonItem(customView: imageView)
        navigationItem?.rightBarButtonItem = barButton
        items = [navigationItem!]
    }
    
    func removeRightBarButtonImage(){
        navigationItem?.rightBarButtonItem = nil
        items = [navigationItem!]
    }
    
    func removeLeftBarButtonImage(){
        navigationItem?.leftBarButtonItem = nil
        items = [navigationItem!]
    }
    
    func addRightBarButtonImage(leftImage:UIImage){
        let barButton = UIBarButtonItem(image: leftImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(CustomNavigationBar.didTapOnRightButton))
        navigationItem?.rightBarButtonItem = barButton
        items = [navigationItem!]
    }
    
    func setNavigationTitle(title:String){
        navigationItem!.title = title;
        items = [navigationItem!]
    }
    
    func addTitleView(titleView:UIView){
        navigationItem!.titleView = titleView
        items = [navigationItem!]
    }
    
    func addRightBarButtonImages(menuImage:UIImage, searchImage:UIImage){
        let searchButton = UIBarButtonItem(image: menuImage, style: UIBarButtonItemStyle.plain, target: self, action: Selector(("didTapOnMenu:")))
        
        let menuButton = UIBarButtonItem(image: searchImage, style: UIBarButtonItemStyle.plain, target: self, action: Selector(("didTapOnSearch:")))
        
        navigationItem?.rightBarButtonItems = [searchButton,menuButton]
        items = [navigationItem!]
    }
    
    
    func hideBottomHairline() {
        UINavigationBar.appearance().setBackgroundImage(
            UIImage(),
            for: .any,
            barMetrics: .default)
        
        UINavigationBar.appearance().shadowImage = UIImage()
        //         let navigationBarImageView = hairlineImageViewInNavigationBar(self)
        //        navigationBarImageView!.hidden = true
    }
    
    private func hairlineImageViewInNavigationBar(view: UIView) -> UIImageView? {
        if view.isKind(of: UIImageView.self) && view.bounds.height <= 1.0 {
            return (view as! UIImageView)
        }
        
        let subviews = (view.subviews as [UIView])
        for subview: UIView in subviews {
            if let imageView: UIImageView = hairlineImageViewInNavigationBar(view: subview) {
                return imageView
            }
        }
        
        return nil
    }
    
    //MARK: Action methods
    @objc func didTapOnLeftButton(){
        if delgate != nil{
            delgate?.didTapOnLeftNavigationButton(customNavigationBar: self)
        }
    }
    
    @objc func didTapOnRightButton(){
        if delgate != nil{
            delgate?.didTapOnRightNavigationButton(customNavigationBar: self)
        }
    }
}

