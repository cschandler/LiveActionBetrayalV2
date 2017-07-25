//
//  IDs.swift
//  LiveActionBetrayal
//
//  Created by Charles Chandler on 3/17/17.
//  Copyright © 2017 Charles Chander. All rights reserved.
//

import Foundation

enum IDs {
    enum Storyboards: String {
        case Status
        case Explorer
        case Watcher
    }
    
    enum Cells: String {
        case PeerCell
        case AttributeCell
        case CardCell
        case ExplorerCell
        case LightsCell
        case SetHauntCell
        case HauntPickerButtonCell
    }
    
    enum Segues: String {
        case NameToAttributes
        case AttributeToPicture
        case TransitionToExplorer
        case LightsSettings
        case MessagesMasterToDetail
    }
    
    enum StoryboardViewControllers: String {
        case LightsSettingsViewController
        case AddCardViewController
        case CardDetailViewController
        case TraitorPickerViewController
    }
}
