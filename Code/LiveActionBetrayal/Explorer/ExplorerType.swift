//
//  ExplorerType.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/26/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

protocol ExplorerType: Themeable {}

extension ExplorerType {
    
    var theme: Theme {
        return Theme(background: #imageLiteral(resourceName: "img-explorer"),
                     dark: "1C2B2C",
                     mid: "76C38D",
                     light: "D6C3B1",
                     bright: "4BC484",
                     dim: "598C6E")
    }
    
}
