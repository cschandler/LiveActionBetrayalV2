//
//  ProfileViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/26/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import ReSwift
import FirebaseStorage

final class ProfileViewController: BaseViewController, ProgressUpdatable {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var progressView: UIProgressView!
    
    let brightnessManager = BrightnessManager()
    
    var uploadTask: StorageUploadTask? {
        didSet {
            guard let task = uploadTask else {
                return
            }
            
            updateProgress(forTask: task)
        }
    }
    
    @IBOutlet weak var picture: UIImageView! {
        didSet {
            picture.setBorder()
        }
    }
    
    var metadata: PlayerMetadata? {
        guard let tabBar = tabBarController as? ExplorerTabController,
            let metadata = tabBar.metadata else {
                return nil
        }
        
        return metadata
    }
    
    @IBAction func profilePictureTapped(_ sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate =  self
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = .front
        imagePicker.allowsEditing = true
        imagePicker.cameraFlashMode = .off
        
        present(imagePicker, animated: true, completion: nil)
    }
}

extension ProfileViewController: ExplorerType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = metadata?.name ?? "PROFILE"
        
        setupView()
        
        AppStore.shared.subscribe(self)
        
        guard let speedStepper = StatStepper.build(stat: metadata?.attribute?.speed, withTitle: "SPEED"),
            let mightStepper = StatStepper.build(stat: metadata?.attribute?.might, withTitle: "MIGHT"),
            let sanityStepper = StatStepper.build(stat: metadata?.attribute?.sanity, withTitle: "SANITY"),
            let knowledgeStepper = StatStepper.build(stat: metadata?.attribute?.knowledge, withTitle: "KNOWLEDGE") else {
                return
        }
        
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        stackView.addArrangedSubview(speedStepper)
        stackView.addArrangedSubview(mightStepper)
        stackView.addArrangedSubview(sanityStepper)
        stackView.addArrangedSubview(knowledgeStepper)
        
        if let image = metadata?.picture {
            picture.image = image
        }
    }

}

extension ProfileViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        guard let player = ConnectionManager.shared.currentPlayer as? Explorer else {
            return
        }
        
        TorchManager.turn(on: player.torchOn)
        brightnessManager.adjustScreenBrightness(forTorchMode: player.torchOn)
    }
    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
        
        picture.image = image
        
        if let image = image,
            let id = ConnectionManager.shared.currentUserID,
            let currentExplorer = AppStore.shared.state.gameState.getPlayer(withId: id) {
            
                let explorer = Explorer.pictureLens.to(image, currentExplorer)
            
                ConnectionManager.shared.uploadPicture(image: image, withId: id, percentageReporter: { [weak self] uploadTask in
                    self?.uploadTask = uploadTask
                })
                .call(completion: { _ in
                    AppStore.shared.dispatch(GameAction.updated(explorer))
                })
        }
        
        dismiss(animated: true) {
            IdleTimerManager.disableIdleTimerAfterDelay()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true) {
            IdleTimerManager.disableIdleTimerAfterDelay()
        }
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
