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

enum AppAction: Action {
    case torchesOn(Bool)
}

struct AppState: StateType {
    var torchOn: Bool = TorchManager.isOn
}

struct AppReducer {
    
    func handleAction(action: Action, state: AppState?) -> AppState {
        var newState = state ?? AppState()
        
        switch action as! AppAction {
        case .torchesOn(let torchesOn):
            TorchManager.turn(on: torchesOn)
            newState.torchOn = torchesOn
            
        }
        
        return newState
    }

}
