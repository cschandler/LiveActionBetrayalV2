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
    
    var players: Loadable<[Explorer]> = .loading {
        didSet {
            switch players {
            case .loaded(_):
                tableView.reloadData()
                
                if !transitionInProgress {
                    loadingIndicator.stopAnimating()
                }
                
            default:
                break
            }
        }
    }
    
    var transitionInProgress = false
    
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
        
        title = "Continue"
        
        setupView()
        
        AppStore.shared.subscribe(self)
        
        tableView.register(ExplorerCell.nib, forCellReuseIdentifier: IDs.Cells.ExplorerCell.rawValue)
        tableView.rowHeight = 54
        
        loadingIndicator.startAnimating()
    }
    
}

// MARK: - UITableView

extension ContinueViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let players = players.value else {
            preconditionFailure("Must have a players value for tableView layout")
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: IDs.Cells.ExplorerCell.rawValue, for: indexPath) as! ExplorerCell
        
        let player = players[indexPath.row]
        
        cell.name.text = player.name
        cell.profilePicture.image = player.picture
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let players = players.value else {
            preconditionFailure("Must have a players value for tableView layout")
        }
        
        let player = players[indexPath.row]
        
        ConnectionManager.shared.logIn(player: player)
            .onSuccess { self.transition(withExplorer: player) }
            .onFailure { error in print(error) }
            .call()
        
        transitionInProgress = true
        
        UIView.animate(withDuration: 0.3, animations: { 
            self.tableView.alpha = 0.0
        }) { finished in
            if finished {
                self.loadingIndicator.startAnimating()
            }
        }
    }
    
}

// MARK: - ReSwift

extension ContinueViewController: StoreSubscriber, StatusBarUpdatable {
    
    func newState(state: AppState) {
        players = .loaded(state.connectedPlayers)
        
        updateStatusBar(withState: state)
    }
    
}
