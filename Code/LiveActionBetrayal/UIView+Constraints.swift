//
//  UIView+Constraints.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 7/21/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

extension UIView {
    
    func constrainEdgeAnchorsToViewEdgeAnchors(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    func addEdgeConstraintsToSuperview() {
        guard let view = self.superview else {
            preconditionFailure("Must have a superview to use this method")
        }
        
        constrainEdgeAnchorsToViewEdgeAnchors(view)
    }
    
    // TODO: Switch to top layout guide to safe area for iOS 11
    func addEdgeConstraints(inViewController viewController: UIViewController, insets: UIEdgeInsets = .zero, useTopLayoutGuide: Bool = false) {
        guard let view = viewController.view else {
            preconditionFailure("View controller must have a view to apply constraints to")
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let leadingConstant: CGFloat
        let trailingConstant: CGFloat
        
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            leadingConstant = insets.left
            trailingConstant = insets.right
        } else {
            leadingConstant = insets.right
            trailingConstant = insets.left
        }
        
        topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingConstant).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailingConstant).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom).isActive = true
    }
    
}
