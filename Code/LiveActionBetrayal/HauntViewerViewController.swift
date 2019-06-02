//
//  HauntViewerViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 6/2/19.
//  Copyright © 2019 Charles Chander. All rights reserved.
//

import Foundation
import PinkyPromise

enum HauntType: String {
    case explorer
    case traitor
}

class HauntViewerViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet var hauntNameTextField: UITextField!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var hauntType: HauntType!
    
    var hauntText: Loadable<String> = .notAsked {
        didSet {
            switch hauntText {
            case .loaded(let text):
                descriptionTextView.text = text
                activityIndicator.stopAnimating()
                
            case .loading:
                activityIndicator.startAnimating()
                
            case .error(let error):
                descriptionTextView.text = error.localizedDescription
                activityIndicator.stopAnimating()
                
            case .notAsked:
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.stopAnimating()
        
        if !AppStore.shared.state.hauntState.hauntName.isEmpty {
            hauntNameTextField.text = AppStore.shared.state.hauntState.hauntName
            getHaunt()
        }
    }
    
    func getHaunt() {
        guard let hauntName = hauntNameTextField.text else {
            return
        }
        
        hauntText = .loading
        
        ConnectionManager.shared.getHaunt(withName: hauntName, type: hauntType.rawValue)
            .onSuccess { text in
                self.hauntText = .loaded(text)
            }
            .onFailure { error in
                self.hauntText = .error(error)
            }
            .call()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        getHaunt()
        resignFirstResponder()
        return true
    }
    
}
