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
    case currentConversation([Message])
    case allMessages([Message])
    case watcher(Watcher)
    case cards([Card])
    case triggerHaunt
    case triggerHauntWithCard(Card)
    case hauntName(String)
    case appForeground
    case isConnected(Bool)
}

struct AppState: StateType {
    var watcher: Watcher?
    var connectedPlayers: [Explorer] = []
    var torchOn: Bool = TorchManager.isOn
    var allMessages: [Message] = []
    var conversation: [Message] = []
    var cards: [Card] = []
    var hauntTriggered: Bool = false
    var hauntName = ""
    var cardTriggeringHaunt: Card?
    var isConnected: Bool = false
    
    func getPlayer(withId id: String) -> Explorer? {
        guard let player = connectedPlayers.lazy.filter({ $0.identifier == id }).first else {
            return nil
        }
        
        return player
    }
    
    func getTraitor() -> Explorer? {
        guard let traitor = connectedPlayers.lazy.filter({ $0.isTraitor }).first else {
            return nil
        }
        
        return traitor
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
            
        case .allMessages(let messages):
            newState.allMessages = messages
            
        case .currentConversation(let messages):
            newState.conversation = messages
            
        case .watcher(let watcher):
            newState.watcher = watcher
            
        case .cards(let cards):
            newState.cards = cards
            
        case .triggerHaunt:
            newState.hauntTriggered = true
            
        case .triggerHauntWithCard(let card):
            newState.cardTriggeringHaunt = card
            newState.hauntTriggered = true
            
        case .hauntName(let name):
            newState.hauntName = name
            
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
                    AppStore.shared.dispatch(AppAction.updated(updatedExplorer))
                }
            }
            .call()
    }

}
