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

class StatusViewController: UIViewController {
    
    static func build() -> UINavigationController {
        return UIStoryboard(name: IDs.Storyboards.Status.rawValue, bundle: nil).instantiateInitialViewController() as! UINavigationController
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    var state: ConnectionState {
        return ConnectionStore.shared.state
    }
}

extension StatusViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ConnectionStore.shared.subscribe(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        ConnectionStore.shared.unsubscribe(self)
    }
}

extension StatusViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state.connectedPeers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: IDs.Cells.PeerCell.rawValue)
        
        cell.textLabel?.text = state.connectedPeers[indexPath.row].displayName
        cell.textLabel?.textColor = .white
        cell.imageView?.image = #imageLiteral(resourceName: "ic-avatar-default")
        cell.backgroundColor = .clear
        
        return cell
    }
}

extension StatusViewController: StoreSubscriber {
    
    func newState(state: ConnectionState) {
        tableView.reloadData()
    }
}
