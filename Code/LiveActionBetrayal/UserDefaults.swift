//
//  UserDefaults.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/30/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import Foundation

final class Defaults {
    
    static let shared = Defaults()
    
    private struct Keys {
        static let lastRoll = "LastRoll"
    }
    
    open var lastRoll: Int {
        get {
            return UserDefaults.standard.integer(forKey: Keys.lastRoll)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.lastRoll)
        }
    }
}
