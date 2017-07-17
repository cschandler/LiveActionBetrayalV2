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
    
    let name: String
    let text: String
    let type: CardType
    
    var room: String?
    var owner: String?
    
    init?(qr: String, currentOwner: String) {
        let components = qr.components(separatedBy: ";")
        
        guard let type = CardType(rawValue: components[2].lowercased()) else {
            return nil
        }
        
        self.name = components[0]
        self.text = components[1]
        self.type = type
        self.owner = currentOwner
        
        if components.count > 3 {
            self.room = components[3]
        }
    }
    
    init?(json: JSON) {
        guard let name = json["name"] as? String,
            let owner = json["owner"] as? String,
            let text = json["text"] as? String,
            let type = json["type"] as? String,
            let cardType = CardType(rawValue: type) else {
                return nil
        }
        
        self.name = name
        self.owner = owner
        self.text = text
        self.type = cardType
        
        self.room = json["room"] as? String
    }
    
    func toJSON() -> JSON {
        var values: JSON = [
            "name": name as NSString,
            "text": text as NSString,
            "type": type.rawValue as NSString,
            "owner": (owner ?? "") as NSString
        ]
        
        if let room = self.room {
            values["room"] = room as NSString
        }
        
        return values
    }
    
}
