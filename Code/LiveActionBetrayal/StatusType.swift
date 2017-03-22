//
//  StatusType.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/22/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import Foundation

protocol StatusType: Themeable {}

extension StatusType where Self: BaseViewController {
    
    var theme: Theme {
        return Theme(background: #imageLiteral(resourceName: "img-water"),
                     dark: "03080C",
                     mid: "053E59",
                     light: "075277",
                     bright: "3AB9EC",
                     dim: "03283A")
    }
    
}
