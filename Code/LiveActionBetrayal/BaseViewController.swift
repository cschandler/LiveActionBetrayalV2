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
            background.addEdgeConstraints(inViewController: self)
            background.contentMode = .scaleAspectFill
        }
    }
    
    var loadingIndicator: UIActivityIndicatorView! {
        didSet {
            view.insertSubview(loadingIndicator, at: 1)
            loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
    }
    
    internal func setBackground(image: UIImage?, withBlurRadius radius: CGFloat = 2.5, saturation: CGFloat = 1.0) {
        let blurredImage = image?.applyBlurWithRadius(radius, tintColor: nil, saturationDeltaFactor: saturation)
        
        background.image = blurredImage
    }
    
}

extension BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        background = UIImageView(frame: view.bounds)
        loadingIndicator = UIActivityIndicatorView(style: .whiteLarge)
    }

}
