//
//  ProfileViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/26/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import CircleMenu
import ReSwift
import FirebaseStorage

final class ProfileViewController: BaseViewController, ProgressUpdatable {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var diceBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var progressView: UIProgressView!
    
    let brightnessManager = BrightnessManager()
    
    var uploadTask: FIRStorageUploadTask? {
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
    
    @IBAction func diceButtonTapped(_ sender: UIBarButtonItem) {
        let nav = DiceViewController.build()
        
        if let vc = nav.topViewController as? DiceViewController {
            vc.delegate = self
            
            vc.completed = { [weak self] _ in
                self?.dismiss(animated: true)
            }
        }
        
        present(nav, animated: false, completion: nil)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Defaults.shared.lastRoll != 0 {
            diceBarButtonItem.title = "Roll: \(Defaults.shared.lastRoll)"
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

extension ProfileViewController: DiceDelegate {
    
    func didRoll(withResult result: Int) {
        diceBarButtonItem.title = "Roll: \(result)"
    }
    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
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
