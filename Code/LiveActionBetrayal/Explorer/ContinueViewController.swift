//
//  ContinueViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 5/7/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import ReSwift

final class ContinueViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var players: [Explorer] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
}

// MARK: - Life Cycle

extension ContinueViewController: MainMenuType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        AppStore.shared.subscribe(self)
    }
    
}

// MARK: - UITableView

extension ContinueViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IDs.Cells.PeerCell.rawValue, for: indexPath)
        
        let player = players[indexPath.row]
        cell.textLabel?.text = player.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

// MARK: - ReSwift

extension ContinueViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        players = state.connectedPlayers
    }
    
}
