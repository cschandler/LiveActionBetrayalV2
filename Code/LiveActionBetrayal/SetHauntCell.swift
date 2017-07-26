//
//  SetHauntCell.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 7/25/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

final class SetHauntCell: UITableViewCell, ClassNameNibLoadable {
    
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = .clear
    }
    
}

extension SetHauntCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
}
