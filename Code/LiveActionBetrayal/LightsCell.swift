//
//  LightsCell.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 6/20/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

final class LightsCell: UITableViewCell, ClassNameNibLoadable {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lightsImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        profileImageView.addBorder()
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        lightsImageView.alpha = 0.8
        profileImageView.image = nil
    }
    
    func toggleLights(on: Bool) {
        lightsImageView.alpha = on ? 0.8 : 0.2
    }
    
}
