//
//  GameState.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 7/24/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import Foundation
import ReSwift

enum GameAction: Action {
    case torchesOn(Bool)
    case updated(Explorer)
    case added(Explorer)
    case watcher(Watcher)
    case appForeground
    case isConnected(Bool)
}

struct GameState: StateType {
    var watcher: Watcher?
    var connectedPlayers: [Explorer] = []
    var torchOn: Bool = TorchManager.isOn
    var isConnected: Bool = false
    
    func getPlayer(withId id: String) -> Explorer? {
        guard let player = connectedPlayers.first(where: { $0.identifier == id }) else {
            return nil
        }
        
        return player
    }
    
    func getTraitor() -> Explorer? {
        guard let traitor = connectedPlayers.first(where: { $0.isTraitor }) else {
            return nil
        }
        
        return traitor
    }
    
    func getCurrentPlayer() -> Explorer? {
        guard let id = ConnectionManager.shared.currentPlayer?.identifier,
            let player = getPlayer(withId: id) else {
                return nil
        }
        
        return player
    }

}

struct GameReducer {
    
    func gameReducer(action: Action, state: GameState?) -> GameState {
        var newState = state ?? GameState()
        
        guard let action = action as? GameAction else {
            return newState
        }
        
        switch action {
        case .added(let explorer):
            guard !newState.connectedPlayers.contains(where: { $0.identifier == explorer.identifier }) else {
                return newState
            }
            
            newState.connectedPlayers.append(explorer)
            getPicture(forExplorer: explorer)
            
        case .updated(let updatedExplorer):
            let changedPlayers: [Explorer] = newState.connectedPlayers.map({ explorer in
                if explorer.identifier == updatedExplorer.identifier {
                    return updatedExplorer
                } else {
                    return explorer
                }
            })
            
            newState.connectedPlayers = changedPlayers
            
        case .torchesOn(let torchesOn):
            newState.torchOn = torchesOn
            
        case .watcher(let watcher):
            newState.watcher = watcher
            
        case .appForeground:
            break
            
        case .isConnected(let connected):
            newState.isConnected = connected
        }
        
        return newState
    }
    
    private func getPicture(forExplorer explorer: Explorer) {
        ConnectionManager.shared.downloadPicture(withId: explorer.identifier)
            .onSuccess { image in
                let updatedExplorer = Explorer.pictureLens.to(image, explorer)
                
                DispatchQueue.main.async {
                    AppStore.shared.dispatch(GameAction.updated(updatedExplorer))
                }
            }
            .call()
    }
    
}
