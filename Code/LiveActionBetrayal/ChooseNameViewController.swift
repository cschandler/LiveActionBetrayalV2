//
//  ChooseNameViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/22/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

final class ChooseNameViewController: BaseViewController {
    
    @IBOutlet weak var directions: UILabel!
    @IBOutlet weak var nameEntry: UITextField!
    
    func validateName(name: String?) -> Bool {
        guard let name = name else { return false }
        
        guard name != "watcher" else { return false }
        
        for peer in ConnectionStore.shared.state.connectedPeers {
            if peer.name == name {
                return false
            }
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == IDs.Segue.NameToAttributes.rawValue,
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
        
        setupView()
        directions.textColor = theme.light
        nameEntry.backgroundColor = theme.light
        nameEntry.textColor = theme.dark
    }

}

extension ChooseNameViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if validateName(name: textField.text) {
            textField.resignFirstResponder()
            performSegue(withIdentifier: IDs.Segue.NameToAttributes.rawValue, sender: nil)
            return true
        } else {
            UIView.animate(withDuration: 0.3, animations: { 
                self.nameEntry.backgroundColor = .red
                self.directions.textColor = .red
                self.directions.text = "CHOOSE A NAME:\nThat name is unavailable.  Please choose another."
            })
            return false
        }
    }
    
}
