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
                let card = getLatest(current: existingOmens, new: newOmens)
                
                let viewController = TraitorPickerViewController.build(withCard: card)
                
                viewController.completed = { _ in
                    UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
                }
                
                UIApplication.shared.keyWindow?.rootViewController?.present(viewController, animated: true, completion: nil)
            }
        }
    }
    
    static func triggerHaunt(withCard card: Card?) {
        AppStore.shared.dispatch(HauntAction.triggerHauntWithCard(card))
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
