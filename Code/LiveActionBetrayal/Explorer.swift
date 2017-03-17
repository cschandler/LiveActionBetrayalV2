//
//  Explorer.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/17/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

struct Explorer {
    let attribute: Attribute
    let name: String
    let picture: UIImage = #imageLiteral(resourceName: "ic-avatar-default")
//    var items: [Item]  TODO
    var isTraitor: Bool
    var isDead: Bool
}
