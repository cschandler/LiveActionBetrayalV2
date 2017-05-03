//
//  TimerView.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 5/2/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

final class LightControlView: UIView {
    
    static func build() -> LightControlView? {
        guard let view = Bundle.main.loadNibNamed("LightControlView", owner: nil, options: nil)?.last as? LightControlView else {
            return nil
        }
        
        return view
    }
    
    @IBOutlet weak var timerLabel: UILabel! {
        didSet {
            let tapGR = UITapGestureRecognizer(target: self, action: #selector(timerLabelTapped(sender:)))
            timerLabel.addGestureRecognizer(tapGR)
        }
    }
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var allLightsButton: UIButton!
    @IBOutlet weak var timerVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var resetVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var startStopVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var allLightsVisualEffectView: UIVisualEffectView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        timerVisualEffectView.layer.cornerRadius = 6
        resetVisualEffectView.layer.cornerRadius = 6
        startStopVisualEffectView.layer.cornerRadius = 6
        allLightsVisualEffectView.layer.cornerRadius = 6
    }
    
    func timerLabelTapped(sender: Any?) {
        print("TIMER LABEL TAPPED")
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        print("RESET BUTTON TAPPED")
    }
    
    @IBAction func startStopButtonTapped(_ sender: UIButton) {
        print("START STOP BUTTON TAPPED")
    }
    
    @IBAction func allLightsButtonTapped(_ sender: UIButton) {
        print("ALL LIGHTS BUTTON TAPPED")
    }
    
}
