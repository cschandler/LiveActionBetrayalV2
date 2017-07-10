//
//  TraitorPickerViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 7/10/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import ReSwift

final class TraitorPickerViewController: BaseViewController {
    
    static func build(withCard card: Card) -> TraitorPickerViewController {
        let viewController = UIStoryboard(name: IDs.Storyboards.Watcher.rawValue, bundle: nil).instantiateViewController(withIdentifier: IDs.StoryboardViewControllers.TraitorPickerViewController.rawValue) as! TraitorPickerViewController
        
        viewController.card = card
        
        return viewController
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var card: Card!
    
    var explorers: [Explorer] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    func setupTableView() {
        let header = TraitorPickerHeaderView.build(withCard: card)
        tableView.tableHeaderView = header
        tableView.register(ExplorerCell.nib, forCellReuseIdentifier: IDs.Cells.ExplorerCell.rawValue)
    }
    
}

extension TraitorPickerViewController: StatusType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackground(image: theme.backgroundImage, withBlurRadius: 0.0)
        
        AppStore.shared.subscribe(self)
        
        setupTableView()
    }
    
}

extension TraitorPickerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return explorers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IDs.Cells.ExplorerCell.rawValue, for: indexPath) as! ExplorerCell
        
        let explorer = explorers[indexPath.row]
        
        cell.name.text = explorer.name
        cell.profilePicture.image = explorer.picture
        
        return cell
    }
    
}

extension TraitorPickerViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        explorers = state.connectedPlayers
    }
    
}
