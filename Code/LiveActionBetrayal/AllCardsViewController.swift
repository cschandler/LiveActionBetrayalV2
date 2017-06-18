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
        
        setupView()
        
        AppStore.shared.subscribe(self)
        
        ConnectionManager.shared.getCards()
    }
    
}

// MARK: - UITableView

extension AllCardsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IDs.Cells.CardCell.rawValue, for: indexPath)
        
        let card = cards[indexPath.row]
        cell.textLabel?.text = card.name
        
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
