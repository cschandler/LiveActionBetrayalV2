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
        let existingOmens = currentCards.filter { $0.type == .omen }
        let newOmens = cards.filter { $0.type == .omen }
        
        if newOmens.count > existingOmens.count {
            let roll = GKRandomDistribution.d6().nextInt()
            
            if newOmens.count > roll {
                triggerHaunt()
            }
        }
    }
    
    private static func triggerHaunt() {
        AppStore.shared.dispatch(AppAction.triggerHaunt)
        ConnectionManager.shared.triggerHaunt()
    }
    
}
