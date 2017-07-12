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
            guard let mainMenu = self?.navigationController?.childViewControllers.first as? MainMenuViewController else {
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        picture.image = image
        metadata?.picture = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension UIImageView {
    
    func setBorder(withColor color: UIColor = .gray) {
        layer.borderWidth = 4.0
        layer.borderColor = color.cgColor
        layer.cornerRadius = (bounds.width / 2)
    }
    
}
