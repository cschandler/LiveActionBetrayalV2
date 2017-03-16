//
//  Action.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/14/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import Foundation
import ReSwift

typealias JSON = [String:String]

enum PeerAction: Action, CustomStringConvertible {
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
    
    func toJSON() -> JSON {
        switch self {
        case .LightsOn, .LightsOff:
            return [
                "action": self.description
            ]
        case .Message(let string):
            return [
                "action": "Message",
                "message": string
            ]
        }
    }
    
    init?(json: JSON) {
        guard let action = json["action"] else { return nil }
        
        switch action {
        case PeerAction.LightsOn.description:
            self = .LightsOn
        case PeerAction.LightsOff.description:
            self = .LightsOff
        case "Message":
            guard let message = json["message"] else { return nil }
            self = .Message(message)
        default:
            return nil
        }
    }
}
