//
//  DroidTimeFormat.swift
//  DroidTimeSelection
//
//  Created by Dan Draiman on 7/25/20.
//  Copyright © 2020 Nexxmark Studio. All rights reserved.
//

import Foundation

/// The time format you want the selectors to present.
/// - twentyFour - 24h format. Example: 9am is 9:00. 9pm is 21:00.
/// - twelve - 12h format. AM and PM. 9:00 is 9am and 21:00 is 9pm.
public enum DroidTimeFormat {
    case twentyFour, twelve
}
