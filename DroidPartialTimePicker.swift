//
//  DroidPartialTimePicker.swift
//  DroidTimeSelection
//
//  Created by Dan Draiman on 5/16/21.
//

import UIKit
import Combine


final class DroidPartialTimePicker: UIView, TimePicking {
    var onValueChanged: ((Time) -> Void)?
    
    private (set) var value: Time = .init() {
        didSet {
            onValueChanged?(value)
        }
    }
    
    /// Time format for the selector.
    public var timeFormat: DroidTimeFormat = .twelve {
        didSet {
            onTimeFormatChanged()
        }
    }
    
    /// Whether or not to allow seconds field.
    public var enableSeconds: Bool = false {
        didSet {
            onTimeFormatChanged()
        }
    }
    
    func set(textColor: UIColor) {
        timeDatePicker.setValue(
            textColor,
            forKeyPath: Constants.PickerProperties.textColor)
    }
    
    func set(time: Time) {
        self.value = time
        onTimeFormatChanged()
        reflectSelection()
    }
    
    private lazy var timeDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        picker.addTarget(
            self,
            action: #selector(onPickerSelectionChanged(_:)),
            for: .valueChanged)
        return picker
    }()
    
    private func onTimeFormatChanged() {
        switch timeFormat {
        case .twelve:
            timeDatePicker.locale = Constants.FormatLocales.twelveHours
        case .twentyFour:
            timeDatePicker.locale = Constants.FormatLocales.twentyFourHours
        }
    }
    
    private func reflectSelection() {
        timeDatePicker.date = self.value.date(relativeTo: Date()) ?? Date()
    }
    
    @objc private func onPickerSelectionChanged(_ picker: UIDatePicker) {
        let components = Calendar
            .current
            .dateComponents([.hour, .minute],
                            from: picker.date)
        guard let hour = components.hour, let minutes = components.minute else {
            return
        }
        self.value.set(hour: hour, minutes: minutes, seconds: 0)
    }
}
