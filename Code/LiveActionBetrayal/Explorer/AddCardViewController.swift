//
//  AddCardViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 5/7/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseAuth

final class AddCardViewController: BaseViewController {
    
    static func build() -> AddCardViewController {
        let viewController = UIStoryboard(name: IDs.Storyboards.Explorer.rawValue, bundle: nil).instantiateViewController(withIdentifier: IDs.StoryboardViewControllers.AddCardViewController.rawValue) as! AddCardViewController
        return viewController
    }
    
    var addCard: ((Card) -> Void)?
    
    var captureSession: AVCaptureSession?
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer? {
        didSet {
            guard let videoPreviewLayer = videoPreviewLayer else { return }
            videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer)
        }
    }
    
    var qrCodeFrameView: UIView? {
        didSet {
            guard let qrCodeFrameView = qrCodeFrameView else { return }
            qrCodeFrameView.layer.borderColor = UIColor.lightGray.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            qrCodeFrameView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
            qrCodeFrameView.widthAnchor.constraint(equalToConstant: 200).isActive = true
            qrCodeFrameView.heightAnchor.constraint(equalToConstant: 200).isActive = true
            qrCodeFrameView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            qrCodeFrameView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
    }
    
    let supportedCodeTypes = [
        AVMetadataObjectTypeUPCECode,
        AVMetadataObjectTypeCode39Code,
        AVMetadataObjectTypeCode39Mod43Code,
        AVMetadataObjectTypeCode93Code,
        AVMetadataObjectTypeCode128Code,
        AVMetadataObjectTypeEAN8Code,
        AVMetadataObjectTypeEAN13Code,
        AVMetadataObjectTypeAztecCode,
        AVMetadataObjectTypePDF417Code,
        AVMetadataObjectTypeQRCode
    ]
    
    func addCardToDatabase(card: Card) {
        ConnectionManager.shared.addCard(card: card)
            .onSuccess { self.addCard?(card) }
            .onFailure { error in print(error) }
            .call()
    }
    
}

extension AddCardViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Card"
        
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            captureSession?.startRunning()
            qrCodeFrameView = UIView()
        } catch {
            print(error)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let session = captureSession, session.isRunning {
            captureSession?.stopRunning()
        }
    }
    
}

extension AddCardViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        guard metadataObjects != nil && metadataObjects.count > 0,
            let qrCodeObject = metadataObjects[0] as? AVMetadataMachineReadableCodeObject,
            supportedCodeTypes.contains(qrCodeObject.type),
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: qrCodeObject),
            let qrString = qrCodeObject.stringValue,
            let uid = FIRAuth.auth()?.currentUser?.uid,
            let card = Card(qr: qrString, currentOwner: uid) else {
                qrCodeFrameView?.frame = CGRect.zero
                return
        }
        
        qrCodeFrameView?.frame = barCodeObject.bounds
        captureSession?.stopRunning()
        addCardToDatabase(card: card)
    }
    
}
