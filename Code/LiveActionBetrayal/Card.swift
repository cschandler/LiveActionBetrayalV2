//
//  Card.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 5/7/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

enum CardType: String {
    case event
    case omen
    case item
}

struct Card {
    
    let id: String
    let name: String
    let text: String
    let type: CardType
    
    var room: String?
    var owner: String?
    
    init?(key: String, json: JSON) {
        self.id = key
        
        guard let name = json["name"] as? String,
            let text = json["text"] as? String,
            let type = json["type"] as? String,
            let cardType = CardType(rawValue: type) else {
                return nil
        }
        
        self.name = name
        self.text = text
        self.type = cardType
        self.owner = json["owner"] as? String
        self.room = json["room"] as? String
    }
    
    func toJSON() -> JSON {
        var values: JSON = [
            "name": name as NSString,
            "text": text as NSString,
            "type": type.rawValue as NSString
        ]
        
        if let owner = self.owner {
            values["owner"] = owner as NSString
        }
        
        if let room = self.room {
            values["room"] = room as NSString
        }
        
        return values
    }
    
}
