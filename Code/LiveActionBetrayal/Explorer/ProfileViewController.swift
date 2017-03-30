//
//  ProfileViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/26/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import CircleMenu

final class ProfileViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var diceBarButtonItem: UIBarButtonItem!
    
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
    
    @IBAction func diceButtonTapped(_ sender: UIBarButtonItem) {
        let nav = DiceViewController.build()
        
        if let vc = nav.topViewController as? DiceViewController {
            vc.delegate = self
        }
        
        present(nav, animated: false, completion: nil)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Defaults.shared.lastRoll != 0 {
            diceBarButtonItem.title = "Roll: \(Defaults.shared.lastRoll)"
        }
    }

}

extension ProfileViewController: DiceDelegate {
    
    func didRoll(withResult result: Int) {
        diceBarButtonItem.title = "Roll: \(result)"
    }
    
}
