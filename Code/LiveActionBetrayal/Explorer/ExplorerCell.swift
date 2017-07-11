//
//  ExplorerCell.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 5/15/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

final class ExplorerCell: UITableViewCell, ClassNameNibLoadable {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profilePicture.addBorder()
        profilePicture.layer.cornerRadius = profilePicture.bounds.width / 2
        detailLabel.text = nil
    }
    
}
