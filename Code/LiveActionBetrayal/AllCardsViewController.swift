//
//  AllCardsViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 6/17/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import ReSwift

final class AllCardsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.contentInset = UIEdgeInsetsMake(72.0, 0, 0, 0)
        }
    }
    
    var cards: [Card] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
}

// MARK: - Life Cycle

extension AllCardsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppStore.shared.subscribe(self)
        
        ConnectionManager.shared.getCards()
    }
    
}

// MARK: - Store Subscriber

extension AllCardsViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        cards = state.cards
    }
    
}
