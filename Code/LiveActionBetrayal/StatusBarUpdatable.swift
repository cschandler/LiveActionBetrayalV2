//
//  StatusBarUpdatable.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 7/20/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

protocol StatusBarUpdatable: class {}

extension StatusBarUpdatable {
    
    func updateStatusBar(withState state: AppState) {
        UIView.animate(withDuration: 0.3) {
            UIApplication.shared.statusBarView?.backgroundColor = state.isConnected ? .clear : .red
        }
    }
    
}

