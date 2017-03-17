//
//  ViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/13/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import ReSwift

class ProfileViewController: UIViewController {
    
    var manager: ConnectionManager {
        return ConnectionHandler.shared.manager
    }
    
    @IBOutlet weak var messageTextField: UITextField!

    @IBAction func onButtonTapped(_ sender: UIButton) {
        manager.send(action: .lightsOn)
    }
    
    @IBAction func offButtonTapped(_ sender: UIButton) {
        manager.send(action: .lightsOff)
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        guard let text = messageTextField.text else { return }
        manager.send(action: .message(text))
    }
    
    @IBAction func connectionsButtonTapped(_ sender: UIBarButtonItem) {
        let vc = StatusViewController.build()        
        present(vc, animated: true, completion: nil)
    }
    
}

extension ProfileViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ConnectionHandler.shared.setup(withPeerName: "Test Name")
    }
    
}

