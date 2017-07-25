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
    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var setHauntTextField: UITextField!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    var card: Card? {
        didSet {
            guard let card = card,
                let ownerId = card.owner,
                let owner = AppStore.shared.state.gameState.getPlayer(withId: ownerId) else {
                    return
            }
            
            detailLabel.text = "The haunt began with \(owner.name) finding \(card.name) in the \(String(describing: card.room))."
        }
    }
    
    var explorers: [Explorer] = [] {
        didSet {
            tableViewHeightConstraint.constant = CGFloat(explorers.count) * 54.0
            tableView.reloadData()
        }
    }
    
    var selectedTraitor: Explorer?
    
    @IBAction func rejectButtonTapped(_ sender: UIButton) {
        cancel()
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        guard let text = setHauntTextField.text else {
            setHauntTextField.backgroundColor = .red
            return
        }
        
        setHauntTextField.backgroundColor = .white
        
        guard let traitor = selectedTraitor else {
            tableView.backgroundColor = .red
            return
        }
        
        ConnectionManager.shared.updatePlayer(explorer: traitor)
        ConnectionManager.shared.setHaunt(withName: text)
        finish()
    }
    
    func setupTableView() {
        tableView.rowHeight = 54.0
        tableView.register(ExplorerCell.nib, forCellReuseIdentifier: IDs.Cells.ExplorerCell.rawValue)
    }
    
}

extension TraitorPickerViewController: StatusType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackground(image: theme.backgroundImage, withBlurRadius: 0.0)
        
        AppStore.shared.subscribe(self)
        
        setupTableView()
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGR)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTraitor = explorers[indexPath.row]
    }
    
}

extension TraitorPickerViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        explorers = state.gameState.connectedPlayers
    }
    
}

extension TraitorPickerViewController: UITextFieldDelegate {
    
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
     
        return true
     }
     
     func dismissKeyboard() {
        setHauntTextField.resignFirstResponder()
     }
}
