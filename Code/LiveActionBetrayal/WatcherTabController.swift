//
//  WatcherTabController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 7/6/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import ReSwift

final class WatcherTabController: UITabBarController {
    
}

extension WatcherTabController: WatcherType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = theme.mid
    }
    
}
