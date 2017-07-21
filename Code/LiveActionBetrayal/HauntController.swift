//
//  HauntController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 6/18/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import Foundation
import GameKit


struct HauntController {
    
    static func triggerHauntIfNeeded(with currentCards: [Card], newCards cards: [Card]) {
        // Don't test on the first startup when AppStore has no cards.
        guard !currentCards.isEmpty else {
            return
        }
        
        let existingOmens = currentCards.filter { $0.type == .omen }
        let newOmens = cards.filter { $0.type == .omen }
        
        if newOmens.count > existingOmens.count {
            let roll = GKRandomDistribution.d6().nextInt()
            
            print("Haunt roll: \(roll) for \(newOmens.count) omens.")
            
            if newOmens.count > roll {
                triggerHaunt(withCard: getLatest(current: existingOmens, new: newOmens))
            }
        }
    }
    
    
    /// Will choose the last omen added to the state.
    static func triggerHaunt() {
        guard let cards = AppStore.shared.state.cards.value else {
            return
        }
        
        let omens = cards.filter({ $0.type == .omen })
        
        guard let omen = omens.last else {
            return
        }
        
        triggerHaunt(withCard: omen)
    }
    
    private static func triggerHaunt(withCard card: Card) {
        AppStore.shared.dispatch(AppAction.triggerHauntWithCard(card))
        ConnectionManager.shared.triggerHaunt()
    }
    
    private static func getLatest(current: [Card], new: [Card]) -> Card {
        for card in new {
            if !current.contains(where: { $0.name == card.name }) {
                return card
            }
        }
        
        return new.last!
    }
    
}
