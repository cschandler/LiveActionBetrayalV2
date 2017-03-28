//
//  DiceViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/27/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import CircleMenu

class DiceViewController: BaseViewController {
    
    static func build() -> UINavigationController {
        let vc = DiceViewController()
        
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.barStyle = .black
        nav.modalPresentationStyle = .overCurrentContext
        nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav.navigationBar.shadowImage = UIImage()
        nav.navigationBar.isTranslucent = true
        nav.view.backgroundColor = .clear
        
        return nav
    }
    
    var blurView: UIVisualEffectView! {
        didSet {
            view.insertSubview(blurView, at: 0)
            blurView.frame = view.bounds
        }
    }
    
    let width: CGFloat = 100
    
    var circleMenu: CircleMenu! {
        didSet {
            circleMenu.alpha = 0.0
            circleMenu.delegate = self
            view.addSubview(circleMenu)
        }
    }
    
    func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension DiceViewController: MainMenuType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        blurView = UIVisualEffectView()

        let frame = CGRect(x: (view.bounds.width / 2) - (width / 2),
                           y: (view.bounds.height / 2) - (width / 2),
                           width: width,
                           height: width)
        
        circleMenu = CircleMenu(frame: frame,
                                normalIcon: "ic-dice",
                                selectedIcon: "ic-clear",
                                buttonsCount: 8,
                                duration: 0.3,
                                distance: 130)
        
        let xButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ic-clear"), style: .plain, target: self, action: #selector(dismissSelf))
        xButton.tintColor = .white
        navigationItem.rightBarButtonItem = xButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 0.3, animations: { 
            self.blurView.effect = UIBlurEffect(style: .dark)
        }) { (finished) in
            if finished {
                UIView.animate(withDuration: 0.2, animations: { 
                    self.circleMenu.alpha = 1.0
                })
            }
        }
    }
    
}

extension DiceViewController: CircleMenuDelegate {
    
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        button.setTitle("\(atIndex + 1)", for: .normal)
        let frame = CGRect(x: button.bounds.origin.x + (width / 4), y: button.bounds.origin.y + (width / 4), width: (width / 2), height: (width / 2))
        button.frame = frame
        button.layer.cornerRadius = (width / 4)
        button.backgroundColor = theme.dim
    }
    
}
