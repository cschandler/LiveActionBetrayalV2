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
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var minus: UIButton!
    @IBOutlet weak var plus: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    static func build(stat: Stat?, withTitle title: String) -> StatStepper? {
        guard let view = Bundle.main.loadNibNamed("StatStepper", owner: nil, options: nil)?.last as? StatStepper else {
            return nil
        }
        
        view.stat = stat
        view.titleText = title
        view.layer.cornerRadius = 24.0
        
        return view
    }
    
    var stat: Stat! {
        didSet {
            guard let stat = stat else {
                return
            }
            
            setup(withStat: stat)
        }
    }
    
    var titleText: String! {
        didSet {
            guard let title = titleText else {
                return
            }
            
            self.title.text = title
        }
    }
    
    var selectedPosition: Position = 0
    
    func setup(withStat stat: Stat) {
        for (index, value) in stat.values.enumerated() {
            let isStartingValue = index == stat.starting
            let label = UILabel()
            label.backgroundColor = .clear
            label.textColor = .white
            label.text = "\(value)"
            label.textAlignment = .center
            label.layer.cornerRadius = 12.0
            label.clipsToBounds = true
            label.font = isStartingValue ? UIFont.systemFont(ofSize: 20, weight: .bold) : .systemFont(ofSize: 17.0)
            label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            stackView.addArrangedSubview(label)
        }
        
        selectPosition(position: stat.current, shouldUpdate: false)
    }
    
    func selectPosition(position: Position, shouldUpdate: Bool = true) {
        // -1 == dead
        guard position >= -1, position < 8 else {
            return
        }
        
        for (index, view) in stackView.arrangedSubviews.enumerated() {
            if let label = view as? UILabel {
                label.backgroundColor = index == position ? UIColor.red.withAlphaComponent(0.8) : .clear
                label.textColor = index == position ? .white : .black
            }
        }
        
        selectedPosition = position
        
        if shouldUpdate {
            ConnectionManager.shared.update(position: position, forStatType: stat.type)
        }
    }
    
    @IBAction func minusTapped(_ sender: UIButton) {
        selectPosition(position: selectedPosition - 1)
    }

    @IBAction func plusTapped(_ sender: UIButton) {
        selectPosition(position: selectedPosition + 1)
    }
}
