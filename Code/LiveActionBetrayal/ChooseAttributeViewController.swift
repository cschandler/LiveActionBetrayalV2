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
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var vibrancyView: UIVisualEffectView!
    
    var metadata: PlayerMetadata?
    
}

extension ChooseAttributeViewController: MainMenuType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        directions.textColor = theme.light
        
        let nib = UINib(nibName: IDs.Cells.AttributeCell.rawValue, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: IDs.Cells.AttributeCell.rawValue)
        blurView.layer.cornerRadius = 8.0
    }
    
}

extension ChooseAttributeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attributes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IDs.Cells.AttributeCell.rawValue, for: indexPath) as! AttributeCell
        
        let attribute = attributes[indexPath.row]
        
        cell.attribute.text = attribute.name
        cell.attribute.textColor = theme.bright
        cell.gradientView.endColor = attribute.color
        cell.setupLabels(withAttribute: attribute, andColor: theme.light)
        
        return cell
    }

}

extension ChooseAttributeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? AttributeCell else { return }
        
        cell.isExpanded = true
        
        UIView.animate(withDuration: 0.3) { 
            cell.gradientView.alpha = 1.0
            cell.layoutIfNeeded()
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? AttributeCell else { return }
        
        cell.isExpanded = false
        
        UIView.animate(withDuration: 0.3) {
            cell.gradientView.alpha = 0.0
            cell.layoutIfNeeded()
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
