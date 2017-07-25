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
    
    @IBOutlet weak var selectedTraitorLabel: VibrantLabel!
    
    var omens: [Card] = []
    
    @IBAction func startHauntButtonTapped(_ sender: BlurButton) {
        let viewController = TraitorPickerViewController.build(withCard: nil)
        
        viewController.completed = { _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        present(viewController, animated: true, completion: nil)
    }
    
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
        if state.hauntState.hauntTriggered && startHauntButton.isEnabled {
            startHauntButton.isEnabled = false
        }
        
        if !state.hauntState.hauntName.isEmpty {
            title = state.hauntState.hauntName
        }
        
        if let cards = state.cardState.cards.value {
            omens = cards.filter { $0.type == .omen }
        }
        
        updateSelectedTraitorLabel(withState: state)
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
    
}
