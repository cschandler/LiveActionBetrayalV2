//
//  VibrantLabel.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/27/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

class VibrantLabel: UIView {
    
    var text: String = ""
    
    required init(text: String) {
        super.init(frame: .zero)
        self.text = text
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        let blurEffect = UIBlurEffect(style: .dark)
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
        
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        vibrantView.contentView.addSubview(label)
        label.topAnchor.constraint(equalTo: vibrantView.contentView.topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: vibrantView.contentView.leadingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: vibrantView.contentView.bottomAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: vibrantView.contentView.trailingAnchor).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
