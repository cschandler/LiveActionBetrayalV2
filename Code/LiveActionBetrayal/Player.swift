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
    var cards: [Card] = []
    var isTraitor: Bool = false
    var isDead: Bool = false
    var torchOn: Bool = false
    
    var metadata: PlayerMetadata {
        var metadata = PlayerMetadata(name: name)
        metadata.attribute = attribute
        metadata.picture = picture
        return metadata
    }
    
    public static let pictureLens = Lens<Explorer, UIImage>(from: { $0.picture }) { (image, explorer)  in
        var explorer = explorer
        
        explorer.picture = image
        
        return explorer
    }
    
    init?(json: JSON) {
        guard let uid = json["uid"] as? String,
            let name = json["name"] as? String,
            let attributeName = json["attribute"] as? String,
            let torch = json["torch"] as? Bool,
            let traitor = json["traitor"] as? Bool,
            let attribute = Attributes.withName(name: attributeName),
            let dead = json["dead"] as? Bool,
            let might = json["might"] as? Int,
            let speed = json["speed"] as? Int,
            let knowledge = json["knowledge"] as? Int,
            let sanity = json["sanity"] as? Int else {
                print("Player deserialization failed")
                return nil
        }
        
        self.identifier = uid
        self.name = name
        self.attribute = attribute
        self.torchOn = torch
        self.isTraitor = traitor
        self.isDead = dead
        self.attribute.might.current = might
        self.attribute.speed.current = speed
        self.attribute.knowledge.current = knowledge
        self.attribute.sanity.current = sanity
    }
    
    func toJSON() -> JSON {
        let values: JSON = [
            "uid": identifier as NSString,
            "name": name as NSString,
            "attribute": attribute.name as NSString,
            "torch": torchOn as AnyObject,
            "traitor": isTraitor as AnyObject,
            "dead": isDead as AnyObject,
            "might": attribute.might.current as NSNumber,
            "speed": attribute.speed.current as NSNumber,
            "knowledge": attribute.knowledge.current as NSNumber,
            "sanity": attribute.sanity.current as NSNumber
        ]
        
        return values
    }

}

struct Watcher: PlayerType {
    
    let identifier: String
    
}
