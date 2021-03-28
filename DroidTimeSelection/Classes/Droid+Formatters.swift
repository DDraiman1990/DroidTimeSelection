//
//  Droid+Formatters.swift
//  DroidTimeSelection
//
//  Created by Dan Draiman on 3/21/21.
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
}
