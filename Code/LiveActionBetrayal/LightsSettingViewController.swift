//
//  LightsSettingViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 5/6/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

final class LightsSettingsViewController: UITableViewController {
    
    @IBAction func doneTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Life Cycle

extension LightsSettingsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "LIGHTS SETTINGS"
    }
    
}
