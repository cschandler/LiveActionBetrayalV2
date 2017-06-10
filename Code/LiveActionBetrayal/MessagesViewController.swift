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
        
        AppStore.shared.subscribe(self)
        
        ConnectionManager.shared.getMessages(forPlayer: reciever.id)
            .onSuccess { messages in
                self.messages = messages
            }
            .onFailure { error in
                print(error)
            }
            .call()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        AppStore.shared.unsubscribe(self)
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
        return JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        guard let text = text, let displayName = senderDisplayName, let senderId = senderId else {
            return
        }
        
        let message = Message(senderId: senderId, displayName: displayName, text: text)
        
        ConnectionManager.shared.send(message: message, toPlayer: reciever.id).call()
        
        inputToolbar.contentView.textView.text = ""
    }
    
}

// MARK: - Store Subscriber

extension MessagesViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        messages = state.messages
    }
    
}

struct Messanger {

    let id: String
    let displayName: String
    
    private let avatar: UIImage
    
    var jsqAvatar: JSQMessagesAvatarImage {
        return JSQMessagesAvatarImageFactory.avatarImage(with: avatar, diameter: UInt(22))
    }

    init(id: String, displayName: String, avatar: UIImage) {
        self.id = id
        self.displayName = displayName
        self.avatar = avatar
    }
}

struct Message {
    
    let senderId: String
    let displayName: String
    let text: String
    
    init(senderId: String, displayName: String, text: String) {
        self.senderId = senderId
        self.displayName = displayName
        self.text = text
    }
    
    init?(json: JSON) {
        guard let text = json["text"] as? String,
            let displayName = json["displayName"] as? String,
            let senderId = json["senderId"] as? String else {
                return nil
        }
        
        self.senderId = senderId
        self.displayName = displayName
        self.text = text
    }
    
    func toJSON() -> JSON {
        let values: JSON = [
            "senderId": senderId as NSString,
            "displayName": displayName as NSString,
            "text": text as NSString
        ]
        
        return values
    }
    
    var jsqMessage: JSQMessage {
        return JSQMessage(senderId: senderId, displayName: displayName, text: text)
    }
    
}
