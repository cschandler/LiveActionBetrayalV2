//
//  ChoosePictureViewController.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/24/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

final class ChoosePictureViewController: BaseViewController {
    
    @IBOutlet weak var picture: UIImageView!
    
    var metadata: PlayerMetadata?
}

extension ChoosePictureViewController: MainMenuType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "PICTURE"
        
        setupView()
        picture.layer.borderWidth = 4.0
        picture.layer.borderColor = UIColor.gray.cgColor
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        picture.layer.cornerRadius = (picture.bounds.width / 2)
        
    }
}
