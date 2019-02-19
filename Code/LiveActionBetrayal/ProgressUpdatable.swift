//
//  ProgressUpdatable.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 7/20/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit
import FirebaseStorage

protocol ProgressUpdatable: class {
    var progressView: UIProgressView! { get }
}

extension ProgressUpdatable where Self: UIViewController {
    
    func updateProgress(forTask task: StorageUploadTask) {
        progressView.setProgress(0, animated: false)
        
        UIView.animate(withDuration: 0.3) {
            self.progressView.alpha = 1.0
        }
        
        task.observe(.progress) { snapshot in
            guard let progress = snapshot.progress else {
                return
            }
            
            let value = Float(progress.fractionCompleted)
            
            DispatchQueue.main.async {
                if !self.progressView.isHidden {
                    self.progressView.setProgress(value, animated: true)
                }
                
                if value == 1.0 {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.progressView.alpha = 0
                    })
                }
            }
        }
    }
    
}
