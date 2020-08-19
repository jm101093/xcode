//
//  MenuViewController.swift
//  FixYourTicket
//
//  Created by Santosh on 13/08/18.
//  Copyright © 2018 Bitcot. All rights reserved.
//

import UIKit



class MenuTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}

class MenuViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var loggedInUser = LoggedInUser.sharedInstance
    var appSession = AppSession.sharedInstance
    
    var menuOptions: [MenuOption] = [.home, .share, .location, .services]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.userNameLabel.text = "User: \(loggedInUser.email!)"
        // Do any additional setup after loading the view.
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        let option = menuOptions[indexPath.row]
        cell.titleLabel.text = option.title
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        slideMenuController()?.closeLeft()
        let option = menuOptions[indexPath.row]
        if option == .home {
            AppSession.sharedInstance.homeNavVC.popToRootViewController(animated: false)
        }else if option == .services {
            if appSession.homeNavVC.topViewController as? ServicesViewController == nil {
                AppSession.sharedInstance.homeNavVC.popToRootViewController(animated: false)
                let servicesVC = storyboard?.instantiateViewController(withIdentifier: SegueIdentifier.ServicesViewController) as! ServicesViewController
                self.appSession.homeNavVC?.pushViewController(servicesVC, animated: false)
            }
        }else if option == .location {
            if appSession.homeNavVC.topViewController as? TicketLocationViewController == nil {
                AppSession.sharedInstance.homeNavVC.popToRootViewController(animated: false)
                let locationVC = storyboard?.instantiateViewController(withIdentifier: SegueIdentifier.TicketLocationViewController) as! TicketLocationViewController
                self.appSession.homeNavVC.pushViewController(locationVC, animated: false)
            }
        }else if option == .share {
            let desc = "The Fix Your Ticket® App is the best way to fight your ticket in California. This is an actual law firm with an unequaled success rate at dismissing traffic tickets. The best part is that Fix Your Ticket will pay your fine if they can’t get your traffic ticket dismissed! Check them out at www.mrcitation.com to get all the details."
            loadActivityController(subject: "FIX YOUR TICKET", desc: desc, image: #imageLiteral(resourceName: "ScreenShot"), popOverFrame: nil, sourceView: nil)
        }
    }
}
