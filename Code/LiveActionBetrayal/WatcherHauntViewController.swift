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
    
    @IBOutlet weak var hauntInputVisualEffectView: UIVisualEffectView! {
        didSet {
            hauntInputVisualEffectView.addBorder()
        }
    }
    
    @IBOutlet weak var hauntInputTextField: UITextField!
    
}

extension WatcherHauntViewController: WatcherType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "No Haunt Selected"
        
        setupView()
        
        AppStore.shared.subscribe(self)
    }
    
}

extension WatcherHauntViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        if state.hauntTriggered && startHauntButton.isEnabled {
            startHauntButton.isEnabled = false
        }
        
        if !state.hauntName.isEmpty {
            title = state.hauntName
        }
    }
    
}

extension WatcherHauntViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {
            return true
        }
        
        ConnectionManager.shared.setHaunt(withName: text)
        hauntInputTextField.resignFirstResponder()
        
        return true
    }
    
}
