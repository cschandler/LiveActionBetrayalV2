//
//  MainMenuType.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/22/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

protocol MainMenuType: Themeable {}

extension MainMenuType where Self: BaseViewController {
    
    var theme: Theme {
        return Theme(background: #imageLiteral(resourceName: "img-intro-cropped"),
                     dark: "1C2B2C",
                     mid: "76C38D",
                     light: "D6C3B1",
                     bright: "4BC484",
                     dim: "598C6E")
    }

}
