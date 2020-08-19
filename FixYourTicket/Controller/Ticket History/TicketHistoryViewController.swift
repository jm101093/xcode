//
//  TicketHistoryViewController.swift
//  FixYourTicket
//
//  Created by Santosh on 13/08/18.
//  Copyright © 2018 Bitcot. All rights reserved.
//

import UIKit
import ObjectMapper


class TicketHistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var reuseId: String = "TicketHistoryTableViewCell"
    var tickets = [Ticket]()
    var apiWrapper = AlamofireAPIWrapper.sharedInstance
    var loggedInUser = LoggedInUser.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitials()
        loadNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    func loadInitials() {
        let nib = UINib(nibName: reuseId, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: reuseId)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllTickets()
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
            tickets = Mapper<Ticket>().mapArray(JSONObject: ticketResponse)!
            tableView.reloadData()
            let updatedTickets = tickets.filter({return $0.isUpdated})
            if updatedTickets.count == 0 {
                UIApplication.shared.applicationIconBadgeNumber = 0
                let showHighlight = false
                NotificationCenter.default.post(name: Notification.Name.kButtonHighlationNotification, object: showHighlight)
            }
        }
    }
    
    func loadNavigationBar() {
        self.navigationController?.loadAttributes(navTintColor: .white)
        self.navigationController?.setNavigationTitle(title: "FIX YOUR TICKET", navigationItem: navigationItem)
        self.navigationController?.addLeftBarButtonImage(leftImage: #imageLiteral(resourceName: "back_icon"), navigationItem: navigationItem)
    }
    
    
    @objc func didTapOnLeftNavigationButton() {
        self.navigationController?.popViewController(animated: true)
    }

}

extension TicketHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId) as! TicketHistoryTableViewCell
        cell.selectionStyle = .none
        let ticket = tickets[indexPath.row]
        cell.citationLabel.text = ticket.ticketNumber
        cell.dateLabel.text = ticket.createdAt.toDateDMY()
        cell.statusLabel.text = ticket.status
        if ticket.isUpdated {
            print("bold font")
            cell.boldFont()
        }else {
            cell.regularFont()
        }
        return cell 
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ticket = tickets[indexPath.row]
        let ticketDetailsVC = storyboard?.instantiateViewController(withIdentifier: SegueIdentifier.TicketHistoryDetailsViewController) as! TicketHistoryDetailsViewController
        ticketDetailsVC.ticket = ticket
        self.navigationController?.pushViewController(ticketDetailsVC, animated: true)
    }
}
