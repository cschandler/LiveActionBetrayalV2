//
//  TransitionViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/26/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

final class TransitionViewController: BaseViewController {
    
    required init(image: UIImage?, storyboardIdentifier: String, metadata: PlayerMetadata?) {
        self.backgroundImage = image
        self.storyboardIdentifier = storyboardIdentifier
        self.metadata = metadata
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let storyboardIdentifier: String
    let backgroundImage: UIImage?
    let metadata: PlayerMetadata?
    
    var imageView: UIImageView! {
        didSet {
            view.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFill
            imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
    }
    
    func transition() {
        guard let vc = UIStoryboard(name: storyboardIdentifier, bundle: nil).instantiateInitialViewController()else { return }
        vc.modalTransitionStyle = .crossDissolve
        
        if let explorer = vc as? ExplorerTabController {
            explorer.metadata = metadata
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension TransitionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView(image: backgroundImage)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let metadata = metadata {
            ConnectionManager.shared.addPlayer(withMetadata: metadata)
                .onSuccess {
                    DispatchQueue.main.async {
                        self.transition()
                    }
                }
                .onFailure { error in }
                .call()
        }
    }
    
}
