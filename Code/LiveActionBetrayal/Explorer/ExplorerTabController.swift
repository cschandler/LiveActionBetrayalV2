//
//  ExplorerTabController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/26/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import ReSwift

final class ExplorerTabController: UITabBarController {
    
    var metadata: PlayerMetadata?
    var hauntNotificationDisplayed = false
    
    func injectIntoMessagesViewController() {
        for viewController in childViewControllers {
            guard let nav = viewController as? UINavigationController,
                let messagesViewController = nav.topViewController as? MessagesViewController else {
                    continue
            }
            
            guard let currentUserID = ConnectionManager.shared.currentUserID,
                let metadata = metadata else {
                    return
            }
            
            messagesViewController.sender = Messanger(id: currentUserID, displayName: metadata.name, avatar: metadata.picture ?? #imageLiteral(resourceName: "ic-avatar-default"))
            
            if let watcher = AppStore.shared.state.gameState.watcher {
                messagesViewController.reciever = Messanger(id: watcher.identifier, displayName: "Watcher", avatar: #imageLiteral(resourceName: "ic-avatar-default"))
            }
            
            AppStore.shared.dispatch(MessageAction.loadingConversation)
            ConnectionManager.shared.getConversation(forPlayer: currentUserID)
        }
    }
    
    func displayHauntNotification() {
        guard !hauntNotificationDisplayed else {
            return
        }
        
        hauntNotificationDisplayed = true
        
        let alert = UIAlertController(title: "The haunt has begun!", message: "See the now active haunt tab for details.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "GO", style: .default, handler: { _ in
            self.selectedIndex = 3
        }))
        
        present(alert, animated: true) {
            self.activateHauntTab()
        }
    }
    
    func activateHauntTab() {
        guard let lastTab = tabBar.items?.last,
            lastTab.isEnabled == false else {
                return
        }
        
        lastTab.isEnabled = true
    }
    
}

extension ExplorerTabController: ExplorerType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = theme.mid
        
        injectIntoMessagesViewController()
        
        AppStore.shared.subscribe(self)
    }
}

extension ExplorerTabController: StoreSubscriber, TabBarUpdatable, StatusBarUpdatable {
    
    func newState(state: AppState) {
        if state.hauntState.hauntStarted {
            displayHauntNotification()
        }
        
        if let currentUserId = ConnectionManager.shared.currentUserID,
            let conversation = state.messageState.conversation.value {
                updateMessagesTabBadge(withMessages: conversation, currentUserId: currentUserId)
        }
        
        updateStatusBar(withState: state.gameState)
    }
    
}

