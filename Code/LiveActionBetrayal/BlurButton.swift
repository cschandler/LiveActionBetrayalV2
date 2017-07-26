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
        
        guard let title = titleLabel else {
            return
        }
        
        vibrantView.contentView.addSubview(title)
        
        addBorder()
    }

}

extension UIView {
    
    func addBorder() {
        self.tintColor = .white
        self.layer.cornerRadius = 4.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
    }
    
}

class LightBlurButton: BlurButton {
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(style: .light)
    }
    
    required init(style: UIBlurEffectStyle) {
        super.init(style: style)
    }
    
}
