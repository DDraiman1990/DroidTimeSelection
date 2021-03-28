//
//  DroidTimeSelectionMode.swift
//  DroidTimeSelection
//
//  Created by Dan Draiman on 3/28/21.
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
