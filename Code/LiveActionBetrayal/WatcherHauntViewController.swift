//
//  WatcherHauntViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 7/6/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

final class WatcherHauntViewController: BaseViewController {
    
    @IBAction func startHauntButtonTapped(_ sender: BlurButton) {
        HauntController.triggerHaunt()
    }
    
}

extension WatcherHauntViewController: WatcherType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
}
