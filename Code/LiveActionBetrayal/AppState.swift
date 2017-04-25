//
//  AppState.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/16/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import Foundation
import ReSwift
import MultipeerConnectivity

struct AppStore {
    static let shared = Store(reducer: AppReducer().handleAction, state: AppState())
}

struct AppState: StateType {
    var torchOn: Bool = TorchManager.isOn
}

struct AppReducer {
    
    func handleAction(action: Action, state: AppState?) -> AppState {
        var newState = state ?? AppState()
        
        switch action as! PeerAction {
        case .lightsOn:
            TorchManager.turn(on: true)
            newState.torchOn = true
        case .lightsOff:
            TorchManager.turn(on: false)
            newState.torchOn = false
        default:
            break
        }
        
        return newState
    }

}
