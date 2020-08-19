//
//  AvailabilityDateView.swift
//  
//
//  Created by sahil jain on 5/23/17.
//  Copyright © 2017 sahil jain. All rights reserved.
//

import UIKit

protocol AvailabilityDateViewProtocol {
    func availabilityDateView(availabilityDateView:AvailabilityDateView, didSelectDate date:Date)
}

class AvailabilityDateView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    enum Mode:String{
        case DayView, WeekView
    }
    
    @IBOutlet weak var forwardButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var view: UIView!
    @IBOutlet weak var backwardButtonWidthConstraint: NSLayoutConstraint!
    
    var delegate:AvailabilityDateViewProtocol? = nil
    var dates = [Date](){
        didSet{
            collectionView.reloadData()
        }
    }
    var mode:Mode = Mode.DayView
    var selectedIndex = 0
    
    // initially counter index is 6, since the last element visible is 6th element
    var forwardCounterIndex = 6
    var backwardCounterIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func loadView(){
        let _ =  Bundle.main.loadNibNamed("AvailabilityDateView", owner: self, options: nil)!.first
        view.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        addSubview(view)
        setup()
    }
    
    func setup(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "AvailabilityDayViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AvailabilityDayViewCollectionViewCell")
    }
    
    func enableDayViewMode(){
        mode = Mode.DayView
        collectionView.reloadData()
    }
    
    func enableWeekViewMode(){
        mode = Mode.WeekView
        collectionView.reloadData()
        forwardButtonWidthConstraint.constant = 0.0
        backwardButtonWidthConstraint.constant = 0.0
    }
    
    @IBAction func didTapOnForwardButton(_ sender: Any) {
        if forwardCounterIndex < dates.count{
            backwardCounterIndex = forwardCounterIndex + 1
            collectionView.scrollToItem(at: IndexPath(item: backwardCounterIndex, section: 0), at: UICollectionViewScrollPosition.left, animated: true)
            forwardCounterIndex = forwardCounterIndex + 7
        }
    }
    
    @IBAction func didTapOnBackwardButton(_ sender: Any) {
        if backwardCounterIndex > 0{
            forwardCounterIndex = backwardCounterIndex - 1
            collectionView.scrollToItem(at: IndexPath(item: forwardCounterIndex, section: 0), at: UICollectionViewScrollPosition.right, animated: true)
            backwardCounterIndex = backwardCounterIndex - 7
        }
    }
    
    
    //MARK:UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvailabilityDayViewCollectionViewCell", for: indexPath) as! AvailabilityDayViewCollectionViewCell
        let date = dates[indexPath.row]
        
        if mode == Mode.DayView{
            cell.dateLabel.text = date.fetchMonthAndDate()
        }else{
            cell.dateLabel.text = ""
        }
        
        cell.dayLabel.text = date.fetchDay()
        
        if indexPath.row == selectedIndex{
            cell.enableSelectedView()
        }else{
            cell.disableSelectedView()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        let date = dates[indexPath.row]
        if let _ = delegate{
            delegate?.availabilityDateView(availabilityDateView: self, didSelectDate: date)
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: collectionView.frame.width/7.0, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0.0
    }


}
