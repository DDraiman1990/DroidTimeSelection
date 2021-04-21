//
//  DroidTimeSelector.swift
//  DroidTimeSelection
//
//  Created by Dan Draiman on 3/22/21.
//  Copyright © 2020 Nexxmark Studio. All rights reserved.
//

import Foundation

public protocol DroidTimeSelector: UIView {
    var onSelectionChanged: ((Time) -> Void)? { get set }
    var time: Time { get }
    var timeFormat: DroidTimeFormat { get set }
    var showSeconds: Bool { get set }
    
    /// Set the current time selection to the given parameters.
    /// - Parameters:
    ///   - hour: the hour number.
    ///   - minutes: the amount of minutes.
    ///   - seconds: the amount of seconds.
    ///   - am: if time is am/pm or nil for 24 hours format.
    func set(hour: Int, minutes: Int, seconds: Int, am: Bool?)
    
    /// Set the current time selection to the given parameters.
    /// - Parameter time: Time representing the time selection.
    func set(time: Time)
    
    /// Reset the component. Sets time to 00:00 or 12am.
    func reset()
}

extension DroidTimeSelector {
    /// Set the current time selection to the given parameters.
    /// - Parameters:
    ///   - hour: the hour number.
    ///   - minutes: the amount of minutes.
    ///   - am: if time is am/pm or nil for 24 hours format.
    func set(hour: Int, minutes: Int, am: Bool?) {
        self.set(hour: hour, minutes: minutes, seconds: 0, am: am)
    }
}

/// A time selector showing a time indicator along with a physical clock to
/// give user the ability to manually select the time using an intuitive way.
///
/// Set the callback `onSelectionChanged` to get updates from this component.
///
/// This is the same UI presented in Android phones.
/// - Change `timeFormat` to change the selection mode for the selector.
/// - Change `style` to change the style of the selectors and the menu. See `ClockStyle` for more details about possible styling.
public protocol ClockTimeSelector: DroidTimeSelector {
    var style: ClockStyle { get set }
    var onSelectionEnded: ((Time) -> Void)? { get set }
}

/// A time selector showing a UIPickerView allowing the native pre-iOS 14 picker
/// style selection.
///
/// Set the callback `onSelectionChanged` to get updates from this component.
///
/// - Change `timeFormat` to change the selection mode for the selector.
/// - Change `style` to change the style of the selectors and the menu. See `PickerStyle` for more details about possible styling.
public protocol PickerTimeSelector: DroidTimeSelector {
    var style: PickerStyle { get set }
}

/// A Hybrid version of the selector.
///
/// Displays both versions of the selector.
/// Default mode is Clock selection.
///
/// Set the callbacks for `onOkTapped`, `onCancelTapped` and `onSelectionChanged`
/// to get updates from this component.
///
/// - Change `timeFormat` to change the selection mode for both selectors.
/// - Change `style` to change the style of the selectors and the menu. See `HybridStyle`, `ClockStyle` and `PickerStyle` for more details about possible styling.
public protocol HybridTimeSelector: DroidTimeSelector {
    var style: HybridStyle { get set }
    var mode: TimeSelectionMode { get set }
}
