//
//  GradientView.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/23/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

@IBDesignable final class AttributeGradientView: UIView {
    
    @IBInspectable var startColor: UIColor = .clear
    @IBInspectable var endColor: UIColor = .clear
    
    var midColor: UIColor {
        return .clear
    }
    
    override func draw(_ rect: CGRect) {
        guard let superview = superview else { return }
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: CGFloat(0),
                                y: CGFloat(0),
                                width: superview.frame.size.width,
                                height: 200)
        
        gradient.colors = [startColor.cgColor, midColor.cgColor, endColor.cgColor]
        
        gradient.startPoint = CGPoint(x: -0.3, y: -1.5)
        gradient.endPoint = CGPoint(x: 1.3, y: 1.5)
        
        layer.addSublayer(gradient)
    }
    
}
