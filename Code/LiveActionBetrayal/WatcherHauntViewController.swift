//
//  WatcherHauntViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 7/6/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import ReSwift

final class WatcherHauntViewController: BaseViewController {
    
    @IBOutlet weak var startHauntButton: BlurButton! {
        didSet {
            startHauntButton.setTitle("HAUNT HAS BEGUN!", for: .disabled)
        }
    }
    
    @IBAction func startHauntButtonTapped(_ sender: BlurButton) {
        HauntController.triggerHaunt()
    }
    
}

extension WatcherHauntViewController: WatcherType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        AppStore.shared.subscribe(self)
    }
    
}

extension WatcherHauntViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        if state.hauntTriggered && startHauntButton.isEnabled {
            startHauntButton.isEnabled = false
        }
    }
    
}
