//
//  DroidStyles.swift
//  DroidTimeSelection
//
//  Created by Dan Draiman on 7/26/20.
//  Copyright © 2020 Nexxmark Studio. All rights reserved.
//

import UIKit

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
    
    var outerCircleTextColor: UIColor = .white
    var outerCircleBackgroundColor: UIColor = .clear
    var innerCircleTextColor: UIColor = .gray
    var innerCircleBackgroundColor: UIColor = .clear
    var selectedColor: UIColor = .white
    var deselectedColor: UIColor = .gray
    var indicatorColor: UIColor = .blue
    var selectionFont: UIFont = .systemFont(ofSize: 18)
    var numbersFont: UIFont = .systemFont(ofSize: 18)
    
}

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
    
    var titleColor: UIColor = .white
    var titleFont: UIFont = .systemFont(ofSize: 14)
    var titleText: String = "Set Time"
    var pickerFont: UIFont = .systemFont(ofSize: 14)
    var pickerColor: UIColor = .white
}

public struct HybridStyle: Equatable {
    public init(
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
    
    var modeButtonTint: UIColor = .white
    var pickerModeButtonContent: ButtonStyle = .icon(image: UIImage(
                                                        named: "keyboard",
                                                        in: Bundle(for: DroidHybridSelector.self),
                                                        compatibleWith: nil))
    var clockModeButtonContent: ButtonStyle = .icon(image: UIImage(
                                                        named: "clock",
                                                        in: Bundle(for: DroidHybridSelector.self),
                                                        compatibleWith: nil))
    var cancelButtonContent: ButtonStyle = .text(title: "CANCEL")
    var submitButtonContent: ButtonStyle = .text(title: "OK")
    var cancelButtonColor: UIColor = .white
    var submitButtonColor: UIColor = .white
    
    var clock: ClockStyle = .init()
    var picker: PickerStyle = .init()
}

public enum ButtonStyle: Equatable {
    case text(title: String)
    case icon(image: UIImage?)
}

