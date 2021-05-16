//
//  Droid+Time.swift
//  DroidTimeSelection
//
//  Created by Dan Draiman on 7/26/20.
//  Copyright © 2020 Nexxmark Studio. All rights reserved.
//

import Foundation

public struct Time: Equatable {
    public var timeInterval: TimeInterval {
        return TimeInterval(
            twentyFourHoursFormat.hours * 3600
            + twentyFourHoursFormat.minutes * 60
                + twentyFourHoursFormat.seconds)
    }
    public var twelveHoursFormat: TimeOfDay = .init(am: true)
    public var twentyFourHoursFormat: TimeOfDay = .init()
    
    public init(twelveHoursFormat: TimeOfDay = .init(am: true),
                twentyFourHoursFormat: TimeOfDay = .init()) {
        self.twentyFourHoursFormat = twentyFourHoursFormat
        self.twelveHoursFormat = twelveHoursFormat
    }
    
    public func timeIntervalSince1970(relativeTo date: Date) -> TimeInterval? {
        return self.date(relativeTo: date)?.timeIntervalSince1970
    }
    
    public func date(relativeTo date: Date) -> Date? {
        return Calendar.current.date(
            bySettingHour: twentyFourHoursFormat.hours,
            minute: twentyFourHoursFormat.minutes,
            second: twentyFourHoursFormat.seconds,
            of: date)
    }
    
    public mutating func set(hour: Int, minutes: Int, seconds: Int) {
        let isAm = hour <= 12
        twelveHoursFormat.am = isAm
        twelveHoursFormat.hours = isAm ? hour : hour - 12
        twelveHoursFormat.minutes = minutes
        twelveHoursFormat.seconds = seconds
        
        twentyFourHoursFormat.am = nil
        twelveHoursFormat.hours = hour
        twelveHoursFormat.minutes = minutes
        twelveHoursFormat.seconds = seconds
    }
}

public struct TimeOfDay: Equatable {
    public var hours: Int = 0
    public var minutes: Int = 0
    public var seconds: Int = 0
    public var am: Bool?
    
    public init(hours: Int = 0,
                minutes: Int = 0,
                seconds: Int = 0,
                am: Bool? = nil) {
        self.hours = hours
        self.minutes = minutes
        self.am = am
    }
}
