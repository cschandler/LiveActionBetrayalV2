//
//  CardDetailViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 5/7/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

final class CardDetailViewController: BaseViewController {
    
    static func build(card: Card) -> CardDetailViewController {
        let viewController = UIStoryboard(name: IDs.Storyboards.Explorer.rawValue, bundle: nil).instantiateViewController(withIdentifier: IDs.StoryboardViewControllers.CardDetailViewController.rawValue) as! CardDetailViewController
        viewController.card = card
        return viewController
    }
    
    var card: Card!
    
    @IBOutlet weak var textVisualEffectView: UIVisualEffectView! {
        didSet {
            textVisualEffectView.addBorder()
        }
    }
    
    @IBOutlet weak var cardTextLabel: UILabel! {
        didSet {
            cardTextLabel.text = card.text
        }
    }
    
}

extension CardDetailViewController: ExplorerType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        title = card.name
    }
    
}
