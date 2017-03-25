//
//  ChooseNameViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/22/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import Spruce

final class ChooseNameViewController: BaseViewController {
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var nameEntry: UITextField!
    
    func validateName(name: String?) -> Bool {
        guard let name = name else { return false }
        
        guard name.lowercased() != "watcher" else { return false }
        
        for peer in ConnectionStore.shared.state.connectedPeers {
            if peer.name == name {
                return false
            }
        }
        
        return true
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
        
        title = "NAME"
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
        if validateName(name: textField.text) {
            textField.resignFirstResponder()
            performSegue(withIdentifier: IDs.Segues.NameToAttributes.rawValue, sender: nil)
            nameEntry.backgroundColor = .clear
            return true
        } else {
            UIView.animate(withDuration: 0.3, animations: { 
                self.nameEntry.backgroundColor = .red
                self.nameEntry.text = ""
                self.nameEntry.placeholder = "Please choose another."
            })
            return false
        }
    }
    
}
