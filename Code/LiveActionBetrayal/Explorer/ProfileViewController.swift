//
//  ProfileViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/26/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

final class ProfileViewController: BaseViewController {
    
    
    
}

extension ProfileViewController: ExplorerType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("view did load")
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("view will appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("view did appear")
    }
    
}
