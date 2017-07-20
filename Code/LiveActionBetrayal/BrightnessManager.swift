//
//  BrightnessManager.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 7/12/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

final class BrightnessManager {
    
    private let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    enum BrightnessLevel {
        case none
        case previous
        
        var value: CGFloat {
            switch self {
            case .none:
                return 0
            case .previous:
                return Defaults.shared.brightness
            }
        }
    }
    
    func adjustScreenBrightness(forTorchMode on: Bool) {
        if on {
            setBrightness(level: .previous)
        } else {
            #if RELEASE
            setBrightness(level: .none)
            #endif
        }
    }
    
    // https://stackoverflow.com/questions/15840979/how-to-set-screen-brightness-with-fade-animations
    private func setBrightness(level: BrightnessLevel) {
        queue.cancelAllOperations()
        
        let step: CGFloat = 0.04 * ((level.value > UIScreen.main.brightness) ? 1 : -1)
        
        queue.addOperations(stride(from: UIScreen.main.brightness, through: level.value, by: step).map({ (value) -> Operation in
            let block = BlockOperation()
            
            unowned let _unownedOperation = block
            
            block.addExecutionBlock {
                if !_unownedOperation.isCancelled {
                    Thread.sleep(until: Date() + 0.01)
                    UIScreen.main.brightness = value
                }
            }
            
            return block
        }), waitUntilFinished: false)
    }
    
}
