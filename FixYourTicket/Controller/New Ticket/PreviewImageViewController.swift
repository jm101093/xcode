//
//  PreviewImageViewController.swift
//  FixYourTicket
//
//  Created by Santosh on 16/08/18.
//  Copyright © 2018 Bitcot. All rights reserved.
//

import UIKit

protocol PreViewImageDelegate: class {
    func didTapOnContinue(selected: UIImage)
    func didTapOnRetake()
}

class PreviewImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var delegate: PreViewImageDelegate? = nil
    var selectedImage: UIImage!
    var isFromCustomCamera = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = selectedImage
        loadNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    func loadNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false 
        self.navigationController?.loadAttributes(navTintColor: .white)
        self.navigationController?.setNavigationTitle(title: Constants.AppTitleName, navigationItem: navigationItem)
        self.navigationController?.addLeftBarButtonImage(leftImage: #imageLiteral(resourceName: "back_icon"), navigationItem: navigationItem)
    }
    
    
    @objc func didTapOnLeftNavigationButton() {
        if isFromCustomCamera {
            self.navigationController?.popViewController(animated: true)
        }else {
            self.dismiss(animated: true, completion: nil)
        }
    }


    @IBAction func didTapOnContinue(_ sender: Any) {
        if let _ = delegate {
            delegate?.didTapOnContinue(selected: selectedImage)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func didTapOnRetake(_ sender: Any) {
        if isFromCustomCamera {
            self.navigationController?.popViewController(animated: true)
        }else {
            if let _ = delegate {
                self.dismiss(animated: true) {
                    self.delegate?.didTapOnRetake()
                }
            }
        }
    }
}
