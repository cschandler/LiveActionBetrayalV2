//
//  ExplorerTabController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/26/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

final class ExplorerTabController: UITabBarController {
    
    var metadata: PlayerMetadata?
    
    func injectIntoMessagesViewController() {
        for viewController in childViewControllers {
            guard let nav = viewController as? UINavigationController,
                let messagesViewController = nav.topViewController as? MessagesViewController,
                let currentUserID = ConnectionManager.shared.currentUserID,
                let metadata = metadata,
                let watcher = AppStore.shared.state.watcher else {
                    continue
            }
            
            messagesViewController.sender = Messanger(id: currentUserID, displayName: metadata.name, avatar: #imageLiteral(resourceName: "ic-avatar-default"))
            messagesViewController.reciever = Messanger(id: watcher.identifier, displayName: "Watcher", avatar: #imageLiteral(resourceName: "ic-avatar-default"))
        }
    }
    
}

extension ExplorerTabController: ExplorerType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = theme.mid
        
        injectIntoMessagesViewController()
    }
}

