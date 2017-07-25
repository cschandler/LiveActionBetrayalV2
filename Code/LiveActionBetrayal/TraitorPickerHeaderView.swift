//
//  TraitorPickerHeaderView.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 7/10/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

final class TraitorPickerHeaderView: UIView, ClassNameNibLoadable {
    
    static func build(withCard card: Card?) -> TraitorPickerHeaderView {
        let view = TraitorPickerHeaderView.loadInstanceFromNib()
        
        view.card = card
        
        return view
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var card: Card? {
        didSet {
            setup(withCard: card)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
    }
    
    func setup(withCard card: Card?) {
        guard let card = card,
            let ownerId = card.owner,
            let owner = AppStore.shared.state.gameState.getPlayer(withId: ownerId) else {
                descriptionLabel.text = nil
                return
        }
        
        let text = "The haunt began with \(owner.name) finding \(card.name) in the \(String(describing: card.room))."
        
        descriptionLabel.text = text
    }
    
}
