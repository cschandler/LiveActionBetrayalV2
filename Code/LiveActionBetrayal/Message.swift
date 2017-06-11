//
//  Message.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 6/11/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import JSQMessagesViewController

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
