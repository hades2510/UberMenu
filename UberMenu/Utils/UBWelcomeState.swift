//
//  UBWelcomeState.swift
//  UberMenu
//
//  Created by Mac on 07/01/16.
//  Copyright © 2016 samuraibonzai. All rights reserved.
//

import Foundation

enum UBWelcomeState: CustomStringConvertible{
    
    case BLTurnedOff
    case StartedSearch
    case MenuFound
    case ReadingMenu
    case MenuReceived
    
    var description:String {
        switch self{
        case .BLTurnedOff:
            return "BlueTooth is turned off"
        case .StartedSearch:
            return "Looking for UberMenus"
        case .MenuFound:
            return "UberMenu found near you"
        case .ReadingMenu:
            return "Reading UberMenu"
        case .MenuReceived:
            return "UberMenu available"
        }
    }
}