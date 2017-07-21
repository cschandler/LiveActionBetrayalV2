//
//  TabBarUpdatable.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 7/13/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

protocol TabBarUpdatable: class {}

extension TabBarUpdatable where Self: UITabBarController {
    
    func updateItemsTabBadge(withState state: AppState) {
        guard let itemsTab = tabBar.items?[1] else {
            return
        }
        
        guard !state.hauntTriggered, let cards = state.cards.value else {
            itemsTab.badgeValue = nil
            return
        }
        
        let omens = cards.filter({ $0.type == .omen })
        
        itemsTab.badgeValue = omens.count > 0 ? "\(omens.count)" : nil
    }
    
    func updateMessagesTabBadge(withMessages messages: [Message], currentUserId: String) {
        guard let messagesTab = tabBar.items?[2] else {
            return
        }
        
        let unread = messages.filter { $0.read == false && $0.senderId != currentUserId }
        
        messagesTab.badgeValue = unread.count > 0 ? "\(unread.count)" : nil
    }
    
}
