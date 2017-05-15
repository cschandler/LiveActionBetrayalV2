//
//  LightsViewControllers.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 4/26/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import ReSwift

final class LightsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.contentInset = UIEdgeInsetsMake(72, 0, 0, 0)
        }
    }
    
    var players: [Explorer] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
            identifier == IDs.Segues.LightsSettings.rawValue,
            let nav = segue.destination as? UINavigationController,
            let viewController = nav.topViewController as? LightsSettingsViewController else {
                return
        }
        
        viewController.completed = { [weak self] _ in
            self?.dismiss(animated: true)
        }
    }

}

extension LightsViewController: WatcherType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        if let lightsControlView = LightControlView.build() {
            tableView.tableHeaderView = lightsControlView
            lightsControlView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
            lightsControlView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        }
        
        AppStore.shared.subscribe(self)
    }
    
}

extension LightsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IDs.Cells.PeerCell.rawValue, for: indexPath)
        
        let player = players[indexPath.row]
        cell.textLabel?.text = player.name
        cell.imageView?.image = player.picture
        cell.detailTextLabel?.text = player.torchOn ? "ON" : "OFF"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let player = players[indexPath.row]
        ConnectionManager.shared.toggleLight(forPlayer: player, on: !player.torchOn)
    }
    
}

extension LightsViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        players = state.connectedPlayers
    }
    
}
