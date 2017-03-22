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
    
}

extension ChooseNameViewController: MainMenuType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        directions.textColor = theme.light
        nameEntry.backgroundColor = theme.dim
        nameEntry.textColor = theme.dark
    }

}

extension ChooseNameViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if validateName(name: textField.text) {
            resignFirstResponder()
            // segue to next screen
        } else {
            nameEntry.backgroundColor = .red
            directions.textColor = .red
            directions.text = "CHOOSE A NAME:\nThat name is unavailable.  Please choose another."
        }
        
        return true
    }
    
}
