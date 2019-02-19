//
//  DiceViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/27/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
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
        
        let frame = CGRect(x: view.center.x - (width / 2),
                           y: view.center.y - (height / 2),
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let xButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ic-clear"), style: .plain, target: self, action: #selector(dismissSelf))
        xButton.tintColor = .white
        
        navigationItem.setRightBarButton(xButton, animated: true)

        UIView.animate(withDuration: 0.3, animations: { 
            self.blurView.effect = UIBlurEffect(style: .dark)
        })
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
