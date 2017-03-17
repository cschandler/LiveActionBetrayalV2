//
//  Attribute.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/17/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import Foundation
import UIKit

struct Attribute {
    let name: String
    let color: UIColor
    let speed: Stat
    let might: Stat
    let sanity: Stat
    let knowledge: Stat
}

struct Stat {
    let values: [Int]
    let startingPosition: Int
}

var attributes: [Attribute] {
    let powerful = Attribute(name: "Powerful",
                           color: .red,
                           speed: Stat(values: [2, 2, 2, 3, 4, 5, 5, 6], startingPosition: 5),
                           might: Stat(values: [4, 5, 5, 6, 6, 7, 8, 8], startingPosition: 3),
                           sanity: Stat(values: [2, 3, 4, 5, 5, 6, 7], startingPosition: 3),
                           knowledge: Stat(values: [2, 2, 3, 3, 5, 5, 6, 6], startingPosition: 3))
    
    let quick = Attribute(name: "Quick",
                         color: .red,
                         speed: Stat(values: [4, 4, 4, 5, 6, 7, 7, 8], startingPosition: 5),
                         might: Stat(values: [2, 3, 3, 4, 5, 6, 6, 7], startingPosition: 3),
                         sanity: Stat(values: [1, 2, 3, 4, 5, 5, 5, 7], startingPosition: 3),
                         knowledge: Stat(values: [2, 3, 3, 4, 5, 5, 5, 7], startingPosition: 3))
    
    let psychic = Attribute(name: "Psychic",
                            color: .cyan,
                            speed: Stat(values: [2, 3, 3, 5, 5, 6, 6, 7], startingPosition: 3),
                            might: Stat(values: [2, 3, 3, 4, 5, 5, 5, 6], startingPosition: 4),
                            sanity: Stat(values: [4, 4, 4, 5, 6, 7, 8, 8], startingPosition: 3),
                            knowledge: Stat(values: [1, 3, 4, 4, 4, 5, 6, 6], startingPosition: 4))
    
    let bookish = Attribute(name: "Bookish",
                            color: .cyan,
                            speed: Stat(values: [3, 4, 4, 4, 4, 6, 7, 8], startingPosition: 4),
                            might: Stat(values: [2, 2, 2, 4, 4, 5, 6, 6], startingPosition: 3),
                            sanity: Stat(values: [4, 4, 4, 5, 6, 7, 8, 8], startingPosition: 3),
                            knowledge: Stat(values: [4, 5, 5, 5, 5, 6, 6, 7], startingPosition: 4))
    
    let sporty = Attribute(name: "Sporty",
                             color: .magenta,
                             speed: Stat(values: [2, 3, 4, 4, 4, 5, 6, 8], startingPosition: 4),
                             might: Stat(values: [3, 4, 4, 4, 4, 5, 6, 6], startingPosition: 3),
                             sanity: Stat(values: [1, 1, 2, 4, 4, 4, 5, 6], startingPosition: 5),
                             knowledge: Stat(values: [2, 3, 3, 4, 4, 5, 6, 8], startingPosition: 3))
    
    let social = Attribute(name: "Social",
                           color: .magenta,
                           speed: Stat(values: [3, 3, 4, 5, 6, 6, 7, 8], startingPosition: 3),
                           might: Stat(values: [3, 3, 3, 4, 5, 6, 7, 8], startingPosition: 3),
                           sanity: Stat(values: [3, 3, 3, 4, 5, 6, 6, 6], startingPosition: 3),
                           knowledge: Stat(values: [2, 3, 3, 4, 5, 6, 7, 8], startingPosition: 5))
    
    let nimble = Attribute(name: "Nimble",
                           color: .green,
                           speed: Stat(values: [3, 4, 4, 4, 5, 6, 7, 8], startingPosition: 3),
                           might: Stat(values: [2, 3, 3, 4, 5, 6, 6, 7], startingPosition: 4),
                           sanity: Stat(values: [3, 3, 3, 4, 5, 6, 7, 8], startingPosition: 4),
                           knowledge: Stat(values: [1, 3, 3, 5, 5, 6, 6, 7], startingPosition: 3))
    
    let adventurous = Attribute(name: "Adventurous",
                                color: .green,
                                speed: Stat(values: [3, 3, 3, 4, 6, 6, 7, 7], startingPosition: 4),
                                might: Stat(values: [2, 3, 3, 4, 5, 5, 6, 6], startingPosition: 3),
                                sanity: Stat(values: [3, 4, 4, 4, 5, 6, 6, 7], startingPosition: 4),
                                knowledge: Stat(values: [3, 4, 4, 5, 6, 7, 7, 8], startingPosition: 3))
    
    let playful = Attribute(name: "Playful",
                            color: .yellow,
                            speed: Stat(values: [4, 4, 4, 4, 5, 6, 8, 8], startingPosition: 4),
                            might: Stat(values: [2, 2, 3, 3, 4, 4, 6, 7], startingPosition: 4),
                            sanity: Stat(values: [3, 4, 5, 5, 6, 6, 7, 8], startingPosition: 3),
                            knowledge: Stat(values: [1, 2, 3, 4, 4, 5, 5, 5], startingPosition: 3))
    
    let helpful = Attribute(name: "Helpful",
                            color: .yellow,
                            speed: Stat(values: [3, 4, 5, 6, 6, 6, 7, 7], startingPosition: 3),
                            might: Stat(values: [2, 3, 3, 3, 4, 5, 6, 7], startingPosition: 4),
                            sanity: Stat(values: [1, 2, 3, 4, 5, 5, 6, 7], startingPosition: 3),
                            knowledge: Stat(values: [2, 3, 4, 4, 5, 6, 6, 6], startingPosition: 4))
    
    let pious = Attribute(name: "Pious",
                          color: .white,
                          speed: Stat(values: [2, 3, 3, 4, 5, 6, 7, 7], startingPosition: 3),
                          might: Stat(values: [1, 2, 2, 4, 4, 5, 5, 7], startingPosition: 4),
                          sanity: Stat(values: [3, 4, 5, 5, 6, 7, 7, 8], startingPosition: 5),
                          knowledge: Stat(values: [1, 3, 3, 4, 5, 6, 6, 8], startingPosition: 4))
    
    let erudite = Attribute(name: "Erudite",
                            color: .yellow,
                            speed: Stat(values: [2, 2, 4, 4, 5, 5, 6, 6], startingPosition: 4),
                            might: Stat(values: [1, 2, 3, 4, 5, 5, 6, 6], startingPosition: 3),
                            sanity: Stat(values: [1, 3, 3, 4, 5, 5, 6, 7], startingPosition: 3),
                            knowledge: Stat(values: [4, 5 ,5, 5, 5, 6, 7, 8], startingPosition: 5))
    
    return [powerful, quick, psychic, bookish, sporty, social, nimble, adventurous, playful, helpful, pious, erudite]
}
