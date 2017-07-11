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
    
    fileprivate var messages: Loadable<[Message]> = .notAsked {
        didSet {
            print("reloading messages collection view")
            collectionView.reloadData()
            scrollToBottom(animated: true)
        }
    }
    
    fileprivate var watcher: Watcher? {
        didSet {
            switch messages {
            case .notAsked:
                let id = senderIsWatcher ? reciever.id : sender.id
                ConnectionManager.shared.getConversation(forPlayer: id)
                messages = .loading
                
                if !senderIsWatcher {
                    // Display the textField above the tab bar.
                    edgesForExtendedLayout = []
                }
                
            default:
                break
            }
        }
    }
    
    fileprivate var senderIsWatcher: Bool {
        return watcher?.identifier == sender.id
    }
    
    func markReadIfNeeded(messages: [Message]) {
        for message in messages {
            guard message.read == false,
                message.senderId == reciever.id else {
                    continue
            }
            
            ConnectionManager.shared.markRead(message: message, forPlayer: senderIsWatcher ? reciever.id : sender.id)
        }
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
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        tapGR.delegate = self
        collectionView.addGestureRecognizer(tapGR)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let messages = messages.value {
            markReadIfNeeded(messages: messages)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if senderIsWatcher {
            AppStore.shared.unsubscribe(self)
            ConnectionManager.shared.resetMessages()
        }
    }
    
}

// MARK: - JSQMessagesCollectionView

extension MessagesViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.value?.count ?? 0
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages.value?[indexPath.item].jsqMessage
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        guard let message = messages.value?[indexPath.item] else {
            return nil
        }
        
        return message.senderId == sender.id ? sender.jsqAvatar : reciever.jsqAvatar
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        guard let message = messages.value?[indexPath.item] else {
            return nil
        }
        
        if message.senderId == sender.id {
            return JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
        } else {
            return JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        guard let message = messages.value?[indexPath.item] else {
            return UICollectionViewCell()
        }
        
        cell.textView?.textColor = message.senderId == sender.id ? .black : .white
        
        return cell
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        guard let text = text, let displayName = senderDisplayName, let senderId = senderId else {
            return
        }
        
        let message = Message(senderId: senderId, displayName: displayName, text: text)
        
        ConnectionManager.shared.send(message: message, toPlayer: senderIsWatcher ? reciever.id : sender.id)
        
        inputToolbar.contentView.textView.text = ""
    }
    
}

// MARK: - Store Subscriber

extension MessagesViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        watcher = state.watcher
        messages = .loaded(state.conversation)
    }
    
}

// MARK: - UIGestureRecognizerDelegate

extension MessagesViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc
    fileprivate func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        inputToolbar.contentView.textView.resignFirstResponder()
    }
    
}

protocol TabBarUpdatable: class {}

extension TabBarUpdatable where Self: UITabBarController {
    
    func updateTabBadge(withMessages messages: [Message], currentUserId: String) {
        guard let messagesTab = tabBar.items?[2] else {
            return
        }
        
        let unread = messages.filter { $0.read == false && $0.senderId != currentUserId }
        
        messagesTab.badgeValue = unread.count > 0 ? "\(unread.count)" : nil
    }
    
}

