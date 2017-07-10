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
    
    @IBOutlet weak var hauntInputVisualEffectView: UIVisualEffectView! {
        didSet {
            hauntInputVisualEffectView.addBorder()
        }
    }
    
    @IBOutlet weak var hauntInputTextField: UITextField!
    
    var omens: [Card] = []
    
    @IBAction func startHauntButtonTapped(_ sender: BlurButton) {
        guard !omens.isEmpty else {
            presentNoOmenError()
            return
        }
        
        HauntController.triggerHaunt()
    }
    
    func presentNoOmenError() {
        let alert = UIAlertController(title: "Error", message: "Cannot trigger the haunt with no Omens.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

extension WatcherHauntViewController: WatcherType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "No Haunt Selected"
        
        setupView()
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGR)
        
        AppStore.shared.subscribe(self)
        
        ConnectionManager.shared.getCards()
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
        
        omens = state.cards.filter { $0.type == .omen }
    }
    
}

extension WatcherHauntViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {
            return true
        }
        
        ConnectionManager.shared.setHaunt(withName: text)
        dismissKeyboard()
        
        return true
    }
    
    func dismissKeyboard() {
        hauntInputTextField.resignFirstResponder()
    }
    
}
