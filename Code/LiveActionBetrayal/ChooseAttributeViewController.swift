//
//  ChooseAttributeViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/23/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import Foundation

final class ChooseAttributeViewController: BaseViewController {
    
    var metadata: PlayerMetadata?
    
}

extension ChooseAttributeViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dump(metadata)
    }
    
}
