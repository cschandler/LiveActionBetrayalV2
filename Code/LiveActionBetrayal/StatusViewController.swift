//
//  StatusViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/17/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import ReSwift
import MultipeerConnectivity

class StatusViewController: BaseViewController {
    
    static func build() -> UINavigationController {
        return UIStoryboard(name: IDs.Storyboards.Status.rawValue, bundle: nil).instantiateInitialViewController() as! UINavigationController
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    var peers: [Peer] {
        return ConnectionStore.shared.state.connectedPeers
    }
}

extension StatusViewController: StatusType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackground(image: theme.backgroundImage, withBlurRadius: 0.0)
        ConnectionStore.shared.subscribe(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        ConnectionStore.shared.unsubscribe(self)
    }
}

extension StatusViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: IDs.Cells.PeerCell.rawValue)
        
        let peer = peers[indexPath.row]
        
        cell.textLabel?.text = peer.name
        cell.textLabel?.textColor = .white
        cell.imageView?.image = peer.picture
        cell.backgroundColor = .clear
        
        return cell
    }
}

extension StatusViewController: StoreSubscriber {
    
    func newState(state: ConnectionState) {
        tableView.reloadData()
    }
}
