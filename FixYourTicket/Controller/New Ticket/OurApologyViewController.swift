//
//  OurApologyViewController.swift
//  FixYourTicket
//
//  Created by Santosh on 16/08/18.
//  Copyright © 2018 Bitcot. All rights reserved.
//

import UIKit

class OurApologyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadNavigationBar()
    }
    
    func loadNavigationBar() {
        self.navigationController?.loadAttributes(navTintColor: .white)
        self.navigationController?.setNavigationTitle(title: Constants.AppTitleName, navigationItem: navigationItem)
        self.navigationController?.addLeftBarButtonImage(leftImage: #imageLiteral(resourceName: "back_icon"), navigationItem: navigationItem)
    }
    
    
    @objc func didTapOnLeftNavigationButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func didTapOnOkay(_ sender: Any) {
        AppData.sharedInstance.resetTicket()
        self.navigationController?.popToRootViewController(animated: true)
    }
}
