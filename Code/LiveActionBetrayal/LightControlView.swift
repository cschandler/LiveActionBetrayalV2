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
    
    @IBOutlet weak var manualAutoSwitch: UISwitch!
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var switchVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var allLightsButton: UIButton!
    @IBOutlet weak var timerVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var resetVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var startStopVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var allLightsVisualEffectView: UIVisualEffectView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        translatesAutoresizingMaskIntoConstraints = false
        
        timerVisualEffectView.addBorder()
        switchVisualEffectView.addBorder()
        resetVisualEffectView.addBorder()
        startStopVisualEffectView.addBorder()
        allLightsVisualEffectView.addBorder()
        
        let title = TorchManager.isOn ? "TURN OFF" : "TURN ON"
        allLightsButton.setTitle(title, for: .normal)
        
        timer = CADisplayLink(target: self, selector: #selector(tick(displayLink:)))
        timer.preferredFramesPerSecond = 1
        
        defaultTime = 30
        timeLeft = defaultTime
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(timerLabelTapped(sender:)))
        timerLabel.addGestureRecognizer(tapGR)
    }
    
    var autoReset: Bool {
        return manualAutoSwitch.isOn
    }
    
    var defaultTime: Int = 0
    var timer: CADisplayLink!
    var timeLeft: Int = 0 {
        didSet {
            timerLabel.text = "\(timeLeft)"
        }
    }
    
    var lightsOn: Bool = false {
        didSet {
            let title = lightsOn ? "TURN OFF" : "TURN ON"
            allLightsButton.setTitle(title, for: .normal)
            ConnectionManager.shared.toggleLights(on: lightsOn)
        }
    }
    
    var playPauseState: PlayStates = .none {
        didSet {
            startStopButton.setImage(playPauseState.icon, for: .normal)
            
            switch playPauseState {
            case .play:
                timer.isPaused = false
                timer.add(to: .current, forMode: .defaultRunLoopMode)
            case .pause:
                timer.isPaused = true
            default:
                break
            }
        }
    }
    
    enum PlayStates {
        case none
        case play
        case pause
        
        var icon: UIImage? {
            switch self {
            case .play:
                return #imageLiteral(resourceName: "ic-pause")
            case .pause:
                return #imageLiteral(resourceName: "ic-play")
            case .none:
                return nil
            }
        }
    }
    
    func timerLabelTapped(sender: Any?) {
        print("TIMER LABEL TAPPED")
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        timeLeft = defaultTime
    }
    
    @IBAction func startStopButtonTapped(_ sender: UIButton) {
        switch playPauseState {
        case .play:
            playPauseState = .pause
        case .pause, .none:
            playPauseState = .play
        }
    }
    
    @IBAction func allLightsButtonTapped(_ sender: UIButton) {
        lightsOn = !lightsOn
    }
    
    func tick(displayLink: CADisplayLink) {
        timeLeft -= 1
        
        if timeLeft == 0 {
            if autoReset {
                timeLeft = defaultTime
            } else {
                playPauseState = .pause
            }
            
            lightsOn = !lightsOn
        }
    }
    
    @IBAction func switchFlipped(_ sender: UISwitch) {
        switchLabel.text = sender.isOn ? "AUTO" : "MANUAL"
    }
}
