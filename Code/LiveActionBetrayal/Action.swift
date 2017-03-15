//
//  Action.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/14/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import Foundation

enum Action: CustomStringConvertible {
    case LightsOn
    case LightsOff
    case Message(String)
    
    var description: String {
        switch self {
        case .LightsOn:
            return "Lights ON"
        case .LightsOff:
            return "Lights OFF"
        case .Message(let string):
            return "Message: \(string)"
        }
    }
}

struct ActionWrapper {
    let action: Action
}
