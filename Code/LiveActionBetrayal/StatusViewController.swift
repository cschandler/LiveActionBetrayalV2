//
//  StatusViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/17/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import ReSwift

class StatusViewController: BaseViewController {
    
    static func build() -> UINavigationController {
        return UIStoryboard(name: IDs.Storyboards.Status.rawValue, bundle: nil).instantiateInitialViewController() as! UINavigationController
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0)
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    var players: [Explorer] = []
}

extension StatusViewController: StatusType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackground(image: theme.backgroundImage, withBlurRadius: 0.0)
        AppStore.shared.subscribe(self)
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
        let cell = UITableViewCell(style: .default, reuseIdentifier: IDs.Cells.PeerCell.rawValue)
        
        let player = players[indexPath.row]
        cell.textLabel?.text = player.name
        cell.textLabel?.textColor = .white
        cell.imageView?.image = player.picture
        cell.backgroundColor = .clear
        
        return cell
    }
}

extension StatusViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        players = state.connectedPlayers
        tableView.reloadData()
    }
}
