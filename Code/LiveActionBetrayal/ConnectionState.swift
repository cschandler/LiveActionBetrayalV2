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
    static let shared = Store(reducer: ConnectionReducer(), state: ConnectionState())
}

enum ConnectionAction: Action {
    case peerChangedState(MCPeerID, MCSessionState)
}

struct ConnectionState: StateType {
    var connectedPeers: [MCPeerID] = []
}

struct ConnectionReducer: Reducer {
    
    func handleAction(action: Action, state: ConnectionState?) -> ConnectionState {
        var newState = state ?? ConnectionState()
        
        switch action as! ConnectionAction {
        case .peerChangedState(let peer, let sessionState):
            switch sessionState {
            case .connected:
                newState.connectedPeers.append(peer)
            case .connecting:
                break
            case .notConnected:
                newState.connectedPeers = newState.connectedPeers.filter { $0.displayName != peer.displayName }
            }
        }
        
        return newState
    }
}
