//
//  Attribute.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/17/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import UIKit

enum StatType {
    case speed, might, sanity, knowledge
}

struct Attribute {
    let name: String
    let color: UIColor
    
    var speed: Stat
    var might: Stat
    var sanity: Stat
    var knowledge: Stat
    
    var stats: [Stat] {
        return [speed, might, sanity, knowledge]
    }
    
    mutating func update(value: Position, forStatType type: StatType) {
        switch type {
        case .speed:
            speed.current = value
        case .might:
            might.current = value
        case .sanity:
            sanity.current = value
        case .knowledge:
            knowledge.current = value
        }
    }
}

typealias StatValue = Int
typealias Position = Int

struct Stat {
    
    let type: StatType
    let values: [StatValue]
    let starting: Position
    var current: Position
    
    init(type: StatType, values: [StatValue], starting: Position) {
        assert(values.count == 8, "Stats should have 8 values.")
        
        self.type = type
        self.values = values
        self.starting = starting
        self.current = starting
    }
    
    func value(for position: Position) -> StatValue {
        return values[position - 1]
    }
    
    var currentValue: Int {
        return value(for: current)
    }
    
    func toString() -> String {
        var string = ""
        
        for (index, value) in values.enumerated() {
            if index == starting {
                string.append(" (\(value))")
            } else {
                string.append(" \(value)")
            }
        }
        
        return string
    }
}

struct Attributes {
    
    static var attributes: [Attribute] {
        let powerful = Attribute(name: "Powerful",
                                 color: .red,
                                 speed: Stat(type: .speed, values: [2, 2, 2, 3, 4, 5, 5, 6], starting: 2),
                                 might: Stat(type: .might, values: [4, 5, 5, 6, 6, 7, 8, 8], starting: 4),
                                 sanity: Stat(type: .sanity, values: [2, 2, 3, 4, 5, 5, 6, 7], starting: 2),
                                 knowledge: Stat(type: .knowledge, values: [2, 2, 3, 3, 5, 5, 6, 6], starting: 2))
        
        let quick = Attribute(name: "Quick",
                              color: .red,
                              speed: Stat(type: .speed, values: [4, 4, 4, 5, 6, 7, 7, 8], starting: 4),
                              might: Stat(type: .might, values: [2, 3, 3, 4, 5, 6, 6, 7], starting: 2),
                              sanity: Stat(type: .sanity, values: [1, 2, 3, 4, 5, 5, 5, 7], starting: 2),
                              knowledge: Stat(type: .knowledge, values: [2, 3, 3, 4, 5, 5, 5, 7], starting: 2))
        
        let psychic = Attribute(name: "Psychic",
                                color: .cyan,
                                speed: Stat(type: .speed, values: [2, 3, 3, 5, 5, 6, 6, 7], starting: 2),
                                might: Stat(type: .might, values: [2, 3, 3, 4, 5, 5, 5, 6], starting: 3),
                                sanity: Stat(type: .sanity, values: [4, 4, 4, 5, 6, 7, 8, 8], starting: 2),
                                knowledge: Stat(type: .knowledge, values: [1, 3, 4, 4, 4, 5, 6, 6], starting: 3))
        
        let bookish = Attribute(name: "Bookish",
                                color: .cyan,
                                speed: Stat(type: .speed, values: [3, 4, 4, 4, 4, 6, 7, 8], starting: 3),
                                might: Stat(type: .might, values: [2, 2, 2, 4, 4, 5, 6, 6], starting: 2),
                                sanity: Stat(type: .sanity, values: [4, 4, 4, 5, 6, 7, 8, 8], starting: 2),
                                knowledge: Stat(type: .knowledge, values: [4, 5, 5, 5, 5, 6, 6, 7], starting: 3))
        
        let sporty = Attribute(name: "Sporty",
                               color: .magenta,
                               speed: Stat(type: .speed, values: [2, 3, 4, 4, 4, 5, 6, 8], starting: 3),
                               might: Stat(type: .might, values: [3, 4, 4, 4, 4, 5, 6, 6], starting: 2),
                               sanity: Stat(type: .sanity, values: [1, 1, 2, 4, 4, 4, 5, 6], starting: 4),
                               knowledge: Stat(type: .knowledge, values: [2, 3, 3, 4, 4, 5, 6, 8], starting: 2))
        
        let social = Attribute(name: "Social",
                               color: .magenta,
                               speed: Stat(type: .speed, values: [3, 3, 4, 5, 6, 6, 7, 8], starting: 2),
                               might: Stat(type: .might, values: [3, 3, 3, 4, 5, 6, 7, 8], starting: 2),
                               sanity: Stat(type: .sanity, values: [3, 3, 3, 4, 5, 6, 6, 6], starting: 2),
                               knowledge: Stat(type: .knowledge, values: [2, 3, 3, 4, 5, 6, 7, 8], starting: 4))
        
        let nimble = Attribute(name: "Nimble",
                               color: .green,
                               speed: Stat(type: .speed, values: [3, 4, 4, 4, 5, 6, 7, 8], starting: 2),
                               might: Stat(type: .might, values: [2, 3, 3, 4, 5, 6, 6, 7], starting: 3),
                               sanity: Stat(type: .sanity, values: [3, 3, 3, 4, 5, 6, 7, 8], starting: 3),
                               knowledge: Stat(type: .knowledge, values: [1, 3, 3, 5, 5, 6, 6, 7], starting: 2))
        
        let adventurous = Attribute(name: "Adventurous",
                                    color: .green,
                                    speed: Stat(type: .speed, values: [3, 3, 3, 4, 6, 6, 7, 7], starting: 3),
                                    might: Stat(type: .might, values: [2, 3, 3, 4, 5, 5, 6, 6], starting: 2),
                                    sanity: Stat(type: .sanity, values: [3, 4, 4, 4, 5, 6, 6, 7], starting: 3),
                                    knowledge: Stat(type: .knowledge, values: [3, 4, 4, 5, 6, 7, 7, 8], starting: 2))
        
        let playful = Attribute(name: "Playful",
                                color: .yellow,
                                speed: Stat(type: .speed, values: [4, 4, 4, 4, 5, 6, 8, 8], starting: 3),
                                might: Stat(type: .might, values: [2, 2, 3, 3, 4, 4, 6, 7], starting: 3),
                                sanity: Stat(type: .sanity, values: [3, 4, 5, 5, 6, 6, 7, 8], starting: 2),
                                knowledge: Stat(type: .knowledge, values: [1, 2, 3, 4, 4, 5, 5, 5], starting: 2))
        
        let helpful = Attribute(name: "Helpful",
                                color: .yellow,
                                speed: Stat(type: .speed, values: [3, 4, 5, 6, 6, 6, 7, 7], starting: 2),
                                might: Stat(type: .might, values: [2, 3, 3, 3, 4, 5, 6, 7], starting: 3),
                                sanity: Stat(type: .sanity, values: [1, 2, 3, 4, 5, 5, 6, 7], starting: 2),
                                knowledge: Stat(type: .knowledge, values: [2, 3, 4, 4, 5, 6, 6, 6], starting: 3))
        
        let pious = Attribute(name: "Pious",
                              color: .white,
                              speed: Stat(type: .speed, values: [2, 3, 3, 4, 5, 6, 7, 7], starting: 2),
                              might: Stat(type: .might, values: [1, 2, 2, 4, 4, 5, 5, 7], starting: 3),
                              sanity: Stat(type: .sanity, values: [3, 4, 5, 5, 6, 7, 7, 8], starting: 4),
                              knowledge: Stat(type: .knowledge, values: [1, 3, 3, 4, 5, 6, 6, 8], starting: 3))
        
        let erudite = Attribute(name: "Erudite",
                                color: .white,
                                speed: Stat(type: .speed, values: [2, 2, 4, 4, 5, 5, 6, 6], starting: 3),
                                might: Stat(type: .might, values: [1, 2, 3, 4, 5, 5, 6, 6], starting: 2),
                                sanity: Stat(type: .sanity, values: [1, 3, 3, 4, 5, 5, 6, 7], starting: 2),
                                knowledge: Stat(type: .knowledge, values: [4, 5 ,5, 5, 5, 6, 7, 8], starting: 4))
        
        return [powerful, quick, psychic, bookish, sporty, social, nimble, adventurous, playful, helpful, pious, erudite]
    }
    
    static func withName(name: String) -> Attribute? {
        for attribute in attributes {
            if attribute.name == name {
                return attribute
            }
        }
        return nil
    }
    
    static var count: Int {
        return attributes.count
    }
    
    static func atIndexPath(row: Int) -> Attribute {
        return attributes[row]
    }

}


