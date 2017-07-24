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
    
    @IBOutlet weak var tableView: UITableView!
    
    var cards: Loadable<[Card]> = .notAsked {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBAction func diceButtonTapped(_ sender: UIBarButtonItem) {
        let nav = DiceViewController.build()
        
        if let top = nav.topViewController as? DiceViewController {
            top.completed = { _ in
                self.dismiss(animated: true)
            }
        }
        
        present(nav, animated: false)
    }
}

// MARK: - Life Cycle

extension AllCardsViewController: WatcherType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Items"
        
        setupView()
        
        AppStore.shared.subscribe(self)
        
        tableView.register(CardCell.nib, forCellReuseIdentifier: IDs.Cells.CardCell.rawValue)
    }
    
}

// MARK: - UITableView

extension AllCardsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cards = cards.value else {
            preconditionFailure("TableView misconfigured")
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: IDs.Cells.CardCell.rawValue, for: indexPath) as! CardCell
        
        let card = cards[indexPath.row]
        
        cell.nameLabel.text = card.name
        cell.typeLabel.text = "(\(card.type.rawValue))"
        
        if let owner = card.owner,
            let explorer = AppStore.shared.state.gameState.getPlayer(withId: owner) {
                cell.ownerLabel.text = explorer.name
        } else {
            cell.ownerLabel.text = nil
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cards = cards.value else {
            preconditionFailure("TableView misconfigured")
        }
        
        let card = cards[indexPath.row]
        let viewController = CardDetailViewController.build(card: card)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - Store Subscriber

extension AllCardsViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        cards = state.gameState.cards
    }
    
}
