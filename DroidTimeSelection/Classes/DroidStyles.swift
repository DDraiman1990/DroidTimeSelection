//
//  DroidStyles.swift
//  DroidTimeSelection
//
//  Created by Dan Draiman on 7/26/20.
//  Copyright © 2020 Nexxmark Studio. All rights reserved.
//

import UIKit

/// The styling configuration for the ClockSelector.
///
/// `outerCircleTextColor`: the text color for the entries in the outer clock circle
/// `outerCircleBackgroundColor`: the background color for the entries in the outer clock circle
/// `innerCircleTextColor`: the text color for the entries in the inner clock circle
/// `innerCircleBackgroundColor`: the background color for the entries in the inner clock circle
/// `selectedColor`: the color for the current time unit being selected. Example: if hour is currently being selected then the HH of the HH:MM label will be colored with this color.
/// `deselectedColor`: the color for the current time unit being selected. Example: if hour is currently being selected then the MM of the HH:MM label will be colored with this color.
/// `indicatorColor`: the color for the line and circle indicator in the physical clock.
/// `selectionFont`: the font for the HH:MM time label.
/// `numbersFont`: the font for all the entries in the physical clock.
/// - Warning: the sizes of provided fonts will be ignored to avoid having the layout broken by extreme sizes.
public struct ClockStyle: Equatable {
    public init(
        outerCircleTextColor: UIColor = .white,
        outerCircleBackgroundColor: UIColor = .clear,
        innerCircleTextColor: UIColor = .gray,
        innerCircleBackgroundColor: UIColor = .clear,
        selectedColor: UIColor = .white,
        deselectedColor: UIColor = .gray,
        indicatorColor: UIColor = .blue,
        selectionFont: UIFont = .systemFont(ofSize: 18),
        numbersFont: UIFont = .systemFont(ofSize: 18)) {
        self.outerCircleTextColor = outerCircleTextColor
        self.outerCircleBackgroundColor = outerCircleBackgroundColor
        self.innerCircleTextColor = innerCircleTextColor
        self.innerCircleBackgroundColor = innerCircleBackgroundColor
        self.selectedColor = selectedColor
        self.deselectedColor = deselectedColor
        self.indicatorColor = indicatorColor
        self.selectionFont = selectionFont
        self.numbersFont = numbersFont
    }
    
    public var outerCircleTextColor: UIColor = .white
    public var outerCircleBackgroundColor: UIColor = .clear
    public var innerCircleTextColor: UIColor = .gray
    public var innerCircleBackgroundColor: UIColor = .clear
    public var selectedColor: UIColor = .white
    public var deselectedColor: UIColor = .gray
    public var indicatorColor: UIColor = .blue
    public var selectionFont: UIFont = .systemFont(ofSize: 18)
    public var numbersFont: UIFont = .systemFont(ofSize: 18)
    
}

/// The styling configuration for the ClockSelector.
///
/// `titleColor`: the text color for the selector's title.
/// `titleFont`: the font for the selector's title.
/// `titleText`: the text in the selector's title.
/// `pickerFont`: the font for the picker entries.
/// `pickerColor`: the text color for the picker entries.
/// - Warning: the sizes of provided fonts will be ignored to avoid having the layout broken by extreme sizes.
public struct PickerStyle: Equatable {
    public init(
        titleColor: UIColor = .white,
        titleFont: UIFont = .systemFont(ofSize: 14),
        titleText: String = "Set Time",
        pickerFont: UIFont = .systemFont(ofSize: 14),
        pickerColor: UIColor = .white) {
        self.titleColor = titleColor
        self.titleFont = titleFont
        self.titleText = titleText
        self.pickerFont = pickerFont
        self.pickerColor = pickerColor
    }
    
    public var titleColor: UIColor = .white
    public var titleFont: UIFont = .systemFont(ofSize: 14)
    public var titleText: String = "Set Time"
    public var pickerFont: UIFont = .systemFont(ofSize: 14)
    public var pickerColor: UIColor = .white
}

/// The styling configuration for the ClockSelector.
///
/// `showToggleButton`: whether you want the hybrid selector to allow user to
/// toggle between Clock and Picker manually.
/// `modeButtonTint`: the color for the toggle selection button.
/// `pickerModeButtonContent`: the button type for the 'Picker Selection' mode.
/// `clockModeButtonContent`: the button type for the 'Clock Selection' mode.
/// `cancelButtonContent`: the button type for the cancel button.
/// `submitButtonContent`: the button type for the submit button.
/// `cancelButtonColor`: the color for the cancel button.
/// `submitButtonColor`: the color for the submit button.
/// `clock`: the styling for the inner Clock Selector. See `ClockStyle` for more info.
/// `picker`: the styling for the inner Picker Selector. See `PickerStyle` for more info.
/// - Warning: the sizes of provided fonts will be ignored to avoid having the layout broken by extreme sizes.
public struct HybridStyle: Equatable {
    public init(
        showToggleButton: Bool = true,
        modeButtonTint: UIColor = .white,
        pickerModeButtonContent: ButtonStyle = .icon(
            image: UIImage(named: "keyboard",
                           in: Bundle(for: DroidHybridSelector.self),
                           compatibleWith: nil)),
        clockModeButtonContent: ButtonStyle = .icon(
            image: UIImage(named: "clock",
                           in: Bundle(for: DroidHybridSelector.self),
                           compatibleWith: nil)),
        cancelButtonContent: ButtonStyle = .text(title: "CANCEL"),
        submitButtonContent: ButtonStyle = .text(title: "OK"),
        cancelButtonColor: UIColor = .white,
        submitButtonColor: UIColor = .white,
        clock: ClockStyle = .init(),
        picker: PickerStyle = .init()) {
        self.showToggleButton = showToggleButton
        self.modeButtonTint = modeButtonTint
        self.pickerModeButtonContent = pickerModeButtonContent
        self.clockModeButtonContent = clockModeButtonContent
        self.cancelButtonContent = cancelButtonContent
        self.submitButtonContent = submitButtonContent
        self.cancelButtonColor = cancelButtonColor
        self.submitButtonColor = submitButtonColor
        self.clock = clock
        self.picker = picker
    }
    public var showToggleButton: Bool = true
    public var modeButtonTint: UIColor = .white
    public var pickerModeButtonContent: ButtonStyle = .icon(image: UIImage(
                                                        named: "keyboard",
                                                        in: Bundle(for: DroidHybridSelector.self),
                                                        compatibleWith: nil))
    public var clockModeButtonContent: ButtonStyle = .icon(image: UIImage(
                                                        named: "clock",
                                                        in: Bundle(for: DroidHybridSelector.self),
                                                        compatibleWith: nil))
    public var cancelButtonContent: ButtonStyle = .text(title: "CANCEL")
    public var submitButtonContent: ButtonStyle = .text(title: "OK")
    public var cancelButtonColor: UIColor = .white
    public var submitButtonColor: UIColor = .white
    
    public var clock: ClockStyle = .init()
    public var picker: PickerStyle = .init()
}

/// A button style.
/// - text: will only present a title by the given string.
/// - icon: will only present an icon by the given image.
public enum ButtonStyle: Equatable {
    case text(title: String)
    case icon(image: UIImage?)
}

