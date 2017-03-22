//
//  Theme.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/21/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

struct Theme {
    let backgroundImage: UIImage?
    let color1: UIColor
    let color2: UIColor
    let color3: UIColor
    let color4: UIColor
    let color5: UIColor
    
    init(background: UIImage?, color1: String, color2: String, color3: String, color4: String, color5: String) {
        self.backgroundImage = background
        self.color1 = UIColor(hex: color1)
        self.color2 = UIColor(hex: color2)
        self.color3 = UIColor(hex: color3)
        self.color4 = UIColor(hex: color4)
        self.color5 = UIColor(hex: color5)
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
