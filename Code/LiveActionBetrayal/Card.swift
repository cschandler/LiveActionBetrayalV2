//
//  Card.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 5/7/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

enum CardType {
    case event
    case omen
    case item
}

struct Card {
    
    let identifier: String
    let name: String
    let text: String
    let type: CardType
    
    var owner: String?
    
}
