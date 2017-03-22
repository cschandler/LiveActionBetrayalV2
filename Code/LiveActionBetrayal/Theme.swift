//
//  Theme.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/21/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

protocol Themeable: class {
    var theme: Theme { get }
}

extension Themeable where Self: BaseViewController {
    
    func setupView() {
        setBackground(image: theme.backgroundImage)
    }
    
}

struct Theme {
    let backgroundImage: UIImage?
    let dark: UIColor // dark
    let mid: UIColor // mid
    let light: UIColor // light
    let bright: UIColor // bright
    let dim: UIColor // dim
    
    init(background: UIImage?, dark: String, mid: String, light: String, bright: String, dim: String) {
        self.backgroundImage = background
        self.dark = UIColor(hex: dark)
        self.mid = UIColor(hex: mid)
        self.light = UIColor(hex: light)
        self.bright = UIColor(hex: bright)
        self.dim = UIColor(hex: dim)
    }
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
