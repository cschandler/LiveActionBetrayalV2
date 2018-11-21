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
            videoPreviewLayer.videoGravity = AVLayerVideoGravity(rawValue: convertFromAVLayerVideoGravity(AVLayerVideoGravity.resizeAspectFill))
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
            view.bringSubviewToFront(qrCodeFrameView)
            qrCodeFrameView.widthAnchor.constraint(equalToConstant: 200).isActive = true
            qrCodeFrameView.heightAnchor.constraint(equalToConstant: 200).isActive = true
            qrCodeFrameView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            qrCodeFrameView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
    }
    
    let supportedCodeTypes: [AVMetadataObject.ObjectType] = [
        AVMetadataObject.ObjectType.upce,
        AVMetadataObject.ObjectType.code39,
        AVMetadataObject.ObjectType.code39Mod43,
        AVMetadataObject.ObjectType.code93,
        AVMetadataObject.ObjectType.code128,
        AVMetadataObject.ObjectType.ean8,
        AVMetadataObject.ObjectType.ean13,
        AVMetadataObject.ObjectType.aztec,
        AVMetadataObject.ObjectType.pdf417,
        AVMetadataObject.ObjectType.qr
    ]
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // The torch needs to be toggled off and on again in order to turn torch on
        // in the capture session.
        TorchManager.turn(on: false)
        TorchManager.turn(on: true)
        AppStore.shared.dispatch(CardAction.isScanning(true))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        AppStore.shared.dispatch(CardAction.isScanning(false))
    }
    
    func presentQRCodeError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.captureSession?.startRunning()
        }))
        
        present(alert, animated: true)
    }
    
}

extension AddCardViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Card"
        
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.video))) else {
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession = AVCaptureSession()
            
            guard let captureSession = captureSession else {
                return
            }
            
            captureSession.addInput(input)
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            captureSession.startRunning()
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
    
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession?.stopRunning()
        
        guard metadataObjects.count > 0,
            let qrCodeObject = metadataObjects[0] as? AVMetadataMachineReadableCodeObject,
            supportedCodeTypes.contains(qrCodeObject.type),
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: qrCodeObject),
            let qrString = qrCodeObject.stringValue else {
                presentQRCodeError(message: "This is not a LiveActionBetrayal object")
                return
        }
        
        qrCodeFrameView?.frame = barCodeObject.bounds
        
        switch AppStore.shared.state.cardState.cards {
        case .loaded(let cards):
            guard let card = cards.first(where: { $0.name == qrString }) else {
                presentQRCodeError(message: "Does not match any card in the database.")
                return
            }
            
            // dismisses the view controller
            ConnectionManager.shared.foundCard(card: card)
                .onSuccess {
                    self.addCard?(card)
                }
                .onFailure { error in
                    self.presentQRCodeError(message: error.localizedDescription)
                }
                .call()
            
        case .notAsked, .loading:
            presentQRCodeError(message: "Waiting to fetch cards from database.")
            
        case .error(let error):
            presentQRCodeError(message: error.localizedDescription)
        }
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVLayerVideoGravity(_ input: AVLayerVideoGravity) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVMetadataObjectObjectType(_ input: AVMetadataObject.ObjectType) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVMediaType(_ input: AVMediaType) -> String {
	return input.rawValue
}
