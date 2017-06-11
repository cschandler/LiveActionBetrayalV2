//
//  Messanger.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 6/11/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import JSQMessagesViewController

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
