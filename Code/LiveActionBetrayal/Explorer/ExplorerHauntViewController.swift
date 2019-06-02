//
//  ExplorerHauntViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 7/6/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import ReSwift

final class ExplorerHauntViewController: BaseViewController {
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var descriptionVisualEffectView: UIVisualEffectView! {
        didSet {
            descriptionVisualEffectView.addBorder()
        }
    }
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var hauntText: Loadable<String> = .notAsked {
        didSet {
            switch hauntText {
            case .loaded(let text):
                descriptionTextView.text = text
                activityIndicator.stopAnimating()
                
            case .loading:
                activityIndicator.startAnimating()
                
            case .error(let error):
                descriptionTextView.text = error.localizedDescription
                activityIndicator.stopAnimating()
                
            case .notAsked:
                break
            }
        }
    }
    
    func getHaunt() {
        guard case .notAsked = hauntText, !AppStore.shared.state.hauntState.hauntName.isEmpty else {
            return
        }
        
        hauntText = .loading
        
        ConnectionManager.shared.getHaunt(withName: AppStore.shared.state.hauntState.hauntName)
            .onSuccess { text in
                self.hauntText = .loaded(text)
            }
            .onFailure { error in
                self.hauntText = .error(error)
            }
            .call()
    }
    
}

extension ExplorerHauntViewController: ExplorerType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Survivor's Guide"
        
        setupView()
        
        AppStore.shared.subscribe(self)
    }
    
}

extension ExplorerHauntViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        if state.hauntState.hauntStarted {
            getHaunt()
            tabBarItem.title = "Haunt"
        }
        
        if let traitor = state.gameState.getTraitor(),
            let currentId = ConnectionManager.shared.currentUserID,
            traitor.identifier == currentId {
                navigationItem.title = "Traitor's Tome"
        }
    }
    
}
