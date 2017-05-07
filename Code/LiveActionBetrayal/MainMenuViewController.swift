//
//  ViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/13/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import Spruce
import ReSwift

final class MainMenuViewController: BaseViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var continueButton: BlurButton! 
    
    var animations: [StockAnimation] = []
    var shouldAnimate = true
    
    @IBAction func connectionButtonTapped(_ sender: UIBarButtonItem) {
        let vc = StatusViewController.build()
        present(vc, animated: true) {
            AppStore.shared.unsubscribe(self)
        }
    }
    
    @IBAction func watcherButtonTapped(_ sender: BlurButton) {
        let transition = TransitionViewController(image: #imageLiteral(resourceName: "img-watcher"),
                                                  storyboardIdentifier: IDs.Storyboards.Watcher.rawValue,
                                                  metadata: nil)
        
        present(transition, animated: true) {
            AppStore.shared.unsubscribe(self)
        }
    }
    
}

// MARK: - Life Cycle

extension MainMenuViewController: MainMenuType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        continueButton.isEnabled = false
        animations = [.fadeIn, .expand(.slightly), .slide(.up, .slightly)]
        stackView.spruce.prepare(with: animations)
        AppStore.shared.subscribe(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if shouldAnimate {
            stackView.spruce.animate(animations, duration: 0.3) { _ in
                self.shouldAnimate = false
            }
        }
    }
    
}

// MARK: - ReSwift

extension MainMenuViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        if state.connectedPlayers.count > 0 {
            continueButton.isEnabled = true
        }
    }
    
}
