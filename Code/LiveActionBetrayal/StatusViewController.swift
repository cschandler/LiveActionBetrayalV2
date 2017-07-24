//
//  StatusViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/17/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import ReSwift

class StatusViewController: BaseViewController, Finishable {
    
    static func build() -> UINavigationController {
        return UIStoryboard(name: IDs.Storyboards.Status.rawValue, bundle: nil).instantiateInitialViewController() as! UINavigationController
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0)
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        finish()
    }
    
    var players: [Explorer] = []
}

extension StatusViewController: StatusType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackground(image: theme.backgroundImage, withBlurRadius: 0.0)
        
        AppStore.shared.subscribe(self)
        
        tableView.register(ExplorerCell.nib, forCellReuseIdentifier: IDs.Cells.ExplorerCell.rawValue)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        AppStore.shared.unsubscribe(self)
    }
}

extension StatusViewController: UITableViewDataSource {
    
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
}

extension StatusViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        players = state.gameState.connectedPlayers
        tableView.reloadData()
    }
}
