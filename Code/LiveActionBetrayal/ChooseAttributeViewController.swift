//
//  ChooseAttributeViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/23/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

final class ChooseAttributeViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var vibrancyView: UIVisualEffectView!
    @IBOutlet weak var selectButton: BlurButton!
    
    var metadata: PlayerMetadata?
    var selected: IndexPath?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == IDs.Segues.AttributeToPicture.rawValue,
            let destination = segue.destination as? ChoosePictureViewController else {
            return
        }
        
        destination.metadata = metadata
    }
    
}

extension ChooseAttributeViewController: MainMenuType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Attribute"
        
        setupView()
        
        tableView.register(AttributeCell.nib, forCellReuseIdentifier: IDs.Cells.AttributeCell.rawValue)
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 150, right: 0)
        
        blurView.layer.cornerRadius = 12.0
        blurView.layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
        blurView.layer.borderWidth = 1.0
    }
    
}

extension ChooseAttributeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Attributes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IDs.Cells.AttributeCell.rawValue, for: indexPath) as! AttributeCell
        
        let attribute = Attributes.atIndexPath(row: indexPath.row)
        
        cell.attribute.text = attribute.name
        cell.setupLabels(withAttribute: attribute)
        cell.tintColor = .white
        
        return cell
    }

}

extension ChooseAttributeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? AttributeCell else { return }
        
        selected = indexPath
        
        metadata?.attribute = Attributes.atIndexPath(row: indexPath.row)
        
        cell.backgroundColor = .white
        cell.tintColor = .black
        
        tableView.visibleCells.forEach { attributeCell in
            guard
                let attributeCell = attributeCell as? AttributeCell,
                attributeCell.attribute.text != cell.attribute.text
            else {
                return
            }
            
            attributeCell.backgroundColor = .clear
            attributeCell.tintColor = .white
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        if !selectButton.isEnabled {
            UIView.transition(with: selectButton, duration: 0.3, options: .curveEaseIn, animations: {
                self.selectButton.isEnabled = true
                self.selectButton.setTitle("SELECT", for: .normal)
            }, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath == selected else { return }
        
        cell.backgroundColor = .white
        cell.tintColor = .black
    }
    
}
