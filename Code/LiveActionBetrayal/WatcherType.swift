//
//  WatcherType.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 4/26/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

protocol WatcherType: Themeable {}

extension WatcherType {
    
    var theme: Theme {
        return Theme(background: #imageLiteral(resourceName: "img-watcher"),
                     dark: "1C2B2C",
                     mid: "76C38D",
                     light: "D6C3B1",
                     bright: "4BC484",
                     dim: "598C6E")
    }
    
}

extension WatcherType where Self: BaseViewController {
    
    func setupView() {
        setBackground(image: theme.backgroundImage, saturation: 0.7)
        view.tintColor = theme.mid
        navigationController?.navigationBar.tintColor = theme.mid
    }
    
}
