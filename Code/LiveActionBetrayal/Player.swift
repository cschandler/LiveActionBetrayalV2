//
//  Explorer.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/17/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

protocol PlayerType {
    var identifier: String { get }
}

struct Explorer: PlayerType {
    let identifier: String
    let name: String
    var attribute: Attribute
    var picture: UIImage = #imageLiteral(resourceName: "ic-avatar-default")

    //    var items: [Item]  TODO
    var isTraitor: Bool = false
    var isDead: Bool = false
    var torchOn: Bool = false
}
