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
            
        }
    }
    
    var selectedTraitor: Explorer?
    
//    @IBAction func rejectButtonTapped(_ sender: UIButton) {
//        cancel()
//    }
    
//    @IBAction func startButtonTapped(_ sender: UIButton) {
//        guard let text = setHauntTextField.text else {
//            setHauntTextField.backgroundColor = .red
//            return
//        }
//
//        setHauntTextField.backgroundColor = .white
//
//        guard let traitor = selectedTraitor else {
//            tableView.backgroundColor = .red
//            return
//        }
//
//        ConnectionManager.shared.updatePlayer(explorer: traitor)
//        ConnectionManager.shared.setHaunt(withName: text)
//        finish()
//    }
    
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
    
}

extension TraitorPickerViewController: StatusType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackground(image: theme.backgroundImage, withBlurRadius: 0.0)
        
        AppStore.shared.subscribe(self)
        
        setupTableView()
        
//        let tapGR = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        view.addGestureRecognizer(tapGR)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // http://collindonnell.com/2015/09/29/dynamically-sized-table-view-header-or-footer-using-auto-layout/
        if let headerView = tableView.tableHeaderView {
            let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
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
            
            return cell
            
        case .players:
            let cell = tableView.dequeueReusableCell(withIdentifier: IDs.Cells.ExplorerCell.rawValue, for: indexPath) as! ExplorerCell
            
            let explorer = explorers[indexPath.row]
            
            cell.name.text = explorer.name
            cell.profilePicture.image = explorer.picture
            
            return cell
            
        case .buttons:
            let cell = tableView.dequeueReusableCell(withIdentifier: IDs.Cells.HauntPickerButtonCell.rawValue, for: indexPath) as! HauntPickerButtonCell
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = TableViewSections(rawValue: indexPath.section) else {
            preconditionFailure("tableView misconfiguration")
        }
        
        switch section {
        case .players:
            selectedTraitor = explorers[indexPath.row]
            
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

//extension TraitorPickerViewController: UITextFieldDelegate {
//
//     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        dismissKeyboard()
//
//        return true
//     }
//
//     func dismissKeyboard() {
//        setHauntTextField.resignFirstResponder()
//     }
//}

