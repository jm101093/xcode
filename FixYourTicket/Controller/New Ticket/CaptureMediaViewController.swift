//
//  CaptureMediaViewController.swift
//  FixYourTicket
//
//  Created by Santosh on 16/08/18.
//  Copyright © 2018 Bitcot. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class CaptureMediaViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var previewView: UIView!
    
    let captureSession = AVCaptureSession()
    var currentDevice: AVCaptureDevice?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var stillImageOutput: AVCapturePhotoOutput?
    var createTicketVCRef: CreateNewTicketViewController!

    
    var capturedImage: UIImage!
    var videoOrientation: AVCaptureVideoOrientation! = .portrait
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitials()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //configureSession()
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        observeDeviceOrientationNptification()
        self.navigationController?.isNavigationBarHidden = true
    }

    func loadInitials() {
        configureSession()
    }
    
    func observeDeviceOrientationNptification() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIDeviceOrientationDidChange, object: nil, queue: OperationQueue.main) { (notification) in
            
            self.videoOrientation = AVCaptureVideoOrientation(rawValue: UIDevice.current.orientation.rawValue)
        }
    }
    
    func configureSession() {
        
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        stillImageOutput = AVCapturePhotoOutput()
        
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        
        if let input = try? AVCaptureDeviceInput(device: device!) {
            if (captureSession.canAddInput(input)) {
                captureSession.addInput(input)
                if (captureSession.canAddOutput(stillImageOutput!)) {
                    captureSession.addOutput(stillImageOutput!)
                    cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    cameraPreviewLayer?.frame = previewView.bounds
//                    cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                    previewView.layer.addSublayer(cameraPreviewLayer!)
                    captureSession.startRunning()
                }
            } else {
                print("issue here : captureSesssion.canAddInput")
            }
        } else {
            print("some problem here")
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width = previewView.bounds.width
        let height = previewView.bounds.height
        cameraPreviewLayer?.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
    
    @IBAction func didTapOnClose(_ sender: Any) {
        self.dismiss(animated: true , completion: nil)
    }
    
    @IBAction func didTapOnCapture(_ sender: Any) {
        if captureSession.isRunning {
            capturePhoto()
        } else {
            captureSession.startRunning()
        }
    }
    
    func capturePhoto(){
        
        cameraPreviewLayer?.connection?.videoOrientation = videoOrientation
        let settings = AVCapturePhotoSettings()
        if let videoConnection = stillImageOutput?.connection(with: AVMediaType.video) {
            videoConnection.videoOrientation = videoOrientation
        }

        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [
            kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
            kCVPixelBufferWidthKey as String: 160,
            kCVPixelBufferHeightKey as String: 160

        ]
        settings.previewPhotoFormat = previewFormat
        
    
        self.stillImageOutput?.capturePhoto(with: settings, delegate: self)
        if let videoConnection = stillImageOutput?.connection(with: AVMediaType.video) {
            videoConnection.videoOrientation = .portrait
        }
        cameraPreviewLayer?.connection?.videoOrientation = .portrait
    }
}

extension CaptureMediaViewController: AVCapturePhotoCaptureDelegate {
    
//    @available(iOS 11.0, *)
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        if let error = error {
//            print(error.localizedDescription)
//            return
//        }
//
//        let imageData = photo.fileDataRepresentation()
//        if let image = UIImage(data: imageData!) {
//           navigateToImageVPreview(image: image)
//        }
//    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
        
        if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            navigateToImageVPreview(image: UIImage(data: dataImage)!)
        }
    }
    
    func navigateToImageVPreview(image: UIImage) {
        let previewImageVC = storyboard?.instantiateViewController(withIdentifier: SegueIdentifier.PreviewImageViewController) as! PreviewImageViewController
        previewImageVC.selectedImage = image
        previewImageVC.delegate = createTicketVCRef as! PreViewImageDelegate
        previewImageVC.isFromCustomCamera = true
        self.navigationController?.pushViewController(previewImageVC, animated: true)
    }
}
