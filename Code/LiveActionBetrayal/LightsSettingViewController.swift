//
//  LightsSettingViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 5/6/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

final class LightsSettingsViewController: UITableViewController {
    
    @IBOutlet weak var lightsOffTimer: UITextField!
    @IBOutlet weak var lightsOnTimer: UITextField!
    
    @IBAction func doneTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func automaticResetToggled(_ sender: UISwitch) {
        Defaults.shared.automaticLightReset = sender.isOn
    }
    
    @IBAction func tableTapped(_ sender: UITapGestureRecognizer) {
        lightsOnTimer.resignFirstResponder()
        lightsOffTimer.resignFirstResponder()
    }
}

// MARK: - Life Cycle

extension LightsSettingsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "LIGHTS SETTINGS"
    }
    
}

// MARK: - UITextFieldDelegate

extension LightsSettingsViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, let time = Double(text) else {
            return
        }
        
        if textField == lightsOffTimer {
            Defaults.shared.lightsOff = time
        }
        
        if textField == lightsOnTimer {
            Defaults.shared.lightsOn = time
        }
    }
    
}
