//
//  AllMessagesViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 5/17/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import ReSwift
import JSQMessagesViewController

final class AllMessagesViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var selectedPlayer: Explorer?
    
    var players: [Explorer] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var messages: [Message] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var watcher: Watcher?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
            identifier == IDs.Segues.MessagesMasterToDetail.rawValue,
            let destination = segue.destination as? MessagesViewController,
            let player = selectedPlayer,
            let watcherId = watcher?.identifier else {
                return
        }
        
        let sender = Messanger(id: watcherId, displayName: "Watcher", avatar: #imageLiteral(resourceName: "ic-avatar-default"))
        let reciever = Messanger(id: player.identifier, displayName: player.name, avatar: player.picture)
        
        destination.sender = sender
        destination.reciever = reciever
    }
}

// MARK: - Life Cycle

extension AllMessagesViewController: WatcherType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Messages"
        
        setupView()
        
        AppStore.shared.subscribe(self)
        
        tableView.register(ExplorerCell.nib, forCellReuseIdentifier: IDs.Cells.ExplorerCell.rawValue)
    }
    
}

// MARK: - UITableView

extension AllMessagesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IDs.Cells.ExplorerCell.rawValue, for: indexPath) as! ExplorerCell
        
        let player = players[indexPath.row]
        
        cell.name.text = player.name
        cell.profilePicture.image = player.picture
        
        let unreadMessages = messages.filter { $0.senderId == player.identifier && $0.read == false }
        
        if unreadMessages.count > 0 {
            cell.detailLabel.text = " \(unreadMessages.count) unread "
            cell.detailLabel.textColor = .white
            cell.detailLabel.backgroundColor = UIColor(red:0.99, green:0.24, blue:0.22, alpha:1.00) // tab bar badge red
            cell.detailLabel.layer.cornerRadius = 6
            cell.detailLabel.clipsToBounds = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let player = players[indexPath.row]
        selectedPlayer = player
        
        performSegue(withIdentifier: IDs.Segues.MessagesMasterToDetail.rawValue, sender: nil)
    }
    
}

// MARK: - Store Subscriber

extension AllMessagesViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        players = state.connectedPlayers
        messages = state.allMessages
        watcher = state.watcher
    }
    
}
