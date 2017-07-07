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
    static let shared = Store(reducer: AppReducer().handleAction, state: AppState())
}

enum AppAction: Action {
    case torchesOn(Bool)
    case updated(Explorer)
    case added(Explorer)
    case messages([Message])
    case watcher(Watcher)
    case cards([Card])
    case triggerHaunt
    case hauntName(String)
}

struct AppState: StateType {
    var watcher: Watcher?
    var connectedPlayers: [Explorer] = []
    var torchOn: Bool = TorchManager.isOn
    var messages: [Message] = []
    var cards: [Card] = []
    var hauntTriggered: Bool = false
    var hauntName = ""
    
    func getPlayer(withId id: String) -> PlayerType? {
        guard let player = connectedPlayers.filter({ $0.identifier == id }).first else {
            return nil
        }
        
        return player
    }
}

struct AppReducer {
    
    func handleAction(action: Action, state: AppState?) -> AppState {
        var newState = state ?? AppState()
        
        switch action as! AppAction {
        case .added(let explorer):
            guard !newState.connectedPlayers.contains(where: { $0.identifier == explorer.identifier }) else {
                return newState
            }
            
            newState.connectedPlayers.append(explorer)
            getPicture(forExplorer: explorer)
            
        case .updated(let explorer):
            var changedPlayers = newState.connectedPlayers.filter { $0.identifier != explorer.identifier }
            changedPlayers.append(explorer)
            
            newState.connectedPlayers = changedPlayers
            
        case .torchesOn(let torchesOn):
            TorchManager.turn(on: torchesOn)
            newState.torchOn = torchesOn
            
        case .messages(let messages):
            newState.messages = messages
            
        case .watcher(let watcher):
            newState.watcher = watcher
            
        case .cards(let cards):
            newState.cards = cards
            
        case .triggerHaunt:
            newState.hauntTriggered = true
            
        case .hauntName(let name):
            newState.hauntName = name
        }
        
        return newState
    }
    
    private func getPicture(forExplorer explorer: Explorer) {
        ConnectionManager.shared.downloadPicture(withId: explorer.identifier)
            .onSuccess { image in
                var new = explorer
                new.picture = image
                DispatchQueue.main.async {
                    AppStore.shared.dispatch(AppAction.updated(new))
                }
            }
            .call()
    }

}
