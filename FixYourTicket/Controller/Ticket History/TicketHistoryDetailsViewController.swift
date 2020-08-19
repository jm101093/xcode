//
//  TicketHistoryDetailsViewController.swift
//  FixYourTicket
//
//  Created by Santosh on 17/08/18.
//  Copyright © 2018 Bitcot. All rights reserved.
//

import UIKit

class TicketHistoryDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var thumbNail: UIImageView!
    
}

class TicketHistoryDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var loggedInUser = LoggedInUser.sharedInstance
    var apiWrapper = AlamofireAPIWrapper.sharedInstance
    
    var titleLabes: [TicketHistoryLabel] = [.status, .statusdetail, .citation, .createdAt, .address, .incident, .license, .ticket, .document, .confirmation, .confirmation2,.trafficSchool]
    var ticket: Ticket!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitials()
        loadNavigationBar()
        if ticket.isUpdated {
            updateBade()
        }
        // Do any additional setup after loading the view.
    }
    
    func loadInitials() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func loadNavigationBar() {
        self.navigationController?.loadAttributes(navTintColor: .white)
        self.navigationController?.setNavigationTitle(title: "FIX YOUR TICKET", navigationItem: navigationItem)
        self.navigationController?.addLeftBarButtonImage(leftImage: #imageLiteral(resourceName: "back_icon"), navigationItem: navigationItem)
    }
    
    func updateBade() {
        if !ReachabilityManager.sharedInstance.isReachable() {
            return
        }
        
        showProgress(message: nil)
        let requestDict: JSONDictionary = ["uid": loggedInUser.userID! as AnyObject, "read_badges": "1" as AnyObject, "method": "remove_badges" as AnyObject, "tid": ticket.ticket_id as AnyObject, "access_token": loggedInUser.authToken as AnyObject]
        apiWrapper.updateBadge(request: requestDict) { (response) in
            if response.isSuccessful {
                if let responseDict = response.responseObject as? JSONDictionary {
                    if ((responseDict["result"] as? JSONArray) != nil) {
                        self.resetBadgeCount()

                    }else {
                        let resutlDict = responseDict["result"] as! JSONDictionary
                        if let badgeCount = resutlDict["remaining_badge_count"] as? Int {
                            if badgeCount <= 0 {
                                self.resetBadgeCount()
                            }
                            UIApplication.shared.applicationIconBadgeNumber = badgeCount
                        }else {
                            self.resetBadgeCount()
                        }
                    }
                }
            }
            self.hideProgress()
        }
    }
    
    func resetBadgeCount() {
        loggedInUser.enableBadgeCount = nil
        loggedInUser.save()
        UIApplication.shared.applicationIconBadgeNumber = 0
        let showHighlight = false
        NotificationCenter.default.post(name: Notification.Name.kButtonHighlationNotification, object: showHighlight)
    }
    
    
    @objc func didTapOnLeftNavigationButton() {
        self.navigationController?.popViewController(animated: true)
    }

}

extension TicketHistoryDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleLabes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TicketHistoryDetailsTableViewCell") as! TicketHistoryDetailsTableViewCell
        cell.selectionStyle = .none
        let option = titleLabes[indexPath.row]
        cell.titleLabel.text = option.title
        switch option {
        case .status:
            cell.subTitle.text = ticket.status
        case .statusdetail:
            cell.subTitle.text = ticket.status_desc
        case .citation:
            cell.subTitle.text = ticket.citationNumber
        case .createdAt:
            cell.subTitle.text = ticket.createdAt.toDateDMY()
        case .address:
            cell.subTitle.text = ticket.address
        case .incident:
            cell.subTitle.text = ticket.incident
        case .license:
            if let imageURL = ticket.licenseimage {
                cell.thumbNail?.setImageWithUrl(imageURL)
            }
        case .ticket:
            if let imageURL = ticket.user_tickets {
                cell.thumbNail?.setImageWithUrl(imageURL)
            }
        case .document:
            if let imageURL = ticket.keydocimage {
                cell.thumbNail?.setImageWithUrl(imageURL)
            }
        case .confirmation:
            if let imageURL = ticket.confirmation_image {
                cell.thumbNail?.setImageWithUrl(imageURL)
            }
        case .trafficSchool:
            cell.subTitle.text = ticket.isPreSchool == true ? "Yes":"No"
        case .confirmation2:
            if let imageURL = ticket.confirmation_image2 {
                cell.thumbNail?.setImageWithUrl(imageURL)
            }
        }
        
        if option == .license || option == .ticket || option == .document || option == .confirmation || option == .confirmation2 {
            cell.thumbNail.isHidden = false
            cell.subTitle.isHidden = true
        }else {
            cell.thumbNail.isHidden = true
            cell.subTitle.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = titleLabes[indexPath.row]
        var imageURL: URL?
        switch option {
        case .license:
            imageURL = ticket.licenseimage
        case .ticket:
            imageURL = ticket.user_tickets
        case .document:
            imageURL = ticket.keydocimage
        case .confirmation:
            imageURL = ticket.confirmation_image
        case .confirmation2:
            imageURL = ticket.confirmation_image2
        default:
            break
        }
        
        if let _ = imageURL {
            let singleImageVC = storyboard?.instantiateViewController(withIdentifier: SegueIdentifier.SingleImageViewController) as! SingleImageViewController
            singleImageVC.imageURL = imageURL!
            self.navigationController?.pushViewController(singleImageVC, animated: true)
        }
    }
}
