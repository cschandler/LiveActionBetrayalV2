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
            
            if let watcher = AppStore.shared.state.watcher {
                messagesViewController.reciever = Messanger(id: watcher.identifier, displayName: "Watcher", avatar: #imageLiteral(resourceName: "ic-avatar-default"))
            }
            
            ConnectionManager.shared.getConversation(forPlayer: currentUserID)
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

extension ExplorerTabController: StoreSubscriber, TabBarUpdatable {
    
    func newState(state: AppState) {
        if state.hauntTriggered {
            activateHauntTab()
        }
        
        if let currentUserId = ConnectionManager.shared.currentUserID {
            updateMessagesTabBadge(withMessages: state.conversation, currentUserId: currentUserId)
        }
    }
    
}

