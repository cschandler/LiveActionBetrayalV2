//
//  HauntPickerButtonCell.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 7/25/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

final class HauntPickerButtonCell: UITableViewCell, ClassNameNibLoadable {
    
    @IBOutlet weak var rejectButton: BlurButton!
    @IBOutlet weak var startButton: BlurButton!
    
    var rejectButtonTapped: SimpleClosure?
    var startButtonTapped: SimpleClosure?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = .clear
    }
    
    @IBAction func rejectButtonTapped(_ sender: BlurButton) {
        rejectButtonTapped?()
    }
    
    @IBAction func startButtonTapped(_ sender: BlurButton) {
        startButtonTapped?()
    }
    
}
