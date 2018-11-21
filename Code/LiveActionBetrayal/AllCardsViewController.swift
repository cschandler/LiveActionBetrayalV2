//
//  AllCardsViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 6/17/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

final class AllCardsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    public var cards: [Card] = []
    
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
        
        setupView()
        
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let card = cards[indexPath.row]
        let viewController = CardDetailViewController.build(card: card)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
