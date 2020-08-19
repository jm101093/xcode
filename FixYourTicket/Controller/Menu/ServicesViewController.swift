//
//  ServicesViewController.swift
//  FixYourTicket
//
//  Created by Santosh on 16/08/18.
//  Copyright © 2018 Bitcot. All rights reserved.
//

import UIKit

class ServicesViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let boldStringArray = ["Infractions", "(FTA) Failure To Appear", "Misdemeanors", "DUI", "Probation Violations", "Warrants"]
        self.textView.font = UIFont(name: "Montserrat-Regular", size: 16)
        let originalText = textView.text
        let attributString = NSMutableAttributedString(string: originalText!)
        let stringRange = NSMakeRange(0, attributString.length)
        attributString.addAttributes([NSAttributedStringKey.font : UIFont(name: "Montserrat-Regular", size: 17)!], range: stringRange)
        for string in boldStringArray {
            let substringRange = NSString(string: originalText!).range(of: string, options: .caseInsensitive)
            attributString.addAttributes([NSAttributedStringKey.font : UIFont(name: "Montserrat-Bold", size: 17)!], range: substringRange)
        }
        self.textView.attributedText = attributString
        self.textView.textAlignment = .center
        self.textView.setContentOffset(CGPoint.zero, animated: false)
        self.textView.isEditable = false
        textView.contentOffset.y = -64 //or = 0 if no Navigation Bar
        textView.isScrollEnabled = false
        textView.layoutIfNeeded()
        textView.isScrollEnabled = true
        loadNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    func loadNavigationBar() {
        self.navigationController?.loadAttributes(navTintColor: .lightGray)
        self.navigationController?.setNavigationTitle(title: Constants.AppTitleName, navigationItem: navigationItem)
        self.navigationController?.addLeftBarButtonImage(leftImage: #imageLiteral(resourceName: "menu"), navigationItem: navigationItem)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        var scrollToLocation = 50 //<needed position>
//        textView.contentOffset.y = textView.contentSize.height
//        textView.scrollRangeToVisible(NSRange.init(location: scrollToLocation, length: 1))
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.textView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc func didTapOnLeftNavigationButton() {
        slideMenuController()?.openLeft()
    }

}
