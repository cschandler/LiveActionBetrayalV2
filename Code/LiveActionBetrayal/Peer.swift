//
//  Explorer.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/17/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

protocol PeerType {
    var name: String { get set }
    var picture: UIImage { get set }
}

extension PeerType {
    
    func toJSON() -> JSON {
        return [
            "name": name as AnyObject,
            "pictureData": UIImagePNGRepresentation(picture) as AnyObject
        ]
    }

    static func parseName(json: [String:AnyObject]) throws -> String {
        guard let name = json["name"] as? String else {
            throw SerializationError.missing("name")
        }
        
        return name
    }
    
    static func parsePicture(json: [String:AnyObject]) throws -> UIImage {
        guard let data = json["pictureData"] as? Data else {
            throw SerializationError.missing("pictureData")
        }
        
        guard let picture = UIImage(data: data) else {
            throw SerializationError.corrupted("pictureData")
        }
        
        return picture
    }
}

class Peer: PeerType {
    var name: String // Equivilent to the MCPeerID displayName property
    var picture: UIImage = #imageLiteral(resourceName: "ic-avatar-default")
    
    init(name: String, picture: UIImage?) {
        self.name = name
        if let picture = picture {
            self.picture = picture
        }
    }
    
    convenience init(json: JSON) throws {
        let name = try Peer.parseName(json: json)
        let picture = try Peer.parsePicture(json: json)
        self.init(name: name, picture: picture)
    }
}

final class Explorer: Peer {
    var attribute: Attribute?
    //    var items: [Item]  TODO
    var isTraitor: Bool = false
    var isDead: Bool = false
}
