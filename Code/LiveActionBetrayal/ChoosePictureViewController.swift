//
//  ChoosePictureViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/24/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

final class ChoosePictureViewController: BaseViewController {
    
    @IBOutlet weak var picture: UIImageView!
    
    var metadata: PlayerMetadata?
    
    @IBAction func pictureTapped(_ sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate =  self
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = .front
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == IDs.Segues.PictureToExplorer.rawValue,
            let destination = segue.destination as? UIViewController else {
            return
        }
        
        // TODO: Pass metadata
    }
}

extension ChoosePictureViewController: MainMenuType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "PICTURE"
        
        setupView()
        picture.layer.borderWidth = 4.0
        picture.layer.borderColor = UIColor.gray.cgColor
        picture.layer.cornerRadius = (picture.bounds.width / 2)
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
