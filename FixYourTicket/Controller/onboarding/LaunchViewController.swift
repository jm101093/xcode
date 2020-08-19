//
//  LaunchViewController.swift
//  FixYourTicket
//
//  Created by Santosh on 09/08/18.
//  Copyright © 2018 Bitcot. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBOutlet weak var subtitleLabel: UILabel!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let _ = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { (timer) in
            AppSession.sharedInstance.loadHomeVC()
        }
        // scheduleLocalNotification
       // self.scheduleLocalNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

