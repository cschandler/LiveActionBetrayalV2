//
//  ClassNameNibLoadable.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 5/15/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//


import Foundation
import UIKit

public protocol ClassNameNibLoadable {}

public extension ClassNameNibLoadable where Self: NSObject {
    static var nib: UINib {
        return nib(Bundle(for: self))
    }
    
    static func nib(_ bundle: Bundle) -> UINib {
        var currentClass: AnyClass = self
        var nib: UINib?
        
        while currentClass != NSObject.self {
            let nibName = String(describing: currentClass)
            if bundle.path(forResource: nibName, ofType: "nib") != nil {
                nib = UINib(nibName: nibName, bundle: bundle)
                break
            }
            currentClass = currentClass.superclass()!
            
        }
        
        guard let returnNib = nib else {
            fatalError("Could not find nib for \(String(describing: self)) in bundle \(bundle.bundleIdentifier!)")
        }
        
        return returnNib
    }
    
    static func loadInstanceFromNib(_ owner: AnyObject? = nil, options: [NSObject: AnyObject]? = nil, bundle: Bundle? = nil) -> Self {
        
        let nib: UINib
        if let bundle = bundle {
            nib = self.nib(bundle)
        } else {
            nib = self.nib
        }
        
        let objects = nib.instantiate(withOwner: owner, options: options)
        var result: Self?
        for object in objects {
            if let object = object as? Self {
                result = object
                break
            }
        }
        guard let returnValue = result else {
            fatalError("Cannot find class \(self) or any of its ancestors as a top level object in nib")
        }
        
        return returnValue
    }
}
