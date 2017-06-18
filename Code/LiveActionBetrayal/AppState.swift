//
//  AppState.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/16/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import Foundation
import ReSwift
import GameKit

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
}

struct AppState: StateType {
    var watcher: Watcher?
    var connectedPlayers: [Explorer] = []
    var torchOn: Bool = TorchManager.isOn
    var messages: [Message] = []
    var cards: [Card] = []
    var hauntTriggered: Bool = false
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
            for (index, player) in newState.connectedPlayers.enumerated() {
                if player.identifier == explorer.identifier {
                    let start = newState.connectedPlayers.startIndex.advanced(by: index)
                    let end = newState.connectedPlayers.startIndex.advanced(by: index + 1)
                    let range = start ..< end
                    newState.connectedPlayers.replaceSubrange(range, with: [explorer])
                    break
                }
            }
            
        case .torchesOn(let torchesOn):
            TorchManager.turn(on: torchesOn)
            newState.torchOn = torchesOn
            
        case .messages(let messages):
            newState.messages = messages
            
        case .watcher(let watcher):
            newState.watcher = watcher
            
        case .cards(let cards):
            if let state = state {
                let existingOmens = state.cards.filter { $0.type == .omen }
                let newOmens = cards.filter { $0.type == .omen }
                
                if newOmens.count > existingOmens.count {
                    let roll = GKRandomDistribution.d6().nextInt()
                    
                    if newOmens.count > roll {
                        newState.hauntTriggered = true
                    }
                }
            }
            
            newState.cards = cards
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
