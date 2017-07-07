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
                triggerHaunt()
            }
        }
    }
    
    static func triggerHaunt() {
        AppStore.shared.dispatch(AppAction.triggerHaunt)
        ConnectionManager.shared.triggerHaunt()
    }
    
}
