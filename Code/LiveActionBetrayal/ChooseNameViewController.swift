//
//  ChooseNameViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/22/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import PinkyPromise

final class ChooseNameViewController: BaseViewController {
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var nameEntry: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    
    func validateName(name: String?) -> Result<Void> {
        guard let name = name, !name.isEmpty else {
            return .failure(ValidationFailure.empty)
        }
        
        guard name != "watcher" else {
            return .failure(ValidationFailure.watcher)
        }
        
        guard name.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil else {
            return .failure(ValidationFailure.invalidCharacter)
        }
        
        for player in AppStore.shared.state.gameState.connectedPlayers {
            if player.name == name {
                return .failure(ValidationFailure.taken)
            }
        }
        
        return .success(())
    }
    
    enum ValidationFailure: Error {
        case empty
        case watcher
        case invalidCharacter
        case taken
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == IDs.Segues.NameToAttributes.rawValue,
            let destination = segue.destination as? ChooseAttributeViewController,
            let name = nameEntry.text else {
            return
        }

        let metadata = PlayerMetadata(name: name)
        destination.metadata = metadata
    }
    
}

extension ChooseNameViewController: MainMenuType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Name"
        
        setupView()
        blurView.layer.cornerRadius = 4.0
        blurView.layer.borderWidth = 1.0
        blurView.layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        nameEntry.becomeFirstResponder()
    }

}

extension ChooseNameViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let result = validateName(name: textField.text)
        
        switch result {
        case .success():
            textField.resignFirstResponder()
            performSegue(withIdentifier: IDs.Segues.NameToAttributes.rawValue, sender: nil)
            nameEntry.backgroundColor = .clear
            
            return true
            
        case .failure(let error as ValidationFailure):
            switch error {
            case .empty:
                warningLabel.text = "Name cannot be empty."
            case .watcher:
                warningLabel.text = "Your fate is not to be the watcher this night."
            case .invalidCharacter:
                warningLabel.text = "Names cannot contain spaces or special characters."
            case .taken:
                warningLabel.text = "That name is already taken."
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.nameEntry.backgroundColor = .red
                self.nameEntry.text = ""
                self.nameEntry.placeholder = "Please choose another."
                self.warningLabel.alpha = 1.0
            })
            
            return false
            
        case .failure(_):
            fatalError()
        }
    }
    
}
