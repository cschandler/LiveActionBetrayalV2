//
//  LightsViewControllers.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 4/26/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

final class LightsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0)
        }
    }
    
    
}

extension LightsViewController: WatcherType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        if let lightsControlView = LightControlView.build() {
            tableView.tableHeaderView = lightsControlView
        }
    }
    
}

extension LightsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
