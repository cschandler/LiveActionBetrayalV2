//
//  TraitorPickerViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 7/10/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import ReSwift

final class TraitorPickerViewController: BaseViewController, Finishable {
    
    static func build(withCard card: Card?) -> TraitorPickerViewController {
        let viewController = UIStoryboard(name: IDs.Storyboards.Watcher.rawValue, bundle: nil).instantiateViewController(withIdentifier: IDs.StoryboardViewControllers.TraitorPickerViewController.rawValue) as! TraitorPickerViewController
        
        viewController.card = card
        
        return viewController
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var card: Card?
    
    var explorers: [Explorer] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var hauntName: String?
    
    var selectedTraitor: Explorer?
    
    var selectedIndexPath: IndexPath? {
        didSet {
            guard let indexPath = selectedIndexPath else {
                return
            }
            
            selectedTraitor = explorers[indexPath.row]
        }
    }
    
    fileprivate enum TableViewSections: Int {
        case setHaunt = 0
        case players
        case buttons
        
        static var count = TableViewSections.buttons.rawValue + 1
    }
    
    func setupTableView() {
        tableView.rowHeight = 54.0
        tableView.register(SetHauntCell.nib, forCellReuseIdentifier: IDs.Cells.SetHauntCell.rawValue)
        tableView.register(ExplorerCell.nib, forCellReuseIdentifier: IDs.Cells.ExplorerCell.rawValue)
        tableView.register(HauntPickerButtonCell.nib, forCellReuseIdentifier: IDs.Cells.HauntPickerButtonCell.rawValue)
        
        let headerView = TraitorPickerHeaderView.build(withCard: card)
        tableView.tableHeaderView = headerView
    }
    
    func processHauntInformation() {
        guard let name = hauntName, !name.isEmpty else {
            let alert = UIAlertController.with(title: "Error", message: "Input haunt name.")
            present(alert, animated: true, completion: nil)
            return
        }
        
        guard let traitor = selectedTraitor else {
            let alert = UIAlertController.with(title: "Error", message: "Choose a traitor.")
            present(alert, animated: true, completion: nil)
            return
        }
        
        let updatedExplorer = Explorer.traitorLens.to(true, traitor)
        
        ConnectionManager.shared.updatePlayer(explorer: updatedExplorer)
        ConnectionManager.shared.setHaunt(withName: name)
        HauntController.triggerHaunt(withCard: card)
        finish()
    }
    
}

extension TraitorPickerViewController: StatusType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackground(image: theme.backgroundImage, withBlurRadius: 0.0)
        
        AppStore.shared.subscribe(self)
        
        setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // http://collindonnell.com/2015/09/29/dynamically-sized-table-view-header-or-footer-using-auto-layout/
        if let headerView = tableView.tableHeaderView {
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var headerFrame = headerView.frame
            
            //Comparison necessary to avoid infinite loop
            if height != headerFrame.size.height {
                headerFrame.size.height = height
                headerView.frame = headerFrame
                tableView.tableHeaderView = headerView
            }
        }
    }
    
}

extension TraitorPickerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableViewSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = TableViewSections(rawValue: section) else {
            preconditionFailure("tableView misconfiguration")
        }
        
        switch section {
        case .setHaunt, .buttons:
            return 1
        case .players:
            return explorers.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = TableViewSections(rawValue: indexPath.section) else {
            preconditionFailure("tableView misconfiguration")
        }
        
        switch section {
        case .setHaunt:
            let cell = tableView.dequeueReusableCell(withIdentifier: IDs.Cells.SetHauntCell.rawValue, for: indexPath) as! SetHauntCell
            
            cell.hauntNameSet = { [weak self] name in
                self?.hauntName = name
            }
            
            cell.selectionStyle = .none
            
            return cell
            
        case .players:
            let cell = tableView.dequeueReusableCell(withIdentifier: IDs.Cells.ExplorerCell.rawValue, for: indexPath) as! ExplorerCell
            
            let explorer = explorers[indexPath.row]
            
            cell.name.text = explorer.name
            cell.profilePicture.image = explorer.picture
            
            if let selectedIndexPath = selectedIndexPath, selectedIndexPath == indexPath {
                cell.backgroundColor = theme.bright
            } else {
                cell.backgroundColor = .clear
            }
            
            return cell
            
        case .buttons:
            let cell = tableView.dequeueReusableCell(withIdentifier: IDs.Cells.HauntPickerButtonCell.rawValue, for: indexPath) as! HauntPickerButtonCell
            
            cell.rejectButtonTapped = { [weak self] in
                self?.cancel()
            }
            
            cell.startButtonTapped = { [weak self] in
                self?.processHauntInformation()
            }
            
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = TableViewSections(rawValue: indexPath.section) else {
            preconditionFailure("tableView misconfiguration")
        }
        
        switch section {
        case .players:
            selectedIndexPath = indexPath
            tableView.reloadSections(IndexSet(integer: section.rawValue), with: .automatic)
            
        default:
            break
        }
    }
    
}

extension TraitorPickerViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        explorers = state.gameState.connectedPlayers
    }
    
}

extension UIAlertController {
    
    class func with(title: String, message: String, buttonHandler: (SimpleClosure)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            buttonHandler?()
        }))
        
        return alert
    }
    
}

