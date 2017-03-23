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
        
        if let destination = segue.destination as? UIViewController {
            print("pass the name")
        }
        
        super.prepare(for: segue, sender: sender)
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
            nameEntry.backgroundColor = .red
            directions.textColor = .red
            directions.text = "CHOOSE A NAME:\nThat name is unavailable.  Please choose another."
            return false
        }
    }
    
}
