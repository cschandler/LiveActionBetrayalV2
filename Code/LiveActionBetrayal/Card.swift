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
    
    let identifier: String
    let name: String
    let text: String
    let type: CardType
    let room: String
    
    var owner: String?
    
    init?(qr: String, currentOwner: String) {
        let components = qr.components(separatedBy: ";")
        
        guard components.count == 5, let type = CardType(rawValue: components[3]) else {
            print("QR did con contain the correct amount of components")
            return nil
        }
        
        self.identifier = components[0]
        self.name = components[1]
        self.text = components[2]
        self.type = type
        self.room = components[4]
        self.owner = currentOwner
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
