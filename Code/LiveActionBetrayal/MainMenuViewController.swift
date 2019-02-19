//
//  ViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/13/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import ReSwift
import FirebaseAuth

final class MainMenuViewController: BaseViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var newGameButton: BlurButton!
    @IBOutlet weak var continueButton: BlurButton! 
    
    var shouldAnimate = true
    
    @IBAction func connectionButtonTapped(_ sender: UIBarButtonItem) {
        let nav = StatusViewController.build()
        
        if let viewController = nav.topViewController as? StatusViewController {
            viewController.completed = { [unowned self] _ in
                self.dismiss(animated: true) {
                    AppStore.shared.subscribe(self)
                }
            }
        }
        
        present(nav, animated: true) {
            AppStore.shared.unsubscribe(self)
        }
    }
    
    @IBAction func watcherButtonTapped(_ sender: BlurButton) {
        let transition = TransitionViewController(image: #imageLiteral(resourceName: "img-watcher"),
                                                  storyboardIdentifier: IDs.Storyboards.Watcher.rawValue,
                                                  transitionType: .watcher)
        
        present(transition, animated: true) {
            AppStore.shared.unsubscribe(self)
        }
    }
    
}

// MARK: - Life Cycle

extension MainMenuViewController: MainMenuType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppStore.shared.subscribe(self)
    }
    
}

// MARK: - ReSwift

extension MainMenuViewController: StoreSubscriber, StatusBarUpdatable {
    
    func newState(state: AppState) {
        if state.gameState.connectedPlayers.count > 0 {
            continueButton.isEnabled = true
        }
        
        updateStatusBar(withState: state.gameState)
    }
    
}
