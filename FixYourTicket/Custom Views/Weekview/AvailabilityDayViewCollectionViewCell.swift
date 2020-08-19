//
//  AvailabilityDayViewCollectionViewCell.swift
//  
//
//  Created by sahil jain on 5/23/17.
//  Copyright © 2017 sahil jain. All rights reserved.
//

import UIKit

class AvailabilityDayViewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func enableSelectedView(){
        selectedView.backgroundColor = AppPallette.skyblueColor
    }
    
    func disableSelectedView(){
        selectedView.backgroundColor = UIColor.clear
    }
    
}
