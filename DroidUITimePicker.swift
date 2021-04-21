//
//  DroidUITimePicker.swift
//  DroidTimeSelection
//
//  Created by Dan Draiman on 4/14/21.
//

import UIKit
import Combine

@available(iOS 13.0, *)
public final class DroidUITimePicker: UIView {
    
    //TODO: Toggle AM/PM when 12 is passed
    private let infiniteModifier = 200
    private let twentyFourHours: [Int] = Array(0...23)
    private let twelveHours = Array(1...12) + Array(1...12)
    private let minutes = Array(0...59)
    private let seconds = Array(0...59)
    private let amPm = ["AM", "PM"]
    private var lastSelectedHourIndex: Int = 0
    private var lastSelectedAm: Bool = false
    private var seenTwelves: Set<Int> = []
    
    private lazy var indexSeenDebouncer = QueryDebouncer<Int, DispatchQueue>(debounce: 0.25, queue: .main) { [weak self] index in
        self?.onSeen(index: index)
    }
    
    private func onSeen(index: Int) {
        setAmPm(toAm: isHourAm(realIndex: index), animated: true)
    }
    
    private let panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer()
        gesture.cancelsTouchesInView = false
        return gesture
    }()
    
    /// Time format for the selector.
    public var timeFormat: DroidTimeFormat = .twelve {
        didSet {
            onTimeFormatChanged()
        }
    }
    
    public var showSeconds: Bool = false {
        didSet {
            onTimeFormatChanged()
        }
    }
    
    private var currentTime: Time = .init()
    
    public var value: TimeInterval {
        return currentTime.timeInterval
    }
    
    private lazy var pickerView: UIPickerView = {
        let view = UIPickerView()
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    public init() {
        super.init(frame: .zero)
        addSubview(pickerView)
        anchor(in: self, to: [.top(), .left(), .right()])
        for comp in 0..<pickerView.numberOfComponents {
            selectRow(0, inComponent: comp, animated: false)
        }
        panGesture.addTarget(self, action: #selector(didPan(_:)))
        panGesture.delegate = self
        pickerView.addGestureRecognizer(panGesture)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func onTimeFormatChanged() {
        pickerView.reloadAllComponents()
        reflectSelection()
    }
    
    @objc private func didPan(_ gesture: UIGestureRecognizer) {
        switch gesture.state {
        case .began:
            lastSelectedHourIndex = pickerView.selectedRow(inComponent: 0)
            lastSelectedAm = currentTime.twelveHoursFormat.am ?? false
        default: break
        }
    }
    
    private func setAmPm(toAm am: Bool, animated: Bool) {
        guard timeFormat == .twelve else {
            return
        }
        currentTime.twelveHoursFormat.am = am
        if showSeconds {
            selectRow(am ? 0 : 1, inComponent: 3, animated: animated)
        } else {
            selectRow(am ? 0 : 1, inComponent: 2, animated: animated)
        }
    }
    
    private func reflectSelection() {
        switch timeFormat {
        case .twelve:
            let hour = currentTime.twelveHoursFormat.hours
            let minute = currentTime.twelveHoursFormat.minutes
            let second = currentTime.twelveHoursFormat.seconds
            let isAm = currentTime.twelveHoursFormat.am ?? false
            
            if let hourRow = twelveHours.firstIndex(of: hour) {
                selectRow(hourRow, inComponent: 0, animated: false)
            }
            
            if let minuteRow = minutes.firstIndex(of: minute) {
                selectRow(minuteRow, inComponent: 1, animated: false)
            }
            
            if showSeconds,
               let secondRow = seconds.firstIndex(of: second) {
                selectRow(secondRow, inComponent: 2, animated: false)
            }
            
            if showSeconds {
                selectRow(isAm ? 0 : 1, inComponent: 3, animated: false)
            }
        case .twentyFour:
            let hour = currentTime.twentyFourHoursFormat.hours
            let minute = currentTime.twentyFourHoursFormat.minutes
            let second = currentTime.twentyFourHoursFormat.seconds
            
            if let hourRow = twentyFourHours.firstIndex(of: hour) {
                selectRow(hourRow, inComponent: 0, animated: false)
            }
            
            if let minuteRow = minutes.firstIndex(of: minute) {
                selectRow(minuteRow, inComponent: 1, animated: false)
            }
            
            if showSeconds,
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
}

@available(iOS 13.0, *)
extension DroidUITimePicker: UIPickerViewDataSource, UIPickerViewDelegate {
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
            if showSeconds {
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
            if showSeconds {
                return seconds.count
            }
            if timeFormat == .twelve {
                return amPm.count
            }
            return 0
        default:
            if showSeconds && timeFormat == .twelve {
                return amPm.count
            }
            return 0
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberOfRows(inComponent: component) * (isComponentInfinite(component) ? infiniteModifier : 1)
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch timeFormat {
        case .twelve:
            return showSeconds ? 4 : 3
        case .twentyFour:
            return showSeconds ? 3 : 2
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
            if showSeconds {
                let modifiedIndex = row % seconds.count
                return String(format: "%02d", seconds[modifiedIndex])
            }
            if timeFormat == .twelve {
                let modifiedIndex = row % amPm.count
                return "\(amPm[modifiedIndex])"
            }
            return ""
        default:
            if showSeconds && timeFormat == .twelve {
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
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        sampleSelected()
        return title(forRow: row, forComponent: component)
    }

    private func didSelect(row: Int, inComponent component: Int) {
        var modifiedIndex: Int = 0
        switch component {
        case 0:
            switch timeFormat {
            case .twelve:
                modifiedIndex = row % twelveHours.count
                let hour = twelveHours[modifiedIndex]
                currentTime.twelveHoursFormat.hours = hour
            case .twentyFour:
                modifiedIndex = row % twentyFourHours.count
                let hour = twentyFourHours[modifiedIndex]
                currentTime.twentyFourHoursFormat.hours = hour
            }
        case 1:
            modifiedIndex = row % minutes.count
            let minute = minutes[modifiedIndex]
            currentTime.twentyFourHoursFormat.minutes = minute
            currentTime.twelveHoursFormat.minutes = minute
        case 2:
            if showSeconds {
                modifiedIndex = row % seconds.count
                let second = seconds[modifiedIndex]
                currentTime.twentyFourHoursFormat.seconds = second
                currentTime.twelveHoursFormat.seconds = second
            } else if timeFormat == .twelve {
                modifiedIndex = row % amPm.count
                currentTime.twelveHoursFormat.am = modifiedIndex == 0
            }
        default:
            if showSeconds && timeFormat == .twelve {
                modifiedIndex = row % amPm.count
                currentTime.twelveHoursFormat.am = modifiedIndex == 0
            }
        }
        selectRow(modifiedIndex, inComponent: component, animated: false)
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        didSelect(row: row, inComponent: component)
        sampleSelected()
    }
}

@available(iOS 13.0, *)
extension DroidUITimePicker: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
