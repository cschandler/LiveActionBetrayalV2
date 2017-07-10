//
//  TraitorPickerHeaderView.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 7/10/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

final class TraitorPickerHeaderView: UIView, ClassNameNibLoadable {
    
    static func build(withCard card: Card) -> TraitorPickerHeaderView {
        let view = TraitorPickerHeaderView.loadInstanceFromNib()
        
        view.card = card
        
        return view
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var card: Card!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        
        setup(withCard: card)
    }
    
    func setup(withCard card: Card) {
        guard let ownerId = card.owner,
            let owner = AppStore.shared.state.getPlayer(withId: ownerId) else {
                fatalError("Card or Owner does not exist at Haunt start.")
        }
        
        let text = "The haunt began with \(owner.name) finding \(card.name) in the \(card.room)."
        
        descriptionLabel.text = text
    }
    
}
