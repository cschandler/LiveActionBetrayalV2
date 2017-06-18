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
    let room: String
    
    var owner: String?
    
    init?(qr: String, currentOwner: String) {
        let components = qr.components(separatedBy: ";")
        
        guard components.count == 4, let type = CardType(rawValue: components[2].lowercased()) else {
            print("QR did con contain the correct amount of components")
            return nil
        }
        
        self.name = components[0]
        self.text = components[1]
        self.type = type
        self.room = components[3]
        self.owner = currentOwner
    }
    
    init?(json: JSON) {
        guard let name = json["name"] as? String,
            let owner = json["owner"] as? String,
            let room = json["room"] as? String,
            let text = json["text"] as? String,
            let type = json["type"] as? String,
            let cardType = CardType(rawValue: type) else {
                return nil
        }
        
        self.name = name
        self.owner = owner
        self.room = room
        self.text = text
        self.type = cardType
    }
    
    func toJSON() -> JSON {
        let values: JSON = [
            "name": name as NSString,
            "text": text as NSString,
            "type": type.rawValue as NSString,
            "room": room as NSString,
            "owner": (owner ?? "") as NSString
        ]
        
        return values
    }
    
}
