//
//  Droid+Formatters.swift
//  DroidTimeSelection
//
//  Created by Dan Draiman on 3/21/21.
//  Copyright © 2020 Nexxmark Studio. All rights reserved.
//

import Foundation

internal enum Formatters {
    internal static let cellTimeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour]
        formatter.zeroFormattingBehavior = .pad //Depending on AM or PM
        return formatter
    }()

    internal static let hourFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour]
        formatter.zeroFormattingBehavior = .default //Depending on AM or PM
        return formatter
    }()

    internal static let minutesFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute]
        formatter.zeroFormattingBehavior = .pad //Depending on AM or PM
        return formatter
    }()
    internal static let secondsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second]
        formatter.zeroFormattingBehavior = .pad //Depending on AM or PM
        return formatter
    }()
}
