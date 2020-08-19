//
//  AppSession.swift
//  saveit
//
//  Created by Bitcot Inc on 30/08/16.
//  Copyright © 2016 Bitcot Inc. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class AppSession: NSObject{
    
    static let sharedInstance = AppSession()
    var loginNavVC: UINavigationController!
    var homeNavVC: UINavigationController!
    let loggedInUser = LoggedInUser.sharedInstance
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var slideMenuVC: SlideMenuController!
    var historyVC: TicketHistoryViewController!
    
    
    func loadHomeVC() {
        let window = appDelegate.window!
        if loggedInUser.isLoggedIn {
            let homeVC = storyboard.instantiateViewController(withIdentifier: SegueIdentifier.HomeViewController)
            homeNavVC = UINavigationController(rootViewController: homeVC)
            let menuVC = storyboard.instantiateViewController(withIdentifier: SegueIdentifier.MenuViewController) as! MenuViewController
            slideMenuVC = SlideMenuController(mainViewController: homeNavVC, leftMenuViewController: menuVC)
            //slideMenuVC.modalTransitionStyle = .crossDissolve
           // slideMenuVC.modalPresentationStyle = .overFullScreen
            window.rootViewController = slideMenuVC
        }else {
            UIApplication.shared.applicationIconBadgeNumber = 0
            let loginVC = storyboard.instantiateViewController(withIdentifier: SegueIdentifier.LoginViewController) as! LoginViewController
            loginNavVC = UINavigationController(rootViewController: loginVC)
            window.rootViewController = loginNavVC
        }
    }
    
    func navigateToTicketHistory() {
        homeNavVC.popToRootViewController(animated: true)
        historyVC = storyboard.instantiateViewController(withIdentifier: SegueIdentifier.TicketHistoryViewController) as! TicketHistoryViewController
        self.homeNavVC.pushViewController(historyVC, animated: true)
    }
    
    func logout(){
      
    }
}
