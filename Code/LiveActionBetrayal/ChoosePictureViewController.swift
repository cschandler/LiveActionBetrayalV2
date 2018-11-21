//
//  ChoosePictureViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/24/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import FirebaseAuth

final class ChoosePictureViewController: BaseViewController {
    
    @IBOutlet weak var picture: UIImageView!
    
    var metadata: PlayerMetadata?
    
    @IBAction func pictureTapped(_ sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate =  self
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = .front
        imagePicker.allowsEditing = true
        imagePicker.cameraFlashMode = .off
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: BlurButton) {
        guard let metadata = metadata else { return }
        
        let transition = TransitionViewController(image: #imageLiteral(resourceName: "img-explorer"),
                                                  storyboardIdentifier: IDs.Storyboards.Explorer.rawValue,
                                                  transitionType: .newGame(metadata))

        present(transition, animated: true) { [weak self] in
            guard let mainMenu = self?.navigationController?.children.first as? MainMenuViewController else {
                return
            }
            
            AppStore.shared.unsubscribe(mainMenu)
        }
    }
    
}

extension ChoosePictureViewController: MainMenuType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Picture"
        
        setupView()
        picture.setBorder()
    }

}

extension ChoosePictureViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
        picture.image = image
        metadata?.picture = image
        
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

extension UIImageView {
    
    func setBorder(withColor color: UIColor = .gray) {
        layer.borderWidth = 4.0
        layer.borderColor = color.cgColor
        layer.cornerRadius = (bounds.width / 2)
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
