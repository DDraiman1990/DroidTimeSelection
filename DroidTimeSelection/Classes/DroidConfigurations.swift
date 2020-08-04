//
//  DroidConfigurations.swift
//  DroidTimeSelection
//
//  Created by Dan Draiman on 7/26/20.
//  Copyright © 2020 Nexxmark Studio. All rights reserved.
//

import Foundation

public struct DroidTimeSelectionConfiguration: Equatable {
    public var cancelButtonColor: UIColor = .white
    public var okButtonColor: UIColor = .white
    public var modeButtonColor: UIColor = .white
    public var okButtonText: String = "OK"
    public var cancelButtonText: String = "CANCEL"
    public var timeFormat: DroidTimeFormat = .twentyFour
    
    public var clockConfig: DroidClockSelectorConfiguration = .init()
    public var pickerConfig: DroidPickerSelectorConfiguration = .init()
    
    public init() {}
}

public struct DroidClockSelectorConfiguration: Equatable {
    public var largeSelectionFont: UIFont = .systemFont(ofSize: 18)
    public var smallSelectionFont: UIFont = .systemFont(ofSize: 14)
    public var largeSelectionColor: UIColor = .white
    public var smallSelectionColor: UIColor = .gray
    public var timeFont: UIFont = .systemFont(ofSize: 60)
    public var amPmFont: UIFont = .systemFont(ofSize: 30)
    public var timeColor: UIColor = .gray
    public var highlightedTimeColor: UIColor = .white
    public var selectionIndicatorColor: UIColor = .systemTeal
    public var selectionBackgroundColor: UIColor = .clear
    public var timeFormat: DroidTimeFormat = .twentyFour
    
    public init() {}
}

public struct DroidPickerSelectorConfiguration: Equatable {
    public var titleFont: UIFont = .systemFont(ofSize: 26, weight: .bold)
    public var titleColor: UIColor = .white
    public var pickerColor: UIColor = .white
    public var titleText: String = "Set Time"
    public var timeFormat: DroidTimeFormat = .twentyFour
    
    public init() {}
}
