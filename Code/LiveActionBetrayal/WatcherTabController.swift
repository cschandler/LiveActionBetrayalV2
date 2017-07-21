//
//  WatcherTabController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 7/6/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import ReSwift

final class WatcherTabController: UITabBarController {
    
    var traitorPickerPresented = false
    
    func presentTraitorPicker(withCard card: Card) {
        traitorPickerPresented = true
        
        let viewController = TraitorPickerViewController.build(withCard: card)
        
        viewController.completed = { _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        present(viewController, animated: true, completion: nil)
    }
    
}

extension WatcherTabController: WatcherType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = theme.mid
        
        AppStore.shared.subscribe(self)
        
        ConnectionManager.shared.observeAllMessages()
    }
    
}

extension WatcherTabController: StoreSubscriber, TabBarUpdatable, StatusBarUpdatable {
    
    func newState(state: AppState) {
        if let card = state.cardTriggeringHaunt,
            state.hauntTriggered,
            !traitorPickerPresented {
                presentTraitorPicker(withCard: card)
        }
        
        if let currentUserId = ConnectionManager.shared.currentUserID {
            updateMessagesTabBadge(withMessages: state.allMessages, currentUserId: currentUserId)
        }
        
        if let _ = ConnectionManager.shared.currentUserID, case .notAsked = state.cards {
            ConnectionManager.shared.getCards()
        }
        
        updateItemsTabBadge(withState: state)
        updateStatusBar(withState: state)
    }
    
}
