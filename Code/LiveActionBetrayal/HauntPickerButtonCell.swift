//
//  HauntPickerButtonCell.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 7/25/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

final class HauntPickerButtonCell: UITableViewCell, ClassNameNibLoadable {
    
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    var rejectButtonTapped: SimpleClosure?
    var startButtonTapped: SimpleClosure?
    
    private let tint = UIColor(red: 0.07, green: 0.39, blue: 0.55, alpha: 1.0)
    private let background = UIColor(red: 0.02, green: 0.1, blue: 0.15, alpha: 1.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = .clear
        
        setup(button: rejectButton, withTitle: "reject")
        setup(button: startButton, withTitle: "start!")
    }
    
    @IBAction func rejectButtonTapped(_ sender: BlurButton) {
        rejectButtonTapped?()
    }
    
    @IBAction func startButtonTapped(_ sender: BlurButton) {
        startButtonTapped?()
    }
    
    private func setup(button: UIButton, withTitle title: String) {
        button.setTitle(title.uppercased(), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: button.titleLabel?.font.pointSize ?? 17.0)
        button.layer.cornerRadius = 4.0
        button.layer.borderWidth = 2.0
        button.layer.borderColor = tint.cgColor
        button.tintColor = tint
        button.backgroundColor = background
    }
}
