//
//  DroidTimeSelectionMode.swift
//  DroidTimeSelection
//
//  Created by Dan Draiman on 3/28/21.
//  Copyright © 2020 Nexxmark Studio. All rights reserved.
//

import Foundation

public enum TimeSelectionMode {
    case picker, clock
    
    mutating func toggle() {
        switch self {
        case .clock:
            self = .picker
        case .picker:
            self = .clock
        }
    }
}
