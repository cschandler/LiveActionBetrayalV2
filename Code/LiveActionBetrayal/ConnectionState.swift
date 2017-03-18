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
    case recievedMetadata(Peer)
}

struct ConnectionState: StateType {
    var connectedPeers: [Peer] = []
}

struct ConnectionReducer: Reducer {
    
    func handleAction(action: Action, state: ConnectionState?) -> ConnectionState {
        var newState = state ?? ConnectionState()
        
        switch action as! ConnectionAction {
            
        case .peerChangedState(let peerID, let sessionState):
            switch sessionState {
            case .connected:
                let peer = Peer(name: peerID.displayName, picture: nil)
                newState.connectedPeers.append(peer)
                
            case .connecting:
                break
                
            case .notConnected:
                newState.connectedPeers = newState.connectedPeers.filter { $0.name != peerID.displayName }
            }
            
        case .recievedMetadata(let peer):
            newState.connectedPeers = newState.connectedPeers.filter { $0.name != peer.name }
            newState.connectedPeers.append(peer)
        }
        
        return newState
    }
    
}
