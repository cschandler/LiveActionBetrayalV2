//
//  ChooseAttributeViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/23/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

final class ChooseAttributeViewController: BaseViewController {
    
    @IBOutlet weak var directions: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var metadata: PlayerMetadata?
    
}

extension ChooseAttributeViewController: MainMenuType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        directions.textColor = theme.light
    }
    
}

extension ChooseAttributeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attributes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IDs.Cells.AttributeCell.rawValue, for: indexPath)
        
        let attribute = attributes[indexPath.row]
        
        cell.textLabel?.text = attribute.name
        cell.textLabel?.textColor = attribute.color
        cell.textLabel?.alpha = 0.5
        
        return cell
    }

}
