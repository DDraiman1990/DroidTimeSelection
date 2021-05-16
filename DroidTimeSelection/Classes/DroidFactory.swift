//
//  DroidFactory.swift
//  DroidTimeSelection
//
//  Created by Dan Draiman on 3/21/21.
//  Copyright © 2020 Nexxmark Studio. All rights reserved.
//

import Foundation

public enum DroidFactory {
    public enum Hybrid {
        public static func view(
            timeFormat: DroidTimeFormat = .twentyFour,
            enableSeconds: Bool = false,
            style: HybridStyle = .init()) -> DroidHybridSelector {
            let selector = DroidHybridSelector()
            selector.timeFormat = timeFormat
            selector.style = style
            selector.enableSeconds = enableSeconds
            return selector
        }
        
        public static func viewController(
            timeFormat: DroidTimeFormat = .twentyFour,
            enableSeconds: Bool = false,
            style: HybridStyle = .init()) -> HybridDroidViewController {
            let selector = Hybrid.view(
                timeFormat: timeFormat,
                enableSeconds: enableSeconds,
                style: style)
            return HybridDroidViewController(selector: selector)
        }
    }
    
    public enum Clock {
        public static func view(
            timeFormat: DroidTimeFormat = .twentyFour,
            enableSeconds: Bool = false,
            style: ClockStyle = .init()) -> DroidClockSelector {
            let selector = DroidClockSelector()
            selector.timeFormat = timeFormat
            selector.style = style
            selector.enableSeconds = enableSeconds
            return selector
        }
    }
    
    public enum Picker {
        public static func view(
            timeFormat: DroidTimeFormat = .twentyFour,
            enableSeconds: Bool = false,
            style: PickerStyle = .init()) -> DroidPickerSelector {
            let selector = DroidPickerSelector()
            selector.timeFormat = timeFormat
            selector.style = style
            selector.enableSeconds = enableSeconds
            return selector
        }
    }
}
