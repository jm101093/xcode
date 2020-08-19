//
//  ThankYouViewController.swift
//  FixYourTicket
//
//  Created by Santosh on 16/08/18.
//  Copyright © 2018 Bitcot. All rights reserved.
//

import UIKit

class ThankYouViewController: UIViewController {
    
    @IBOutlet weak var thankYouDescLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let originalString: NSString = thankYouDescLabel!.text! as NSString
        let substringRange = originalString.range(of: "OUR LAW FIRM WILL EVALUATE YOUR CASE PROMPTLY.", options: .caseInsensitive)
        let attrString = NSMutableAttributedString(string: originalString as String)
        attrString.addAttributes([NSAttributedStringKey.font : defaultBoldFont(size: thankYouDescLabel?.font.pointSize ?? 19)], range: substringRange)
        thankYouDescLabel.attributedText = attrString
        loadNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    func loadNavigationBar() {
        self.navigationController?.loadAttributes(navTintColor: .white)
        self.navigationController?.setNavigationTitle(title: Constants.AppTitleName, navigationItem: navigationItem)
        self.navigationController?.addLeftBarButtonImage(leftImage: UIImage(), navigationItem: navigationItem)
    }
    
    
    @objc func didTapOnLeftNavigationButton() {
        
    }
    
    @IBAction func didTapOnOkay(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        AppData.sharedInstance.resetTicket()
    }
    
}
