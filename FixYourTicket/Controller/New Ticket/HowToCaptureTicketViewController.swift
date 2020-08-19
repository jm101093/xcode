//
//  HowToCaptureTicketViewController.swift
//  FixYourTicket
//
//  Created by Santosh on 14/08/18.
//  Copyright © 2018 Bitcot. All rights reserved.
//

import UIKit

class HowToCaptureTicketViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    func loadNavigationBar() {
        self.navigationController?.loadAttributes(navTintColor: .white)
        self.navigationController?.setNavigationTitle(title: Constants.AppTitleName, navigationItem: navigationItem)
        self.navigationController?.addLeftBarButtonImage(leftImage: #imageLiteral(resourceName: "back_icon"), navigationItem: navigationItem)
    }
    
    
    @objc func didTapOnLeftNavigationButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapOnContinue(_ sender: Any) {
        let createNewTicketVC = storyboard?.instantiateViewController(withIdentifier: SegueIdentifier.CreateNewTicketViewController) as! CreateNewTicketViewController
        self.navigationController?.pushViewController(createNewTicketVC, animated: true)
    }
}
