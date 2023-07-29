//
//  TransitionViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/26/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import FirebaseStorage

final class TransitionViewController: BaseViewController, ProgressUpdatable {
    
    required init(image: UIImage?, storyboardIdentifier: String, transitionType type: TransitionType) {
        self.backgroundImage = image
        self.storyboardIdentifier = storyboardIdentifier
        self.type = type
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let storyboardIdentifier: String
    let backgroundImage: UIImage?
    let type: TransitionType
    
    var uploadTask: StorageUploadTask? {
        didSet {
            guard let task = uploadTask else {
                return
            }
            
            updateProgress(forTask: task)
        }
    }
    
    var progressView: UIProgressView! {
        didSet {
            view.addSubview(progressView)
            progressView.translatesAutoresizingMaskIntoConstraints = false
            progressView.alpha = 0.0
            progressView.tintColor = UIColor(hex: "76C38D")
            progressView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20.0).isActive = true
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            progressView.heightAnchor.constraint(equalToConstant: 5.0).isActive = true
        }
    }
    
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
    
    func transitionToPlayer(withMetadata metadata: PlayerMetadata) {
        guard let vc = UIStoryboard(name: storyboardIdentifier, bundle: nil).instantiateInitialViewController() else { return }
        
        if let explorer = vc as? ExplorerTabController {
            explorer.metadata = metadata
            explorer.modalPresentationStyle = .fullScreen
        }
        
        present(vc, animated: true, completion: nil)
    }
    
    func transitionToWatcher() {
        guard let vc = UIStoryboard(name: storyboardIdentifier, bundle: nil).instantiateInitialViewController() else { return }
        if let watcher = vc as? WatcherTabController {
            watcher.modalPresentationStyle = .fullScreen
        }
        present(vc, animated: true, completion: nil)
    }
    
}

extension TransitionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView(image: backgroundImage)
        progressView = UIProgressView(frame: .zero)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        switch type {
        case .newGame(let metadata):
            ConnectionManager.shared.addPlayer(withMetadata: metadata, percentageReporter: { [weak self] uploadTask in
                self?.uploadTask = uploadTask
            })
                .onSuccess {
                    DispatchQueue.main.async { self.transitionToPlayer(withMetadata: metadata) }
                }
                .onFailure { error in
                    if let serializationError = error as? SerializationError {
                        switch serializationError {
                        case .missing("Picture"):
                            DispatchQueue.main.async { self.transitionToPlayer(withMetadata: metadata) }
                            return
                        default:
                            break
                        }
                    }
                    
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                .call()
            
        case .continueGame(let metadata):
            transitionToPlayer(withMetadata: metadata)
            
        case .watcher:
            ConnectionManager.shared.logWatcherIn()
                .onSuccess {
                    DispatchQueue.main.async { self.transitionToWatcher() }
                }
                .onFailure { error in
                    print("LOG IN WATCHER ERROR")
                    print(error)
                }
                .call()
        }
    }
    
}

enum TransitionType {
    case newGame(PlayerMetadata)
    case continueGame(PlayerMetadata)
    case watcher
}
