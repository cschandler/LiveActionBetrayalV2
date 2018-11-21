//
//  CardCell.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 7/7/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

final class CardCell: UITableViewCell, ClassNameNibLoadable {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
}
