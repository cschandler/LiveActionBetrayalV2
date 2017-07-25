//
//  AppState.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/16/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import Foundation
import ReSwift

struct AppStore {
    static let shared = Store(reducer: AppReducer().appReducer, state: AppState(gameState: GameState(),
                                                                                cardState: CardState(),
                                                                                messageState: MessageState(),
                                                                                hauntState: HauntState()))
}

struct AppState: StateType {
    let gameState: GameState
    let cardState: CardState
    let messageState: MessageState
    let hauntState: HauntState
}

struct AppReducer {
    
    func appReducer(action: Action, state: AppState?) -> AppState {
        return AppState(
            gameState: GameReducer().gameReducer(action: action, state: state?.gameState),
            cardState: CardReducer().cardReducer(action: action, state: state?.cardState),
            messageState: MessageReducer().messageReducer(action: action, state: state?.messageState),
            hauntState: HauntReducer.hauntReducer(action: action, state: state?.hauntState)
        )
    }
    
}
