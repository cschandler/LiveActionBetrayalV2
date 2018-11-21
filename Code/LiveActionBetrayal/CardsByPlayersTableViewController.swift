//
//  CardsByPlayersTableViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 11/21/18.
//  Copyright © 2018 Charles Chander. All rights reserved.
//

import UIKit
import ReSwift

class CardsByPlayersTableviewController: UITableViewController, StoreSubscriber {
    
    typealias CardCountByName = (name: String, count: Int)
    
    var cardCountsByName: [CardCountByName] = []
    var selectedName: String?
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Items"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppStore.shared.subscribe(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let name = selectedName,
            let player = AppStore.shared.state.gameState.getPlayer(withName: name),
            let cards = AppStore.shared.state.cardState.cards.value?.filter({ $0.owner == player.identifier }),
            let destination = segue.destination as? AllCardsViewController else {
                return
        }
        
        destination.cards = cards
        destination.title = name
    }
    
    // MARK: - UITableviewDatasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardCountsByName.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExplorerMasterCell", for: indexPath)
        
        let pair = cardCountsByName[indexPath.row]
        cell.textLabel?.text = pair.name
        cell.detailTextLabel?.text = "\(pair.count)"
        
        return cell
    }
    
    // MARK: - UITableviewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedName = cardCountsByName[indexPath.row].name
        
        performSegue(withIdentifier: "WatcherCardsDetailSegue", sender: nil)
    }
    
    // MARK: - StoreSubscriber
    
    func newState(state: AppState) {
        guard let cards = state.cardState.cards.value else {
            return
        }
        
        let cardsByOwnerDict = Dictionary.init(grouping: cards, by: { (card: Card) -> String in
            if let id = card.owner, let player = state.gameState.getPlayer(withId: id) {
                return player.name
            } else {
                return "unowned"
            }
        })
        
        cardCountsByName = cardsByOwnerDict
            .map { ($0.key, $0.value.count) }
            .sorted(by: { $0.0 < $1.0 })
        
        tableView.reloadData()
    }
    
}
