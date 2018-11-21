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
    
    // Reciever being nil indicates the messages are meant to all players
    var reciever: Messanger?
    
    fileprivate var messages: Loadable<[Message]> = .notAsked {
        didSet {
            switch messages {
            case .loaded(_):
                loadingIndicator.stopAnimating()
                collectionView.reloadData()
                scrollToBottom(animated: true)
                
            case .error(let error):
                print(error.localizedDescription)
                loadingIndicator.stopAnimating()
                
            case .loading:
                loadingIndicator.startAnimating()
                
            case .notAsked:
                loadingIndicator.stopAnimating()
            }
        }
    }
    
    fileprivate var watcher: Watcher? {
        didSet {
            switch messages {
            case .notAsked:
                guard let reciever = self.reciever else {
                    return
                }
                
                let id = senderIsWatcher ? reciever.id : sender.id
                
                DispatchQueue.main.async {
                    AppStore.shared.dispatch(MessageAction.loadingConversation)
                    ConnectionManager.shared.getConversation(forPlayer: id)
                }
                
            default:
                break
            }
        }
    }
    
    fileprivate var senderIsWatcher: Bool {
        return watcher?.identifier == sender.id
    }
    
    fileprivate var players: [Explorer] = []
    
    fileprivate var loadingIndicator: UIActivityIndicatorView! {
        didSet {
            view.addSubview(loadingIndicator)
            view.bringSubviewToFront(loadingIndicator)
            loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
    }
    
    fileprivate func markReadIfNeeded(messages: [Message]) {
        for message in messages {
            guard let reciever = self.reciever,
                message.read == false,
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
        
        senderId = sender.id
        senderDisplayName = sender.displayName
        
        inputToolbar.contentView.leftBarButtonItem = nil
        inputToolbar.contentView.textView.keyboardAppearance = .dark
        inputToolbar.contentView.textView.autocorrectionType = .yes
        inputToolbar.contentView.backgroundColor = UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1.0)
        
        collectionView.backgroundColor = .darkGray
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        tapGR.delegate = self
        collectionView.addGestureRecognizer(tapGR)
        
        loadingIndicator = UIActivityIndicatorView(style: .whiteLarge)
        
        switch messages {
        case .notAsked, .loading:
            guard let _ = reciever else {
                return
            }
            
            loadingIndicator.startAnimating()
            
        default:
            break
        }
        
        AppStore.shared.subscribe(self)
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
        } else if let messages = messages.value {
            markReadIfNeeded(messages: messages)
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
        
        guard let reciever = self.reciever else {
            return JSQMessagesAvatarImageFactory.avatarImage(with: #imageLiteral(resourceName: "ic-profile"), diameter: UInt(22))
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
        
        if let reciever = self.reciever {
            ConnectionManager.shared.send(message: message, toPlayer: senderIsWatcher ? reciever.id : sender.id)
        } else {
            players.forEach { ConnectionManager.shared.send(message: message, toPlayer: $0.identifier) }
        }
        
        inputToolbar.contentView.textView.text = ""
    }
    
}

// MARK: - Store Subscriber

extension MessagesViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        messages = state.messageState.conversation
        watcher = state.gameState.watcher
        players = state.gameState.connectedPlayers
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

