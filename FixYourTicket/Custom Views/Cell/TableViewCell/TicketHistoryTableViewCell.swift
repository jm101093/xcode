//
//  TicketHistoryTableViewCell.swift
//  FixYourTicket
//
//  Created by Santosh on 14/08/18.
//  Copyright © 2018 Bitcot. All rights reserved.
//

import UIKit

class TicketHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var citationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func boldFont() {
        citationLabel.font = defaultBoldFont(size: 14)
        dateLabel.font = defaultBoldFont(size: 14)
        statusLabel.font = defaultBoldFont(size: 14)
    }
    
    func regularFont() {
        citationLabel.font = defaultFont(size: 14)
        dateLabel.font = defaultFont(size: 14)
        statusLabel.font = defaultFont(size: 14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
