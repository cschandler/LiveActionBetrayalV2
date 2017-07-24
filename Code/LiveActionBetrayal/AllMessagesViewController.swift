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
    
    enum TableSection: Int {
        case all = 0
        case explorers
        
        static var count = TableSection.explorers.rawValue + 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
            identifier == IDs.Segues.MessagesMasterToDetail.rawValue,
            let destination = segue.destination as? MessagesViewController,
            let watcherId = watcher?.identifier else {
                return
        }
        
        if let  player = selectedPlayer {
            let reciever = Messanger(id: player.identifier, displayName: player.name, avatar: player.picture)
            destination.reciever = reciever
        }
        
        let sender = Messanger(id: watcherId, displayName: "Watcher", avatar: #imageLiteral(resourceName: "ic-avatar-default"))
        destination.sender = sender
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
        tableView.rowHeight = 54
    }
    
}

// MARK: - UITableView

extension AllMessagesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = TableSection(rawValue: section) else {
            fatalError("TableView misconfiguration")
        }
        
        switch section {
        case .all:
            // Don't display all if there's no one to message to
            return players.count > 0 ? 1 : 0
        case .explorers:
            return players.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = TableSection(rawValue: indexPath.section) else {
            fatalError("TableView misconfiguration")
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: IDs.Cells.ExplorerCell.rawValue, for: indexPath) as! ExplorerCell
        
        switch section {
        case .all:
            cell.name.text = "All"
            cell.profilePicture.image = #imageLiteral(resourceName: "ic-profile")
            cell.setupDetail(withUnreadMessages: []) // Hide unread messages detail
            
        case .explorers:
            let player = players[indexPath.row]
            
            cell.name.text = player.name
            cell.profilePicture.image = player.picture
            
            let unreadMessages = messages.filter { $0.senderId == player.identifier && $0.read == false }
            
            cell.setupDetail(withUnreadMessages: unreadMessages)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = TableSection(rawValue: indexPath.section) else {
            fatalError("TableView misconfiguration")
        }
        
        switch section {
        case .all:
            selectedPlayer = nil
            
        case .explorers:
            let player = players[indexPath.row]
            selectedPlayer = player
        }
        
        performSegue(withIdentifier: IDs.Segues.MessagesMasterToDetail.rawValue, sender: nil)
    }
    
}

// MARK: - Store Subscriber

extension AllMessagesViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        players = state.gameState.connectedPlayers
        messages = state.gameState.allMessages
        watcher = state.gameState.watcher
    }
    
}
