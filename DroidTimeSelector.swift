//
//  DroidTimeSelector.swift
//  DroidTimeSelection
//
//  Created by Dan Draiman on 3/22/21.
//

import Foundation

public protocol DroidTimeSelector {
    var onSelectionChanged: ((Time) -> Void)? { get set }
    var time: Time { get }
    var timeFormat: DroidTimeFormat { get set }
    
    /// Set the current time selection to the given parameters.
    /// - Parameters:
    ///   - hour: the hour number.
    ///   - minutes: the amount of minutes.
    ///   - am: if time is am/pm or nil for 24 hours format.
    func set(hour: Int, minutes: Int, am: Bool?)
    
    /// Set the current time selection to the given parameters.
    /// - Parameter time: Time representing the time selection.
    func set(time: Time)
    
    /// Reset the component. Sets time to 00:00 or 12am.
    func reset()
}

public protocol ClockTimeSelector: DroidTimeSelector {
    var style: ClockStyle { get set }
}
public protocol PickerTimeSelector: DroidTimeSelector {
    var style: PickerStyle { get set }
}
public protocol HybridTimeSelector: DroidTimeSelector {
    var style: HybridStyle { get set }
}
