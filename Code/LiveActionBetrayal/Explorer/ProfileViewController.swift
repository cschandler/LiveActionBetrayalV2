//
//  ProfileViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/26/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

final class ProfileViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var picture: UIImageView! {
        didSet {
            picture.setBorder()
            if let image = metadata?.picture {
                picture.image = image
            }
        }
    }
    
    var metadata: PlayerMetadata? {
        guard let tabBar = tabBarController as? ExplorerTabController,
            let metadata = tabBar.metadata else {
                return nil
        }
        return metadata
    }
    
    
}

extension ProfileViewController: ExplorerType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = metadata?.name ?? "PROFILE"
        
        setupView()
        
        guard let speedStepper = StatStepper.build(stat: metadata?.attribute?.speed, withTitle: "SPEED"),
            let mightStepper = StatStepper.build(stat: metadata?.attribute?.might, withTitle: "MIGHT"),
            let sanityStepper = StatStepper.build(stat: metadata?.attribute?.sanity, withTitle: "SANITY"),
            let knowledgeStepper = StatStepper.build(stat: metadata?.attribute?.knowledge, withTitle: "KNOWLEDGE")
            else { return }
        
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        stackView.addArrangedSubview(speedStepper)
        stackView.addArrangedSubview(mightStepper)
        stackView.addArrangedSubview(sanityStepper)
        stackView.addArrangedSubview(knowledgeStepper)
    }

}
