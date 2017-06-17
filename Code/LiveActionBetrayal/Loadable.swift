//
//  Loadable.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 6/17/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import Foundation

public enum Loadable<T> {
    case notAsked
    case loading
    case loaded(T)
    case error(Error)
    
    var value: T? {
        switch self {
        case .loaded(let type):
            return type
        default:
            return nil
        }
    }
}
