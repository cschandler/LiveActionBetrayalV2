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
}

struct AppState: StateType {
    var connectedPlayers: [Explorer] = []
    var torchOn: Bool = TorchManager.isOn
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
            .onFailure { error in
                print(error)
            }
            .call()
    }

}
