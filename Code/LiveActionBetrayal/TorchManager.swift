//
//  TorchManager.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/15/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import Foundation
import AVFoundation

class TorchManager {
    
    static func turn(on: Bool) {
        guard let device = AVCaptureDevice.default(for: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.video))),
            device.hasTorch,
            !AppStore.shared.state.cardState.isScanning else {
                return
        }
        
        do {
            try device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            device.unlockForConfiguration()
        } catch {
            print("Torch unavailable")
        }
    }
    
    static var isOn: Bool {
        guard let device = AVCaptureDevice.default(for: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.video))),
            device.hasTorch else {
                return false
        }
        
        switch device.torchMode {
        case .on:
            return true
        default:
            return false
        }
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVMediaType(_ input: AVMediaType) -> String {
	return input.rawValue
}
