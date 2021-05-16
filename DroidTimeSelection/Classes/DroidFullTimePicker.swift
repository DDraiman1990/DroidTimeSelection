//
//  DroidUITimePicker.swift
//  DroidTimeSelection
//
//  Created by Dan Draiman on 4/14/21.
//

import UIKit
import Combine

@available(iOS 13.0, *)

/// A time picker (similar to DatePicker when choosing time) that allows
/// choosing seconds.
public final class DroidFullTimePicker: UIView, TimePicking {
    
    // MARK: - Properties | Constants
    
    //To allow "infinite" cyclic scrolling we have to multiply rows by this modifier.
    private let infiniteModifier = 200
    private let twentyFourHours: [Int] = Array(0...23)
    //The reason for having 24 is to have 12 with am and 12 with pm
    //It gives the ability to mimic the same UIDatePicker behavior for AM/PM
    private let twelveHours = Array(1...12) + Array(1...12)
    private let minutes = Array(0...59)
    private let seconds = Array(0...59)
    private let amPm = ["AM", "PM"]
    
    // MARK: - Properties | Private
        
    private lazy var indexSeenDebouncer =
        QueryDebouncer<Int, DispatchQueue>(
            debounce: 0.25, queue: .main) { [weak self] index in
        self?.onSeen(index: index)
    }
    
    private (set) var value: Time = .init() {
        didSet {
            onValueChanged?(value)
        }
    }
    
    // MARK: - Properties | Public
    
    var onValueChanged: ((Time) -> Void)?
    
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
    
    public var timeInterval: TimeInterval {
        return value.timeInterval
    }
    
    // MARK: - UI Components
    
    private lazy var pickerView: UIPickerView = {
        let view = UIPickerView()
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    // MARK: - Lifecycle
    
    public init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Methods | Setup
    
    private func setup() {
        addSubview(pickerView)
        pickerView.anchor(in: self, to: [.bottom(), .top(), .left(), .right()])
        resetSelection()
    }
    
    // MARK: - Methods | Helpers
    
    private func onSeen(index: Int) {
        setAmPm(toAm: isHourAm(realIndex: index), animated: true)
    }
    
    private func resetSelection() {
        for comp in 0..<pickerView.numberOfComponents {
            selectRow(0, inComponent: comp, animated: false)
        }
    }
    
    private func onTimeFormatChanged() {
        pickerView.reloadAllComponents()
        reflectSelection()
    }
    
    private func setAmPm(toAm am: Bool, animated: Bool) {
        guard timeFormat == .twelve else {
            return
        }
        value.twelveHoursFormat.am = am
        if enableSeconds {
            selectRow(am ? 0 : 1, inComponent: 3, animated: animated)
        } else {
            selectRow(am ? 0 : 1, inComponent: 2, animated: animated)
        }
    }
    
    private func reflectSelection() {
        switch timeFormat {
        case .twelve:
            let hour = value.twelveHoursFormat.hours
            let minute = value.twelveHoursFormat.minutes
            let second = value.twelveHoursFormat.seconds
            let isAm = value.twelveHoursFormat.am ?? false
            
            if let hourRow = twelveHours.firstIndex(of: hour) {
                let index = hourRow + (isAm ? 0 : 12)
                selectRow(index, inComponent: 0, animated: false)
            }
            
            if let minuteRow = minutes.firstIndex(of: minute) {
                selectRow(minuteRow, inComponent: 1, animated: false)
            }
            
            if enableSeconds,
               let secondRow = seconds.firstIndex(of: second) {
                selectRow(secondRow, inComponent: 2, animated: false)
                selectRow(isAm ? 0 : 1, inComponent: 3, animated: false)
            } else {
                selectRow(isAm ? 0 : 1, inComponent: 2, animated: false)
            }
        case .twentyFour:
            let hour = value.twentyFourHoursFormat.hours
            let minute = value.twentyFourHoursFormat.minutes
            let second = value.twentyFourHoursFormat.seconds
            
            if let hourRow = twentyFourHours.firstIndex(of: hour) {
                selectRow(hourRow, inComponent: 0, animated: false)
            }
            
            if let minuteRow = minutes.firstIndex(of: minute) {
                selectRow(minuteRow, inComponent: 1, animated: false)
            }
            
            if enableSeconds,
               let secondRow = seconds.firstIndex(of: second) {
                selectRow(secondRow, inComponent: 2, animated: false)
            }
        }
    }
    
    private func selectRow(_ row: Int, inComponent component: Int, animated: Bool) {
        var index: Int = row
        if isComponentInfinite(component) {
            index = row + numberOfRows(inComponent: component) * infiniteModifier / 2
        }
        pickerView.selectRow(index, inComponent: component, animated: animated)
    }
    
    private func isHourAm(correctedIndex: Int) -> Bool {
        guard twelveHours.indices ~= correctedIndex else {
            return false
        }
        return correctedIndex <= 11
    }
    
    private func isHourAm(realIndex: Int) -> Bool {
        let modified = realIndex % twelveHours.count
        return isHourAm(correctedIndex: modified)
    }
    
    private func isComponentInfinite(_ component: Int) -> Bool {
        switch component {
        case 0:
            switch timeFormat {
            case .twelve:
                return true
            case .twentyFour:
                return true
            }
        case 1:
            return true
        case 2:
            if enableSeconds {
                return true
            }
            return false
        default:
            return false
        }
    }
    
    private func numberOfRows(inComponent component: Int) -> Int {
        switch component {
        case 0:
            switch timeFormat {
            case .twelve:
                return twelveHours.count
            case .twentyFour:
                return twentyFourHours.count
            }
        case 1:
            return minutes.count
        case 2:
            if enableSeconds {
                return seconds.count
            }
            if timeFormat == .twelve {
                return amPm.count
            }
            return 0
        default:
            if enableSeconds && timeFormat == .twelve {
                return amPm.count
            }
            return 0
        }
    }
    
    private func title(forRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            switch timeFormat {
            case .twelve:
                let modifiedIndex = row % twelveHours.count
                return "\(twelveHours[modifiedIndex])"
            case .twentyFour:
                let modifiedIndex = row % twentyFourHours.count
                return String(format: "%02d", twentyFourHours[modifiedIndex])
            }
        case 1:
            let modifiedIndex = row % minutes.count
            return String(format: "%02d", minutes[modifiedIndex])
        case 2:
            if enableSeconds {
                let modifiedIndex = row % seconds.count
                return String(format: "%02d", seconds[modifiedIndex])
            }
            if timeFormat == .twelve {
                let modifiedIndex = row % amPm.count
                return "\(amPm[modifiedIndex])"
            }
            return ""
        default:
            if enableSeconds && timeFormat == .twelve {
                let modifiedIndex = row % amPm.count
                return "\(amPm[modifiedIndex])"
            }
            return ""
        }
    }
    
    private func sampleSelected() {
        let selected = pickerView.selectedRow(inComponent: 0)
        indexSeenDebouncer.update(value: selected)
    }
    
    private func didSelect(row: Int, inComponent component: Int) {
        var modifiedIndex: Int = 0
        switch component {
        case 0:
            switch timeFormat {
            case .twelve:
                modifiedIndex = row % twelveHours.count
                let hour = twelveHours[modifiedIndex]
                value.twelveHoursFormat.hours = hour
                value.twentyFourHoursFormat.hours = value.twelveHoursFormat.am ?? true ? hour : hour + 12
            case .twentyFour:
                modifiedIndex = row % twentyFourHours.count
                let hour = twentyFourHours[modifiedIndex]
                value.twentyFourHoursFormat.hours = hour
                let isAm = hour <= 12
                value.twelveHoursFormat.hours = isAm ? hour : hour - 12
                value.twelveHoursFormat.am = isAm
            }
        case 1:
            modifiedIndex = row % minutes.count
            let minute = minutes[modifiedIndex]
            value.twentyFourHoursFormat.minutes = minute
            value.twelveHoursFormat.minutes = minute
        case 2:
            if enableSeconds {
                modifiedIndex = row % seconds.count
                let second = seconds[modifiedIndex]
                value.twentyFourHoursFormat.seconds = second
                value.twelveHoursFormat.seconds = second
            } else if timeFormat == .twelve {
                modifiedIndex = row % amPm.count
                let isAm = modifiedIndex == 0
                onAmPmSelected(am: isAm)
            }
        default:
            if enableSeconds && timeFormat == .twelve {
                modifiedIndex = row % amPm.count
                let isAm = modifiedIndex == 0
                onAmPmSelected(am: isAm)
            }
        }
        selectRow(modifiedIndex, inComponent: component, animated: false)
    }
    
    private func onAmPmSelected(am: Bool) {
        value.twelveHoursFormat.am = am
        value.twentyFourHoursFormat.hours = am ? value.twelveHoursFormat.hours : value.twelveHoursFormat.hours + 12
        if timeFormat == .twelve {
            let selectedHourIndex = pickerView.selectedRow(inComponent: 0)
            let isAm = isHourAm(realIndex: selectedHourIndex)
            if (am && !isAm) || (!am && isAm) {
                pickerView.selectRow(selectedHourIndex + 12, inComponent: 0, animated: false)
            }
        }
    }
    
    // MARK: - Methods | Public API
    
    /// Set the current time selection to the given parameters.
    /// - Parameter time: Time representing the time selection.
    public func set(time: Time) {
        self.value = time
        onTimeFormatChanged()
        reflectSelection()
    }
    
    /// Set the text color for all titles in the picker view
    /// - Parameter textColor: UIColor
    public func set(textColor: UIColor) {
        pickerView.setValue(
            textColor,
            forKeyPath: Constants.PickerProperties.textColor)
    }
}

@available(iOS 13.0, *)
extension DroidFullTimePicker: UIPickerViewDataSource, UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberOfRows(inComponent: component) * (isComponentInfinite(component) ? infiniteModifier : 1)
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch timeFormat {
        case .twelve:
            return enableSeconds ? 4 : 3
        case .twentyFour:
            return enableSeconds ? 3 : 2
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        sampleSelected()
        return title(forRow: row, forComponent: component)
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        didSelect(row: row, inComponent: component)
        sampleSelected()
    }
}
