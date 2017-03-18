//
//  Action.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/14/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import Foundation
import ReSwift

typealias JSON = [String:AnyObject]

enum PeerAction: Action, CustomStringConvertible {
    case lightsOn
    case lightsOff
    case message(String)
    
    var description: String {
        switch self {
        case .lightsOn:
            return "Lights ON"
        case .lightsOff:
            return "Lights OFF"
        case .message(let string):
            return "Message: \(string)"
        }
    }
    
    func toJSON() -> JSON {
        switch self {
        case .lightsOn, .lightsOff:
            return [
                "action": self.description as AnyObject
            ]
        case .message(let string):
            return [
                "action": "Message" as AnyObject,
                "message": string as AnyObject
            ]
        }
    }
    
    init?(json: JSON) {
        guard let action = json["action"] as? String else { return nil }
        
        switch action {
        case PeerAction.lightsOn.description:
            self = .lightsOn
        case PeerAction.lightsOff.description:
            self = .lightsOff
        case "Message":
            guard let message = json["message"] as? String else { return nil }
            self = .message(message)
        default:
            return nil
        }
    }
}
