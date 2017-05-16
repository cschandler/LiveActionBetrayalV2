//
//  WatcherMessagesViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 5/16/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import JSQMessagesViewController

final class WatcherMessagesViewController: JSQMessagesViewController {
    
    var messages: [JSQMessage] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
}

// MARK: - Life Cycle

extension WatcherMessagesViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        senderId = "watcher"
        senderDisplayName = "Watcher"
        
        let message = JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, text: "This is a test message")
        messages.append(message!)
    }
    
}

// MARK: - JSQMessagesCollectionView

extension WatcherMessagesViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return JSQMessagesAvatarImageFactory.avatarImage(with: #imageLiteral(resourceName: "img-avatar-default"), diameter: UInt(22.0))
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        return JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
}
