//
//  TicketLocationViewController.swift
//  FixYourTicket
//
//  Created by Santosh on 16/08/18.
//  Copyright © 2018 Bitcot. All rights reserved.
//

import UIKit

class TicketLocationViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var images: [UIImage] = [#imageLiteral(resourceName: "a1"), #imageLiteral(resourceName: "a2"), #imageLiteral(resourceName: "a3"), #imageLiteral(resourceName: "a4"), #imageLiteral(resourceName: "a5"), #imageLiteral(resourceName: "b1"), #imageLiteral(resourceName: "b2"), #imageLiteral(resourceName: "b3"), #imageLiteral(resourceName: "b4"), #imageLiteral(resourceName: "b5")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = #imageLiteral(resourceName: "a1")
        loadNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    func loadNavigationBar() {
        self.navigationController?.loadAttributes(navTintColor: .lightGray)
        self.navigationController?.setNavigationTitle(title: Constants.AppTitleName, navigationItem: navigationItem)
        self.navigationController?.addLeftBarButtonImage(leftImage: #imageLiteral(resourceName: "menu"), navigationItem: navigationItem)
    }
    
    @objc func didTapOnLeftNavigationButton() {
        slideMenuController()?.openLeft()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateImages()
    }
    
    func animateImages() {
        imageView.animationImages = images
        imageView.animationDuration = 20
        imageView.startAnimating()
    }
}
