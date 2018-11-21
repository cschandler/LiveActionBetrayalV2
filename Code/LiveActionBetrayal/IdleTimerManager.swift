//
//  IdleTimerManager.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 8/26/18.
//  Copyright © 2018 Charles Chander. All rights reserved.
//

import UIKit

public struct IdleTimerManager {
    
    public static let defaultTime: DispatchTime = .now() + 1.0
    
    public static func disable() {
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    public static func disableIdleTimerAfterDelay(time: DispatchTime = IdleTimerManager.defaultTime) {
        DispatchQueue.main.asyncAfter(deadline: time) {
            IdleTimerManager.disable()
        }
    }
    
}
