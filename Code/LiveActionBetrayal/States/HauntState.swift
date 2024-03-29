//
//  HauntState.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 7/24/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import Foundation
import ReSwift

enum HauntAction: Action {
    case triggerHaunt
    case triggerHauntWithCard(Card?)
    case hauntName(String)
}

struct HauntState: StateType {
    var hauntTriggered = false
    var hauntName = ""
    var cardTriggeringHaunt: Card?
    var hauntStarted = false
}

struct HauntReducer {
    
    static func hauntReducer(action: Action, state: HauntState?) -> HauntState {
        var newState = state ?? HauntState()
        
        guard let action = action as? HauntAction else {
            return newState
        }
        
        switch action {
        case .triggerHaunt:
            newState.hauntTriggered = true
            
        case .triggerHauntWithCard(let card):
            newState.cardTriggeringHaunt = card
            newState.hauntTriggered = true
            
        case .hauntName(let name):
            newState.hauntName = name
        }
        
        if newState.hauntStarted == false
            && newState.hauntTriggered == true
            && !newState.hauntName.isEmpty {
                newState.hauntStarted = true
        }
        
        return newState
    }
    
}
