//
//  ViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/13/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let manager = ConnectionManager()
    @IBOutlet weak var messageTextField: UITextField!

    @IBAction func onButtonTapped(_ sender: UIButton) {
        manager.send(action: .LightsOn)
    }
    
    @IBAction func offButtonTapped(_ sender: UIButton) {
        manager.send(action: .LightsOff)
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        guard let text = messageTextField.text else { return }
        manager.send(action: .Message(text))
    }
    
}

extension ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
    }
    
}

extension ViewController: ConnectionDelegate {
    
    func perform(action: Action) {
        switch action {
        case .LightsOn:
            TorchManager.turn(on: true)
        case .LightsOff:
            TorchManager.turn(on: false)
        case .Message(_):
            break
        }
    }

}

