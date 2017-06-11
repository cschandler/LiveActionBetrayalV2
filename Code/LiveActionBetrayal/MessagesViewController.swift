//
//  WatcherMessagesViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 5/16/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import ReSwift

final class MessagesViewController: JSQMessagesViewController {
    
    var messages: [Message] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var sender: Messanger!
    var reciever: Messanger!
    
}

// MARK: - Life Cycle

extension MessagesViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        senderId = sender.id
        senderDisplayName = sender.displayName
        
        inputToolbar.contentView.leftBarButtonItem = nil
        inputToolbar.contentView.textView.keyboardAppearance = .dark
        inputToolbar.contentView.textView.autocorrectionType = .no
        inputToolbar.contentView.backgroundColor = UIColor(colorLiteralRed: 0.16, green: 0.16, blue: 0.16, alpha: 1.0)
        
        collectionView.backgroundColor = .darkGray
        
        AppStore.shared.subscribe(self)
        
        ConnectionManager.shared.getMessages(forPlayer: reciever.id)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        AppStore.shared.unsubscribe(self)
        ConnectionManager.shared.resetMessages()
    }
    
}

// MARK: - JSQMessagesCollectionView

extension MessagesViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item].jsqMessage
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return sender.jsqAvatar
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        
        if message.senderId == sender.id {
            return JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
        } else {
            return JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        
        cell.textView?.textColor = message.senderId == sender.id ? .white : .black
        
        return cell
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        guard let text = text, let displayName = senderDisplayName, let senderId = senderId else {
            return
        }
        
        let message = Message(senderId: senderId, displayName: displayName, text: text)
        
        ConnectionManager.shared.send(message: message, toPlayer: reciever.id)
        
        inputToolbar.contentView.textView.text = ""
    }
    
}

// MARK: - Store Subscriber

extension MessagesViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        messages = state.messages
    }
    
}


