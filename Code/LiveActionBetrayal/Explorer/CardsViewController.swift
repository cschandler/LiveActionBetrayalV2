//
//  CardsViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 5/7/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import ReSwift

final class CardsViewController: BaseViewController {
    
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
    
    @IBAction func addCardTapped(_ sender: UIBarButtonItem) {
        let viewController = AddCardViewController.build()
        
        viewController.addCard = { [weak self] card in
            self?.cards.append(card)
            self?.navigationController?.popToRootViewController(animated: true)
        }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - Life Cycle

extension CardsViewController: ExplorerType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        AppStore.shared.subscribe(self)
    }
    
}

// MARK: - UITableView

extension CardsViewController: UITableViewDataSource, UITableViewDelegate {
    
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

extension CardsViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        
    }
    
}
