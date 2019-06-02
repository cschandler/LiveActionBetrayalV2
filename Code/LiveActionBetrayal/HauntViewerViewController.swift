//
//  HauntViewerViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 6/2/19.
//  Copyright © 2019 Charles Chander. All rights reserved.
//

import Foundation
import PinkyPromise

class HauntViewerViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet var hauntNameTextField: UITextView!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
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
    }
    
    func getHaunt() {
        hauntText = .loading
        
        ConnectionManager.shared.getHaunt(withName: hauntNameTextField.text)
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
