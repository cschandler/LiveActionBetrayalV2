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
    
    var cards: [Card] = [] {
        didSet {
            tableView.reloadData()
        }
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
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IDs.Cells.CardCell.rawValue, for: indexPath) as! CardCell
        
        let card = cards[indexPath.row]
        
        cell.nameLabel.text = card.name
        cell.typeLabel.text = "(\(card.type.rawValue))"
        
        if let owner = card.owner,
            let explorer = AppStore.shared.state.getPlayer(withId: owner) {
                cell.ownerLabel.text = explorer.name
        } else {
            cell.ownerLabel.text = nil
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let card = cards[indexPath.row]
        let viewController = CardDetailViewController.build(card: card)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - Store Subscriber

extension AllCardsViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        cards = state.cards
    }
    
}
