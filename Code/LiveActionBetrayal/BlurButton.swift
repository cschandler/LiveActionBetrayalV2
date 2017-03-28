//
//  BlurButton.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/24/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

class BlurButton: UIButton {
    
    var style: UIBlurEffectStyle = .dark
    
    required init(style: UIBlurEffectStyle) {
        super.init(frame: .zero)
        self.style = style
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        clipsToBounds = true
        
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        let vibrantEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrantView = UIVisualEffectView(effect: vibrantEffect)
        
        addSubview(blurView)
        blurView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        blurView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        blurView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.isUserInteractionEnabled = false
        
        blurView.contentView.addSubview(vibrantView)
        vibrantView.topAnchor.constraint(equalTo: blurView.contentView.topAnchor).isActive = true
        vibrantView.leadingAnchor.constraint(equalTo: blurView.contentView.leadingAnchor).isActive = true
        vibrantView.bottomAnchor.constraint(equalTo: blurView.contentView.bottomAnchor).isActive = true
        vibrantView.trailingAnchor.constraint(equalTo: blurView.contentView.trailingAnchor).isActive = true
        vibrantView.translatesAutoresizingMaskIntoConstraints = false
        vibrantView.isUserInteractionEnabled = false
        
        guard let title = titleLabel else { return }
        vibrantView.contentView.addSubview(title)
        
        addBorder()
    }
}

extension UIButton {
    
    dynamic var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    dynamic var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    dynamic var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    func addBorder() {
        tintColor = .white
        cornerRadius = 4.0
        borderWidth = 1.0
        borderColor = UIColor.gray.withAlphaComponent(0.4)
    }
    
}
