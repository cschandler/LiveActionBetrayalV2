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
                
            default:
                break
            }
        }
    }
    
    func getHaunt() {
        guard case .notAsked = hauntText, !AppStore.shared.state.hauntName.isEmpty else {
            return
        }
        
        hauntText = .loading
        
        ConnectionManager.shared.getHaunt(withName: AppStore.shared.state.hauntName)
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
        
        title = "Survivor's Guide"
        
        setupView()
        
        AppStore.shared.subscribe(self)
    }
    
}

extension ExplorerHauntViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        if state.hauntTriggered {
            getHaunt()
        }
    }
    
}
