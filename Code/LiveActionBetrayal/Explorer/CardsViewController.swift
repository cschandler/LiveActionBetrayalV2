//
//  CardsViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 5/7/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

final class CardsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var cards: [Card] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
}

// MARK: - Life Cycle

extension CardsViewController: ExplorerType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
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
    
}
