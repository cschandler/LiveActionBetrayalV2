//
//  Lens.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 7/20/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import Foundation

public struct Lens<A,B> {
    
    public let from: (A) -> B
    public let to: (B, A) -> A
    
    public init(from: @escaping (A) -> B, to: @escaping (B, A) -> A) {
        self.from = from
        self.to = to
    }
    
}
