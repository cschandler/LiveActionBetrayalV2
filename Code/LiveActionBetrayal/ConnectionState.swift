//
//  ConnectionState.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/17/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import Foundation
import ReSwift
import MultipeerConnectivity

struct ConnectionStore {
    static let shared = Store(reducer: ConnectionReducer().handleAction, state: ConnectionState())
}

enum ConnectionAction: Action {
    case updated(Explorer)
    case added(Explorer)
}

struct ConnectionState: StateType {
    var connectedPlayers: [Explorer] = []
}

struct ConnectionReducer {
    
    func handleAction(action: Action, state: ConnectionState?) -> ConnectionState {
        var newState = state ?? ConnectionState()
        
        switch action as! ConnectionAction {
        case .added(let explorer):
            guard !newState.connectedPlayers.contains(where: { $0.identifier == explorer.identifier }) else {
                return newState
            }
            newState.connectedPlayers.append(explorer)
            getPicture(forExplorer: explorer)
            
        case .updated(let explorer):
            print(explorer.picture)
            for (index, player) in newState.connectedPlayers.enumerated() {
                if player.identifier == explorer.identifier {
                    let start = newState.connectedPlayers.startIndex.advanced(by: index)
                    let end = newState.connectedPlayers.startIndex.advanced(by: index + 1)
                    let range = start ..< end
                    newState.connectedPlayers.replaceSubrange(range, with: [explorer])
                    break
                }
            }
        }
        
        return newState
    }
    
    private func getPicture(forExplorer explorer: Explorer) {
        ConnectionManager.shared.downloadPicture(withId: explorer.identifier)
            .onSuccess { image in
                var new = explorer
                new.picture = image
                DispatchQueue.main.async {
                    ConnectionStore.shared.dispatch(ConnectionAction.updated(new))
                }
            }
            .onFailure { error in
                print(error)
            }
            .call()
    }
    
}
