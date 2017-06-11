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
    
    var sender: Messanger!
    var reciever: Messanger!
    
    fileprivate var messages: [Message] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    fileprivate var watcher: Watcher? {
        didSet {
            let id = senderIsWatcher ? reciever.id : sender.id
            ConnectionManager.shared.getMessages(forPlayer: id)
            
            if !senderIsWatcher {
                edgesForExtendedLayout = []
            }
        }
    }
    
    private var senderIsWatcher: Bool {
        return watcher?.identifier == sender.id
    }
}

// MARK: - Life Cycle

extension MessagesViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppStore.shared.subscribe(self)
        
        senderId = sender.id
        senderDisplayName = sender.displayName
        
        inputToolbar.contentView.leftBarButtonItem = nil
        inputToolbar.contentView.textView.keyboardAppearance = .dark
        inputToolbar.contentView.textView.autocorrectionType = .no
        inputToolbar.contentView.backgroundColor = UIColor(colorLiteralRed: 0.16, green: 0.16, blue: 0.16, alpha: 1.0)
        
        collectionView.backgroundColor = .darkGray
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
        let message = messages[indexPath.item]
        
        return message.senderId == sender.id ? sender.jsqAvatar : reciever.jsqAvatar
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        
        if message.senderId == sender.id {
            return JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
        } else {
            return JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        
        cell.textView?.textColor = message.senderId == sender.id ? .black : .white
        
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
        watcher = state.watcher
    }
    
}


