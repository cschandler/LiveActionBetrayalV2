//
//  StatStepper.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/27/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

class StatStepper: UIView {
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var minus: UIButton!
    @IBOutlet weak var plus: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    static func build(stat: Stat?) -> StatStepper? {
        guard let view = Bundle.main.loadNibNamed("StatStepper", owner: nil, options: nil)?.last as? StatStepper else {
            return nil
        }
        
        view.stat = stat
        return view
    }
    
    var stat: Stat? {
        didSet {
            guard let stat = stat else { return }
            setup(withStat: stat)
        }
    }
    
    var selectedPosition: Position = 0
    
    func setup(withStat stat: Stat) {
        for value in stat.values {
            let label = UILabel()
            label.backgroundColor = .clear
            label.textColor = .white
            label.text = "\(value)"
            stackView.addArrangedSubview(label)
        }
        
        selectPosition(position: stat.starting)
    }
    
    func selectPosition(position: Position) {
        for (index, view) in stackView.arrangedSubviews.enumerated() {
            if index == position, let label = view as? UILabel {
                label.backgroundColor = .white
                label.textColor = .clear
                selectedPosition = position
            }
        }
    }
    
    @IBAction func minusTapped(_ sender: UIButton) {
        selectPosition(position: selectedPosition - 1)
    }

    @IBAction func plusTapped(_ sender: UIButton) {
        selectPosition(position: selectedPosition + 1)
    }
}
