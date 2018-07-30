//
//  CardState.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 7/24/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import Foundation
import ReSwift

enum CardAction: Action {
    case loadingCards
    case cards([Card])
    case isScanning(Bool)
}

struct CardState: StateType {
    var cards: Loadable<[Card]> = .notAsked
    var isScanning = false
}

struct CardReducer {
    
    func cardReducer(action: Action, state: CardState?) -> CardState {
        var newState = state ?? CardState()
        
        guard let action = action as? CardAction else {
            return newState
        }
        
        switch action {
        case .loadingCards:
            newState.cards = .loading
            
        case .cards(let cards):
            newState.cards = .loaded(cards)
            
        case .isScanning(let isScanning):
            newState.isScanning = isScanning
        }
        
        return newState
    }
    
}
