//
//  PlayerMetadata.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/23/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

struct PlayerMetadata {
    var name: String
    var attribute: Attribute?
    var picture: UIImage?
    
    init(name: String) {
        self.name = name
        self.attribute = nil
        self.picture = nil
    }
}
