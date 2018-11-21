//
//  DiceViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/27/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import CircleMenu
import Spruce
import GameKit
import PinkyPromise

protocol DiceDelegate: class {
    func didRoll(withResult result: Int)
}

class DiceViewController: BaseViewController, Finishable {
    
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
    
    weak var delegate: DiceDelegate?
    
    var blurView: UIVisualEffectView! {
        didSet {
            view.insertSubview(blurView, at: 0)
            blurView.frame = view.bounds
        }
    }
    
    fileprivate struct Constants {
        struct CircleMenu {
            static let width: CGFloat = 100
        }
    }
    
    var circleMenu: CircleMenu! {
        didSet {
            circleMenu.delegate = self
            view.addSubview(circleMenu)
            circleMenu.alpha = 0.0
            circleMenu.spruce.prepare(with: [.expand(.severely), .slide(.up, .severely)])
        }
    }
    
    typealias Result = (Int, String)
    
    var resultView: ResultView? {
        didSet {
            if let resultView = resultView {
                view.addSubview(resultView)
            }
        }
    }
    
    func buildResultView(withResult result: Result) -> ResultView {
        var width: CGFloat = result.1.width(withConstrainedHeight: 200, font: .boldSystemFont(ofSize: 40))
        
        if width > view.bounds.width {
            width = view.bounds.width
        } else if width <= 80 {
            width = 100
        } else {
            width += 20
        }
        
        let height: CGFloat = result.1.height(withConstrainedWidth: width, font: .boldSystemFont(ofSize: 40)) + 20
        
        let frame = CGRect(x: circleMenu.center.x - (width / 2),
                           y: circleMenu.center.y - (height / 2),
                           width: width,
                           height: height)
        
        return ResultView(frame: frame, color: theme.dim, result: result)
    }
    
    @objc func dismissSelf() {
        finish()
    }
}

extension DiceViewController: MainMenuType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        blurView = UIVisualEffectView()

        let frame = CGRect(x: (view.bounds.width / 2) - (Constants.CircleMenu.width / 2),
                           y: (view.bounds.height / 2) - (Constants.CircleMenu.width / 2),
                           width: Constants.CircleMenu.width,
                           height: Constants.CircleMenu.width)
        
        circleMenu = CircleMenu(frame: frame,
                                normalIcon: "ic-dice",
                                selectedIcon: "ic-clear",
                                buttonsCount: 8,
                                duration: 0.5,
                                distance: 130)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let xButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ic-clear"), style: .plain, target: self, action: #selector(dismissSelf))
        xButton.tintColor = .white
        
        navigationItem.setRightBarButton(xButton, animated: true)

        UIView.animate(withDuration: 0.3, animations: { 
            self.blurView.effect = UIBlurEffect(style: .dark)
        }) { (finished) in
            if finished {
                self.circleMenu.spruce.animate([.expand(.severely), .slide(.up, .severely)])
                UIView.animate(withDuration: 0.3, animations: { 
                    self.circleMenu.alpha = 1.0
                })
            }
        }
    }
    
}

extension DiceViewController: CircleMenuDelegate {
    
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        button.setTitle("\(atIndex + 1)", for: .normal)
        let frame = CGRect(x: button.bounds.origin.x + (Constants.CircleMenu.width / 4),
                           y: button.bounds.origin.y + (Constants.CircleMenu.width / 4),
                           width: (Constants.CircleMenu.width / 2),
                           height: (Constants.CircleMenu.width / 2))
        button.frame = frame
        button.layer.cornerRadius = (Constants.CircleMenu.width / 4)
        button.backgroundColor = theme.dim
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
    }
    
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {
        animateResultViewIn().call { _ in
            self.animateResultViewUp().call()
        }
    }
    
    func circleMenu(_ circleMenu: CircleMenu, buttonWillSelected button: UIButton, atIndex: Int) {
        let result = total(forRolls: atIndex + 1)
        delegate?.didRoll(withResult: result.0)
        
        if let _ = resultView {
            animateResultViewOut().call(completion: { _ in
                self.resultView = self.buildResultView(withResult: result)
            })
        } else {
            resultView = buildResultView(withResult: result)
        }
    }
    
    func menuCollapsed(_ circleMenu: CircleMenu) {
        print("menu collapsed")
    }
    
}

extension DiceViewController {
    
    func total(forRolls rolls: Int) -> Result {
        var die: String = ""
        var num: Int = 0
        for _ in 1...rolls {
            let result = d6
            
            num += result
            
            switch result {
            case 1: die.append("\u{2680} ")
            case 2: die.append("\u{2681} ")
            case 3: die.append("\u{2682} ")
            case 4: die.append("\u{2683} ")
            case 5: die.append("\u{2684} ")
            case 6: die.append("\u{2685} ")
            default: break
            }
        }
        
        return (num, "\(num)\n\(die)")
    }
    
    var d6: Int {
        return GKRandomDistribution.d6().nextInt()
    }
    
}

// MARK: Animations

extension DiceViewController {
    
    func animateResultViewIn() -> Promise<Void> {
        return Promise { fulfill in
            guard let resultView = self.resultView else { return }
            
            resultView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            
            UIView.animate(withDuration: 1.0,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.5,
                           options: .curveEaseOut,
                           animations:
            {
                resultView.alpha = 1.0
                resultView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    
            }) { finished in
                if finished {
                    fulfill(.success(()))
                }
            }
        }
    }
    
    func animateResultViewUp() -> Promise<Void> {
        return Promise { fulfill in
            guard let resultView = self.resultView else { return }
            
            UIView.animate(withDuration: 1.0,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.5,
                           options: .curveEaseInOut,
                           animations:
            {
                resultView.center = CGPoint(x: resultView.center.x,
                                            y: resultView.center.y * 0.4)
                
            }, completion: { finished in
                if finished {
                    fulfill(.success(()))
                }
            })
        }
    }
    
    func animateResultViewOut() -> Promise<Void> {
        return Promise { fulfill in
            guard let resultView = self.resultView else { return }
            
            UIView.animate(withDuration: 0.3, animations: { 
                resultView.alpha = 0.0
            }, completion: { finished in
                resultView.removeFromSuperview()
                self.resultView = nil
                fulfill(.success(()))
            })
        }
    }
    
}
