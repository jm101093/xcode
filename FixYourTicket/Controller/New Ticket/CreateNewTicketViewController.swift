//
//  CreateNewTicketViewController.swift
//  FixYourTicket
//
//  Created by Santosh on 14/08/18.
//  Copyright © 2018 Bitcot. All rights reserved.
//

import UIKit
import AVFoundation

class CreateNewTicketViewController: UIViewController {

   
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var appData = AppData.sharedInstance
    var createTicket: Ticket {
        get {
            return AppData.sharedInstance.createTicket
        }
    }
    
    var createTicketFlow: CreateTicketFlow {
        get {
            return appData.createTicketFlow
        }
    }
    let imagePicker = UIImagePickerController()
    var selectedImage: UIImage?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitials()
        loadNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    func loadInitials() {
        imagePicker.delegate = self
        loadData()
    }
    
    
    
    
    func loadSequence() {
        if createTicketFlow == .driverLicence {
            createTicket.licenseTicketImage = selectedImage
            updateCounter(doIncrement: true)
            let createTicketVC = storyboard?.instantiateViewController(withIdentifier: SegueIdentifier.CreateNewTicketViewController) as! CreateNewTicketViewController
            self.navigationController?.pushViewController(createTicketVC, animated: true)
        }else if createTicketFlow == .originalCitation {
            createTicket.userTicketImage = selectedImage
            updateCounter(doIncrement: true)
            let createTicketVC = storyboard?.instantiateViewController(withIdentifier: SegueIdentifier.CreateNewTicketViewController) as! CreateNewTicketViewController
            self.navigationController?.pushViewController(createTicketVC, animated: true)
        }else {
            createTicket.keydocTicketImage = selectedImage
            if createTicket.didSelecteAtleastOneTicketImage {
                let enterCitationVC = storyboard?.instantiateViewController(withIdentifier: SegueIdentifier.EnterCitationViewController) as! EnterCitationViewController
                self.navigationController?.pushViewController(enterCitationVC, animated: true)
            }else {
                let apologyVC = storyboard?.instantiateViewController(withIdentifier: SegueIdentifier.OurApologyViewController) as! OurApologyViewController
                self.navigationController?.pushViewController(apologyVC, animated: false)
            }
        }
    }
    
    func loadData() {
        titleLabel.text = createTicketFlow.title
        descLabel.text = createTicketFlow.subTitle
        titleLabel.font = createTicketFlow.titleFont
    }
    
    
    func loadNavigationBar() {
        self.navigationController?.loadAttributes(navTintColor: .white)
        self.navigationController?.setNavigationTitle(title: Constants.AppTitleName, navigationItem: navigationItem)
        self.navigationController?.addLeftBarButtonImage(leftImage: #imageLiteral(resourceName: "back_icon"), navigationItem: navigationItem)
    }
    
    
    @objc func didTapOnLeftNavigationButton() {
        updateCounter(doIncrement: false)
        self.navigationController?.popViewController(animated: true)
    }

    
    func updateCounter(doIncrement: Bool) {
        if doIncrement {
            appData.ticketTrackCounter  += 1
        }else {
            if appData.ticketTrackCounter > 0 {
                appData.ticketTrackCounter -= 1
            }
        }
    }
    
    func showActionSheetForImage() {
        showActionSheetAlert(target: self, message: "Select License image source:", title: nil, buttonTitle1: "Gallery", buttonTitle2: "Camera", buttonTitle3: "Cancel") { (eval) in
            if eval == 1{
                self.showGallery()
            } else if eval == 2 {
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
                    self.dismiss(animated: true, completion: nil)
                    self.checkCameraPermission()
                }
            }
        }
    }
    
    // This function checks for the status of the camera permission
    func checkCameraPermission() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch authStatus {
        case .authorized:
           // showCamera()
            showCustomCamera()
            break
        case .denied, .restricted:
            alertPromptToSettings(target: self, title: "Permission Error", message: Constants.Error.cameraPermissionMsg)
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (cameraGranted: Bool) -> Void in
                if (cameraGranted) {
                    DispatchQueue.main.async {
                        self.checkCameraPermission()
                    }
                } else {
                    // Rejected camera
                    alertPromptToSettings(target: self, title: "Permission Error", message: Constants.Error.cameraPermissionMsg)
                }
            })
            break
        }
    }
    
    func showGallery() {
        self.imagePicker.sourceType = .photoLibrary
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    func showCustomCamera() {
        let captureImageVC = storyboard?.instantiateViewController(withIdentifier: SegueIdentifier.CaptureMediaViewController) as! CaptureMediaViewController
        captureImageVC.createTicketVCRef = self 
        let captureMediaNavVC = UINavigationController(rootViewController: captureImageVC)
        self.present(captureMediaNavVC, animated: true, completion: nil)
    }

    
    @IBAction func didTapOnYes(_ sender: Any) {
        showActionSheetForImage()
    }
    
    @IBAction func didTapOnNo(_ sender: Any) {
        loadSequence()
    }
}

extension CreateNewTicketViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - UIImagePickerControllerDelegate Methods
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let previewImageVC = storyboard?.instantiateViewController(withIdentifier: SegueIdentifier.PreviewImageViewController) as! PreviewImageViewController
        let previewImageNavVC = UINavigationController(rootViewController: previewImageVC)
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            previewImageVC.selectedImage = pickedImage
            previewImageVC.delegate = self
        }
        dismiss(animated: false, completion: nil)
        self.present(previewImageNavVC, animated: false, completion: nil)
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    // MARK: End
}

extension CreateNewTicketViewController: PreViewImageDelegate {
   
    func didTapOnRetake() {
        showGallery()
    }
    
    func didTapOnContinue(selected: UIImage) {
        self.selectedImage = selected
        loadSequence()
    }
}
