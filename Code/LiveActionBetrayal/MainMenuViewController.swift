//
//  ViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/13/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import ReSwift

final class MainMenuViewController: BaseViewController {

    var manager: ConnectionManager {
        return ConnectionHandler.shared.manager
    }
    
    @IBAction func connectionButtonTapped(_ sender: UIBarButtonItem) {
        let vc = StatusViewController.build()
        present(vc, animated: true, completion: nil)
    }
    
}

extension MainMenuViewController: MainMenuType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
}
