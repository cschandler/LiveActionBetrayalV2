//
//  ViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/13/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import Spruce

final class MainMenuViewController: BaseViewController {

    @IBOutlet weak var stackView: UIStackView!
    
    var manager: ConnectionManager {
        return ConnectionHandler.shared.manager
    }
    
    var animations: [StockAnimation] = []
    var shouldAnimate = true
    
    @IBAction func connectionButtonTapped(_ sender: UIBarButtonItem) {
        let vc = StatusViewController.build()
        present(vc, animated: true, completion: nil)
    }
    
}

extension MainMenuViewController: MainMenuType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        animations = [.fadeIn, .expand(.slightly), .slide(.up, .slightly)]
        stackView.spruce.prepare(with: animations)
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
