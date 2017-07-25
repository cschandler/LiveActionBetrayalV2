//
//  MessagesState.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 7/24/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import Foundation
import ReSwift

enum MessageAction: Action {
    case loadingConversation
    case currentConversation([Message])
    case resetConversation
    case allMessages([Message])
}

struct MessageState: StateType {
    var allMessages: [Message] = []
    var conversation: Loadable<[Message]> = .notAsked
}

struct MessageReducer {
    
    func messageReducer(action: Action, state: MessageState?) -> MessageState {
        var newState = state ?? MessageState()
        
        guard let action = action as? MessageAction else {
            return newState
        }
        
        switch action {
        case .allMessages(let messages):
            newState.allMessages = messages
            
        case .loadingConversation:
            newState.conversation = .loading
            
        case .currentConversation(let messages):
            newState.conversation = .loaded(messages)
            
        case .resetConversation:
            newState.conversation = .notAsked
        }
        
        return newState
    }
    
}
