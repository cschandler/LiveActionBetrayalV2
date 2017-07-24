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
    @IBOutlet weak var selectedTraitorLabel: VibrantLabel!
    
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
    }
    
}

extension WatcherHauntViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        if state.hauntState.hauntTriggered && startHauntButton.isEnabled {
            startHauntButton.isEnabled = false
        }
        
        if !state.hauntState.hauntName.isEmpty {
            title = state.hauntState.hauntName
        }
        
        if let cards = state.gameState.cards.value {
            omens = cards.filter { $0.type == .omen }
        }
        
        updateHauntInputTextField(withState: state)
        updateSelectedTraitorLabel(withState: state)
    }
    
    func updateHauntInputTextField(withState state: AppState) {
        if state.hauntState.hauntTriggered && !hauntInputVisualEffectView.isHidden {
            hauntInputVisualEffectView.isHidden = true
        }
        
        if !state.hauntState.hauntName.isEmpty && !hauntInputVisualEffectView.isHidden {
            hauntInputTextField.text = "Selected Haunt: \(state.hauntState.hauntName)"
        }
    }
    
    func updateSelectedTraitorLabel(withState state: AppState) {
        if let traitor = state.gameState.getTraitor(), selectedTraitorLabel.isHidden {
            selectedTraitorLabel.text = "Traitor: \(traitor.name)"
            selectedTraitorLabel.setup()
            selectedTraitorLabel.addBorder()
            selectedTraitorLabel.isHidden = false
        } else {
            selectedTraitorLabel.isHidden = true
        }
    }
        
}

extension WatcherHauntViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {
            return true
        }
        
        let filteredText = text.replacingOccurrences(of: "Selected Haunt: ", with: "")
        ConnectionManager.shared.setHaunt(withName: filteredText)
        dismissKeyboard()
        
        return true
    }
    
    func dismissKeyboard() {
        hauntInputTextField.resignFirstResponder()
    }
    
}
