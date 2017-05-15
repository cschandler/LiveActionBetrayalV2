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
    
    func transition(withExplorer explorer: Explorer) {
        let transition = TransitionViewController(image: #imageLiteral(resourceName: "img-explorer"),
                                                  storyboardIdentifier: IDs.Storyboards.Explorer.rawValue,
                                                  transitionType: .continueGame(explorer.metadata))
        
        present(transition, animated: true) { [weak self] in
            guard let mainMenu = self?.navigationController?.childViewControllers.first as? MainMenuViewController else {
                return
            }
            
            AppStore.shared.unsubscribe(mainMenu)
        }
    }
    
}

// MARK: - Life Cycle

extension ContinueViewController: MainMenuType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        AppStore.shared.subscribe(self)
        
        tableView.register(ExplorerCell.nib, forCellReuseIdentifier: IDs.Cells.ExplorerCell.rawValue)
    }
    
}

// MARK: - UITableView

extension ContinueViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IDs.Cells.ExplorerCell.rawValue, for: indexPath) as! ExplorerCell
        
        let player = players[indexPath.row]
        
        cell.name.text = player.name
        cell.profilePicture.image = player.picture
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let player = players[indexPath.row]
        ConnectionManager.shared.logIn(player: player)
            .onSuccess { self.transition(withExplorer: player) }
            .onFailure { error in print(error) }
            .call()
    }
    
}

// MARK: - ReSwift

extension ContinueViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        players = state.connectedPlayers
    }
    
}
