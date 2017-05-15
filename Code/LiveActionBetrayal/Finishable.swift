//
//  Finishable.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/17/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import ObjectiveC

// Declare a global var to produce a unique address as the assoc object handle
fileprivate var finishableObjectHandle: UInt8 = 0

public protocol Finishable: class {}

extension Finishable where Self: UIViewController {
    
    var completed: ((_ finished: Bool) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &finishableObjectHandle) as! ((_ finished: Bool) -> Void)?
        }
        set {
            objc_setAssociatedObject(self, &finishableObjectHandle, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func finish() {
        completed?(true)
    }
    
    func cancel() {
        completed?(false)
    }
    
}
