//
//  UserDefaults.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/30/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

final class Defaults {
    
    static let shared = Defaults()
    
    private struct Keys {
        static let lastRoll = "LastRoll"
        static let automaticLightReset = "AutomaticLightReset"
        static let lightsOff = "LightsOffTimerInterval"
        static let lightsOn = "LightsOnTimeInterval"
        static let brightness = "Brightness"
    }
    
    open var lastRoll: Int {
        get {
            return UserDefaults.standard.integer(forKey: Keys.lastRoll)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.lastRoll)
        }
    }
    
    open var automaticLightReset: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.automaticLightReset)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.automaticLightReset)
        }
    }
    
    open var lightsOff: TimeInterval {
        get {
            return UserDefaults.standard.double(forKey: Keys.lightsOff)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.lightsOff)
        }
    }
    
    open var lightsOn: TimeInterval {
        get {
            return UserDefaults.standard.double(forKey: Keys.lightsOn)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.lightsOn)
        }
    }
    
    open var brightness: CGFloat {
        get {
            return CGFloat(UserDefaults.standard.double(forKey: Keys.brightness))
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.brightness)
        }
    }
}
