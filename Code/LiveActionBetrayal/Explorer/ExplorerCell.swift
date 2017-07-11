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
    
    func setupDetail(withUnreadMessages messages: [Message]) {
        guard messages.count > 0 else {
            detailLabel.text = nil
            detailLabel.backgroundColor = .clear
            return
        }
        
        detailLabel.text = " \(messages.count) unread "
        detailLabel.textColor = .white
        detailLabel.backgroundColor = UIColor(red:0.99, green:0.24, blue:0.22, alpha:1.00) // tab bar badge red
        detailLabel.layer.cornerRadius = 6
        detailLabel.clipsToBounds = true
    }
    
}
