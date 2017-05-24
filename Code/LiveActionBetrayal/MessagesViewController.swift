//
//  WatcherMessagesViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 5/16/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import JSQMessagesViewController

final class MessagesViewController: JSQMessagesViewController {
    
    var messages: [JSQMessage] = [] {
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
    }
    
}

// MARK: - JSQMessagesCollectionView

extension MessagesViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return sender.jsqAvatar
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        return JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        print(text)
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
    
    let text: String
    let senderId: String
    
    init?(json: JSON) {
        guard let text = json["text"] as? String,
            let senderId = json["senderId"] as? String else {
                return nil
        }
        
        self.text = text
        self.senderId = senderId
    }
    
    func toJSON() -> JSON {
        let values: JSON = [
            "text": text as NSString,
            "senderId": senderId as NSString
        ]
        
        return values
    }
    
}
