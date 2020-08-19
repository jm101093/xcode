//
//  HomeViewController.swift
//  FixYourTicket
//
//  Created by Santosh on 13/08/18.
//  Copyright © 2018 Bitcot. All rights reserved.
//

import UIKit
import ObjectMapper

class HomeViewController: UIViewController {

    @IBOutlet weak var checkStatusButton: UIButton!
    
    let apiWrapper = AlamofireAPIWrapper.sharedInstance
    let loggedInUser = LoggedInUser.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNavigationBar()
        NotificationCenter.default.addObserver(self, selector: #selector(self.UpdateOnTicket(notification:)), name: Notification.Name.kButtonHighlationNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
        getAllTickets()
        // Do any additional setup after loading the view.

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
        if  UIApplication.shared.applicationIconBadgeNumber > 0 {
            enableTicketUpdate(enable: true)
        }
        
        if APNS.sharedInstance.isNotificationReceived {
            APNS.sharedInstance.processNotificationDetailsOnInitialization(controller: self)
            APNS.sharedInstance.reset()
        }
    }
    
    func getAllTickets() {
        if !ReachabilityManager.sharedInstance.isReachable() {
            showNetworkAlert()
            return
        }
        
        let requestDict: JSONDictionary = ["uid": loggedInUser.userID! as AnyObject, "access_token": loggedInUser.authToken as AnyObject, "method": "list_ticket" as AnyObject, "email": loggedInUser.email! as AnyObject]
        showProgress(message: nil)
        apiWrapper.getAllTickets(request: requestDict) { (response) in
            let (success, result) = self.validateServerResponse(response: response, showErrorAlert: true)
            if success {
                self.loadServerResponse(response: result!)
            }
            self.hideProgress()
        }
    }
    
    func loadServerResponse(response: JSONDictionary) {
        let resultResponse = response["result"] as! JSONDictionary
        if let ticketResponse = resultResponse["tickets"] as? JSONArray {
           var tickets = Mapper<Ticket>().mapArray(JSONObject: ticketResponse)!
           tickets = tickets.filter({return $0.isUpdated})
            if tickets.count == 0 {
                UIApplication.shared.applicationIconBadgeNumber = 0
                enableTicketUpdate(enable: false)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
     //   enableTicketUpdate(enable: false)
    }
    
    func loadNavigationBar() {
        self.navigationController?.loadAttributes(navTintColor: .lightGray)
        self.navigationController?.setNavigationTitle(title: "FIX YOUR TICKET", navigationItem: navigationItem)
        self.navigationController?.addLeftBarButtonImage(leftImage: #imageLiteral(resourceName: "menu"), navigationItem: navigationItem)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    
    @objc func didTapOnLeftNavigationButton() {
        slideMenuController()?.openLeft()
    }
    
    @objc func appMovedToBackground() {
        if  UIApplication.shared.applicationIconBadgeNumber > 0 {
            enableTicketUpdate(enable: true)
        }
    }

    
    @IBAction func didTapOnHow(_ sender: Any) {
        showAlert(target: self, message: "Submit your ticket for a free evaluation. Once we determine that your ticket qualifies for our service, we will email you our retainer agreement fee. The Term “Get it Dismissed” and “or We pay your fine” is NOT a guarantee, warranty, or prediction regarding the results of our representation regarding your citation. Rule 1-400(E) of the Board of Governors, State Bar of California", title: nil, buttonTitle: "OK")
    }
    
    
    @IBAction func didTapOnNewTicket(_ sender: Any) {
        let howToCaptureVC = storyboard?.instantiateViewController(withIdentifier: SegueIdentifier.HowToCaptureTicketViewController) as! HowToCaptureTicketViewController
        AppData.sharedInstance.resetTicket()
        self.navigationController?.pushViewController(howToCaptureVC, animated: true)
    }
    
    @objc func UpdateOnTicket(notification: Notification) {
        let enable = notification.object as? Bool
        if enable != nil && enable! {
            enableTicketUpdate(enable: true)
        }else {
            enableTicketUpdate(enable: false)
        }
    }
    
    func enableTicketUpdate(enable: Bool) {
        if enable {
            checkStatusButton.layer.removeAllAnimations()
            checkStatusButton.backgroundColor = .black
            checkStatusButton.alpha = 1.0
            UIView.animate(withDuration: 1, delay: 0, options: [UIViewAnimationOptions.curveEaseInOut, .autoreverse, .repeat, .allowUserInteraction], animations: {
                self.checkStatusButton.alpha = 0.7
                self.view.layoutIfNeeded()
            }, completion: nil)
        }else {
            checkStatusButton.backgroundColor = AppPallette.appBlueColor
            checkStatusButton.layer.removeAllAnimations()
            checkStatusButton.alpha = 1
        }
    }
    
    @IBAction func didTapOnCheckStatus(_ sender: Any) {
        let ticketHistoryVC = storyboard?.instantiateViewController(withIdentifier: SegueIdentifier.TicketHistoryViewController) as! TicketHistoryViewController
        self.navigationController?.pushViewController(ticketHistoryVC, animated: true)
    }
}

extension HomeViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

