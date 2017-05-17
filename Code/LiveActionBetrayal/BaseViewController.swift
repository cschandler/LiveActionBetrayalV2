//
//  BaseViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/22/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var background: UIImageView! {
        didSet {
            view.insertSubview(background, at: 0)
            background.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            background.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            background.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            background.contentMode = .scaleAspectFill
        }
    }
    
    internal func setBackground(image: UIImage?, withBlurRadius radius: CGFloat = 2.5) {
        let blurredImage = image?.applyBlurWithRadius(radius, tintColor: nil, saturationDeltaFactor: 1.0)
        
        background.image = blurredImage
    }
    
}

extension BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        background = UIImageView(frame: view.bounds)
    }

}
