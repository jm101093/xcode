//
//  TimePickerView.swift
//  CalendarSample
//
//  Created by Bitcot Inc on 04/01/17.
//  Copyright © 2017 Bitcot Inc. All rights reserved.
//

import UIKit

protocol TimePickerDelegate:class{
    // +/- hour
    
    func didTimeChange(date:Date)
    // +/- min
    
}

@IBDesignable class TimePickerView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var hourStyleLabel: UILabel!
    @IBOutlet var hourAddButton: UIButton!
    @IBOutlet var minAddButton: UIButton!
    @IBOutlet var hourSubButton: UIButton!
    @IBOutlet var minSubButton: UIButton!
    @IBOutlet weak var amPmButton: UIButton!
    
    var hours = 12
    var min = 0
    var hourStyle:String?
    var temp = 0
    var flag = false
    var delegate:TimePickerDelegate? = nil
    var hS = ""
    var currentDate = Date()
    var presentDate = Date()
    let calendar = Calendar.current

    
    required  init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func loadView(){
        let _ = Bundle.main.loadNibNamed("TimePickerView", owner: self, options: nil)?.first
        view.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        addSubview(view)
        getPresentTime()
    }
    
    
    @IBAction func didTapOnAddHour(_ sender: Any) {
        updateTime(hour: 1, min: nil)
        
        if let _ = delegate{
            delegate?.didTimeChange(date: currentDate)
        }
    }
    
    
    @IBAction func didTapOnSubHour(_ sender: Any) {
        updateTime(hour: -1, min: 0)
        
        if let _ = delegate{
            delegate?.didTimeChange(date: currentDate)
        }
        
    }
    
    @IBAction func didTapOnAddMin(_ sender: Any) {
        updateTime(hour: nil, min: 15)
        if let _ = delegate{
            delegate?.didTimeChange(date: currentDate)
        }
    }
    @IBAction func didTapOnSubMin(_ sender: Any) {
        updateTime(hour: nil, min: -15)
        
        if let _ = delegate{
            delegate?.didTimeChange(date: currentDate)
        }
    }
    
    func getPresentTime(){
        let dateFormatter = DateFormatter()
        let formatString = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: NSLocale.current)
        let hasAMPM = formatString?.contains("a")
        var localMinute = calendar.component(.minute, from: Date())
        localMinute = 15 - (localMinute % 15)
        print(localMinute)
        let min:Int = localMinute
        //updateTime(hour: nil, min: localMinute)
        
        if hasAMPM == true{
            dateFormatter.dateFormat = "hh mm aa"
            hourStyleLabel.isHidden = false
            presentDate = calendar.date(byAdding: .minute, value: min, to: Date())!
            let newDate = dateFormatter.string(from: presentDate)
            hourLabel.text =  newDate.components(separatedBy: " ").first
            print(hourLabel.text!)
            minLabel.text = newDate.components(separatedBy: " ")[1]
            print(minLabel.text!)
            hourStyleLabel.text = newDate.components(separatedBy: " ").last!
            hourStyle = newDate.components(separatedBy: " ").last!
            
        }
        else{
            
            dateFormatter.dateFormat = "HH:mm"
            presentDate = calendar.date(byAdding: .minute, value: min, to: presentDate)!
            let newDate = dateFormatter.string(from: presentDate)
            hourStyleLabel.isHidden = true
            amPmButton.isEnabled = false
            hourLabel.text = newDate.components(separatedBy: ":").first
            minLabel.text = newDate.components(separatedBy: ":").last
            
        }
        currentDate = presentDate
        
        if let _ = delegate{
            delegate?.didTimeChange(date: currentDate)
        }
        presentDate = Date()
        
    }
    
    func updateTime(hour:Int?,min:Int?){
        let dateFormatter = DateFormatter()
        let formatString = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: NSLocale.current)
        let hasAMPM = formatString?.contains("a")
        let calendar =  Calendar.current
        if hasAMPM == true{
            dateFormatter.dateFormat = "hh mm aa"
            hourStyleLabel.isHidden = false
            if let _ = hour{
                currentDate = calendar.date(byAdding: .hour, value: hour!, to: currentDate)!
            }
            if let _ = min{
                currentDate = calendar.date(byAdding: .minute, value: min!, to: currentDate)!
            }
            
            let newDate = dateFormatter.string(from: currentDate)
            hourLabel.text =  newDate.components(separatedBy: " ").first
            minLabel.text = newDate.components(separatedBy: " ")[1]
            hourStyleLabel.text = newDate.components(separatedBy: " ").last!
            
        }
        else{
            
            dateFormatter.dateFormat = "HH:mm"
            amPmButton.isEnabled = false
            if let _ = hour{
                currentDate = calendar.date(byAdding: .hour, value: hour!, to: currentDate)!
            }
            if let _ = min{
                currentDate = calendar.date(byAdding: .minute, value: min!, to: currentDate)!
            }
            let newDate = dateFormatter.string(from: currentDate)
            hourStyleLabel.isHidden = true
            hourLabel.text = newDate.components(separatedBy: ":").first
            minLabel.text = newDate.components(separatedBy: ":").last
        }
        
    }
    
    func getSelectedTime(selectedTime:Date?){
        let dateFormatter = DateFormatter()
        let formatString = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: NSLocale.current)
        let hasAMPM = formatString?.contains("a")
        let calendar = Calendar.current
        if let _ = selectedTime{
          //  var localMinute = calendar.component(.minute, from: selectedTime!)
           // localMinute = 15 - (localMinute % 15)
          //  print(localMinute)
           // let min:Int = localMinute
            //updateTime(hour: nil, min: localMinute)
            presentDate = selectedTime!
            if hasAMPM == true{
                dateFormatter.dateFormat = "hh mm aa"
                hourStyleLabel.isHidden = false
            //    presentDate = calendar.date(byAdding: .minute, value: min, to: selectedTime!)!
                let newDate = dateFormatter.string(from: presentDate)
                hourLabel.text =  newDate.components(separatedBy: " ").first
                print(hourLabel.text!)
                minLabel.text = newDate.components(separatedBy: " ")[1]
                print(minLabel.text!)
                hourStyleLabel.text = newDate.components(separatedBy: " ").last!
                hourStyle = newDate.components(separatedBy: " ").last!
                
            }
            else{
                
                dateFormatter.dateFormat = "HH:mm"
               // presentDate = calendar.date(byAdding: .minute, value: min, to: presentDate)!
                let newDate = dateFormatter.string(from: presentDate)
                hourStyleLabel.isHidden = true
                hourLabel.text = newDate.components(separatedBy: ":").first
                minLabel.text = newDate.components(separatedBy: ":").last
                
            }
            currentDate = presentDate
            
            if let _ = delegate{
                delegate?.didTimeChange(date: currentDate)
            }
            presentDate = Date()
            
        }
        
        
        func convertToDate(h:Int,m:Int,md:String) -> Date{
            let dateFormatter =  DateFormatter()
            dateFormatter.dateFormat = "hh:mm aa"
            let dateStr = "\(h):\(m) \(md)"
            let newDate =  dateFormatter.date(from: dateStr)
            return newDate!
            
        }
    }
    @IBAction func didTapOnAmPm(_ sender: Any) {
        if hourStyle == "AM"{
            hourStyleLabel.text = "PM"
            updateTime(hour: 12, min: nil)
            
        }else{
            hourStyleLabel.text = "AM"
            updateTime(hour: 12, min: nil)
        }
        
        if let _ = delegate{
            delegate?.didTimeChange(date: currentDate)
        }
    }
    
}
