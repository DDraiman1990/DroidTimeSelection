//
//  DroidFactory.swift
//  DroidTimeSelection
//
//  Created by Dan Draiman on 3/21/21.
//

import Foundation

public enum DroidFactory {
    public enum Hybrid {
        public static func view(
            timeFormat: DroidTimeFormat = .twentyFour,
            style: HybridStyle = .init()) -> DroidHybridSelector {
            let selector = DroidHybridSelector()
            selector.timeFormat = timeFormat
            selector.style = style
            return selector
        }
        
        public static func viewController(
            timeFormat: DroidTimeFormat = .twentyFour,
            style: HybridStyle = .init()) -> HybridDroidViewController {
            let selector = Hybrid.view(timeFormat: timeFormat, style: style)
            return HybridDroidViewController(selector: selector)
        }
    }
    
    public enum Clock {
        public static func view(
            timeFormat: DroidTimeFormat = .twentyFour,
            style: ClockStyle = .init()) -> DroidClockSelector {
            let selector = DroidClockSelector()
            selector.timeFormat = timeFormat
            selector.style = style
            return selector
        }
        
        public static func viewController(
            timeFormat: DroidTimeFormat = .twentyFour,
            style: ClockStyle = .init()) -> ClockDroidViewController {
            let selector = Clock.view(timeFormat: timeFormat, style: style)
            return ClockDroidViewController(selector: selector)
        }
    }
    
    public enum Picker {
        public static func view(
            timeFormat: DroidTimeFormat = .twentyFour,
            style: PickerStyle = .init()) -> DroidPickerSelector {
            let selector = DroidPickerSelector()
            selector.timeFormat = timeFormat
            selector.style = style
            return selector
        }
        
        public static func viewController(
            timeFormat: DroidTimeFormat = .twentyFour,
            style: PickerStyle = .init()) -> PickerDroidViewController {
            let selector = Picker.view(timeFormat: timeFormat, style: style)
            return PickerDroidViewController(selector: selector)
        }
    }
}
