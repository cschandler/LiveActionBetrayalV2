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
    
    var timestamp: Date
    var read = false
    var autoId: String?
    
    init(senderId: String, displayName: String, text: String) {
        self.senderId = senderId
        self.displayName = displayName
        self.text = text
        self.timestamp = Date()
    }
    
    init?(json: JSON, autoId: String? = nil) {
        guard let text = json["text"] as? String,
            let displayName = json["displayName"] as? String,
            let senderId = json["senderId"] as? String,
            let timestamp = json["timestamp"] as? TimeInterval,
            let read = json["readStatus"] as? Bool else {
                return nil
        }
        
        self.senderId = senderId
        self.displayName = displayName
        self.text = text
        self.timestamp = Date(timeIntervalSince1970: timestamp / 1000)
        self.read = read
        self.autoId = autoId
    }
    
    func toJSON() -> JSON {
        let values: JSON = [
            "senderId": senderId as NSString,
            "displayName": displayName as NSString,
            "text": text as NSString,
            "timestamp": timestamp.timeIntervalSince1970 as NSNumber,
            "readStatus": read as NSNumber
        ]
        
        return values
    }
    
    var jsqMessage: JSQMessage {
        return JSQMessage(senderId: senderId, displayName: displayName, text: text)
    }
    
}
