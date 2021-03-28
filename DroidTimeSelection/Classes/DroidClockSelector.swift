//
//  DroidClockSelector.swift
//  DroidTimeSelection
//
//  Created by Dan Draiman on 7/22/20.
//  Copyright © 2020 Nexxmark Studio. All rights reserved.
//

import UIKit

/// A time selector showing a time indicator along with a physical clock to
/// give user the ability to manually select the time using an intuitive way.
///
/// Set the callback `onSelectionChanged` to get updates from this component.
///
/// This is the same UI presented in Android phones.
/// - Change `timeFormat` to change the selection mode for the selector.
/// - Change `style` to change the style of the selectors and the menu. See `ClockStyle` for more details about possible styling.
@available(iOS 10.0, *)
@IBDesignable
public class DroidClockSelector: UIView {
    
    // MARK: - Storyboard Properties
    
    @IBInspectable
    var outerCircleTextColor: UIColor = .white {
        didSet {
            style.outerCircleTextColor = outerCircleTextColor
        }
    }
    @IBInspectable
    var outerCircleBackgroundColor: UIColor = .clear {
        didSet {
            style.outerCircleBackgroundColor = outerCircleBackgroundColor
        }
    }
    @IBInspectable
    var innerCircleTextColor: UIColor = .gray {
        didSet {
            style.innerCircleTextColor = innerCircleTextColor
        }
    }
    @IBInspectable
    var innerCircleBackgroundColor: UIColor = .clear {
        didSet {
            style.innerCircleBackgroundColor = innerCircleBackgroundColor
        }
    }
    @IBInspectable
    var selectedColor: UIColor = .white {
        didSet {
            style.selectedColor = selectedColor
        }
    }
    @IBInspectable
    var deselectedColor: UIColor = .gray {
        didSet {
            style.deselectedColor = deselectedColor
        }
    }
    @IBInspectable
    var indicatorColor: UIColor = .blue {
        didSet {
            style.indicatorColor = indicatorColor
        }
    }
    @IBInspectable
    var selectionFont: UIFont = .systemFont(ofSize: 18) {
        didSet {
            style.selectionFont = selectionFont
        }
    }
    @IBInspectable
    var numbersFont: UIFont = .systemFont(ofSize: 18) {
        didSet {
            style.numbersFont = numbersFont
        }
    }
    
    // MARK: - Public Properties
    
    /// Styling for Hybrid menu and for the inner selectors.
    public var style: ClockStyle = .init() {
        didSet {
            if oldValue != style {
                onStyleChanged()
            }
        }
    }
    
    /// Time format for the selector.
    public var timeFormat: DroidTimeFormat = .twelve {
        didSet {
            onTimeFormatChanged()
        }
    }
    
    /// The current time value of the selector. See `Time` object for more info.
    public var time: Time {
        return currentTime
    }
    
    /// Will be called for every change in Time value.
    public var onSelectionChanged: ((Time) -> Void)?
    
    // MARK: - Private Properties
    
    private var currentTime: Time = .init() {
        didSet {
            onSelectionChanged?(currentTime)
            onCurrentTimeChanged()
        }
    }
    private var currentMode: ClockSelectionMode = .hour
    
    // MARK: - UI Components
    
    private let timeIndicator = DroidTimeIndicatorView()
    private let clockCollection = DroidClockCollectionView()
    
    // MARK: - Lifecycle
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(clockCollection)
        addSubview(timeIndicator)
        timeIndicator.anchor(height: 80)
        timeIndicator.anchor(
            in: self,
            to: [.top()],
            padding: .init(top: 28, left: 28, bottom: 28, right: 28))
        timeIndicator
            .widthAnchor
            .constraint(lessThanOrEqualTo: widthAnchor,
                        multiplier: 0.8)
            .isActive = true
        timeIndicator.centerX(in: self)
        clockCollection
            .topAnchor
            .constraint(equalTo: timeIndicator.bottomAnchor)
            .isActive = true
        clockCollection.anchor(
            in: self,
            to: [.bottom(), .left(), .right()],
            padding: .init(top: 12, left: 12, bottom: 12, right: 12))
        clockCollection
            .widthAnchor
            .constraint(equalTo: clockCollection.heightAnchor,
                        multiplier: 1.0)
            .isActive = true
                
        bindTimeIndicator()
        bindClockCollection()
        onStyleChanged()
        reset()
    }
    
    // MARK: - Setup
    
    private func bindTimeIndicator() {
        timeIndicator.onPmTapped = { [weak self] in
            self?.onPmLabelTapped()
        }
        timeIndicator.onAmTapped = { [weak self] in
            self?.onAmLabelTapped()
        }
        timeIndicator.onHoursTapped = { [weak self] in
            self?.onHourLabelTapped()
        }
        timeIndicator.onMinutesTapped = { [weak self] in
            self?.onMinutesLabelTapped()
        }
    }
    
    private func bindClockCollection() {
        clockCollection.onHourSelected = { [weak self] hour in
            self?.onHourSelected(hour)
        }
        
        clockCollection.onMinuteSelected = { [weak self] minute in
            self?.onMinuteSelected(minute)
        }
        
        clockCollection.onHourSelectionEnded = { [weak self] _ in
            self?.onHourSelectionEnded()
        }
    }
    
    // MARK: - Helpers
    
    private func onHourSelectionEnded() {
        changeMode(to: .minutes) { _ in
            switch self.timeFormat {
            case .twelve:
                self.clockCollection.moveIndicatorToMinute(self
                    .time
                    .twelveHoursFormat
                    .minutes)
            case .twentyFour:
                self.clockCollection.moveIndicatorToMinute(self
                    .time
                    .twentyFourHoursFormat
                    .minutes)
            }
        }
    }
    
    private func onHourSelected(_ hour: Int) {
        selectHour(value: hour)
    }
    
    private func onMinuteSelected(_ minute: Int) {
        selectMinutes(value: minute)
    }
    
    private func moveIndicatorToReflectSelection() {
        switch currentMode {
        case .hour:
            switch timeFormat {
            case .twelve:
                clockCollection.moveIndicatorToHour(self.time.twelveHoursFormat.hours)
            case .twentyFour:
                clockCollection.moveIndicatorToHour(self.time.twentyFourHoursFormat.hours)
            }
        case .minutes:
            switch timeFormat {
            case .twelve:
                clockCollection.moveIndicatorToMinute(self.time.twelveHoursFormat.minutes)
            case .twentyFour:
                clockCollection.moveIndicatorToMinute(self.time.twentyFourHoursFormat.minutes)
            }
        }
    }
    
    private func onHourLabelTapped() {
        changeMode(to: .hour) { _ in
            switch self.timeFormat {
            case .twelve:
                self.clockCollection.moveIndicatorToHour(self.time.twelveHoursFormat.hours)
            case .twentyFour:
                self.clockCollection.moveIndicatorToHour(self.time.twentyFourHoursFormat.hours)
            }
        }
    }
    
    private func onMinutesLabelTapped() {
        changeMode(to: .minutes) { _ in
            switch self.timeFormat {
            case .twelve:
                self.clockCollection.moveIndicatorToMinute(self.time.twelveHoursFormat.minutes)
            case .twentyFour:
                self.clockCollection.moveIndicatorToMinute(self.time.twentyFourHoursFormat.minutes)
            }
        }
    }
    
    private func onAmLabelTapped() {
        currentTime.twelveHoursFormat.am = true
        set(
            hour: time.twelveHoursFormat.hours,
            minutes: time.twelveHoursFormat.minutes,
            am: true)
    }
    
    private func onPmLabelTapped() {
        currentTime.twelveHoursFormat.am = false
        set(
            hour: time.twelveHoursFormat.hours,
            minutes: time.twelveHoursFormat.minutes,
            am: false)
    }
    
    private func selectHour(value: Int) {
        switch timeFormat {
        case .twelve:
            currentTime.twelveHoursFormat.hours = value
            if value == 12 {
                currentTime
                    .twentyFourHoursFormat
                    .hours = (time.twelveHoursFormat.am ?? true) ? 0 : 12
            } else {
                currentTime
                    .twentyFourHoursFormat
                    .hours = value + (time.twelveHoursFormat.am ?? true ? 0 : 12)
            }
        case .twentyFour:
            currentTime.twentyFourHoursFormat.hours = value
            let isAm = value < 12
            currentTime.twelveHoursFormat.am = isAm
            currentTime.twelveHoursFormat.hours = isAm ? value - 12 : value
        }
    }
    
    private func selectMinutes(value: Int) {
        currentTime.twentyFourHoursFormat.minutes = value
        currentTime.twelveHoursFormat.minutes = value
    }
    
    private func onModeChanged(completion: ((Bool) -> Void)?) {
        clockCollection.currentMode = currentMode
        highlight(mode: currentMode)
        moveIndicatorToReflectSelection()
    }
    
    private func onStyleChanged() {
        reloadData()
        highlight(mode: currentMode)
        
        timeIndicator.amPmFont = style.selectionFont
        timeIndicator.timeFont = style.selectionFont.withSize(60)
        
        clockCollection.indicatorColor = style.indicatorColor
        clockCollection.outerCircleTextColor = style.outerCircleTextColor
        clockCollection.outerCircleBackgroundColor = style.outerCircleBackgroundColor
        clockCollection.innerCircleTextColor = style.innerCircleTextColor
        clockCollection.innerCircleBackgroundColor = style.innerCircleBackgroundColor
        clockCollection.numbersFont = style.numbersFont
        onTimeFormatChanged()
    }
    
    private func highlight(mode: ClockSelectionMode) {
        let selectedColor = style.selectedColor
        let deselectedColor = style.deselectedColor
                
        timeIndicator.hoursColor = mode == .hour ?
            selectedColor :
            deselectedColor
        timeIndicator.minutesColor = mode == .minutes ?
            selectedColor :
            deselectedColor
        if let isAm = time.twelveHoursFormat.am {
            timeIndicator.amColor = isAm ?
                selectedColor :
                deselectedColor
            timeIndicator.pmColor = !isAm ?
                selectedColor :
                deselectedColor
        }
    }
    
    private func onCurrentTimeChanged() {
        timeIndicator.time = self.currentTime
        highlight(mode: currentMode)
    }
        
    private func changeMode(to mode: ClockSelectionMode, completion: ((Bool) -> Void)?) {
        currentMode = mode
        onModeChanged(completion: completion)
    }
    
    private func onTimeFormatChanged() {
        clockCollection.timeFormat = self.timeFormat
        timeIndicator.timeFormat = self.timeFormat
        onCurrentTimeChanged()
    }
    
    private func reloadData() {
        self.clockCollection.reloadData()
    }
    
    // MARK: - Public Interface
    
    /// Set the current time selection to the given parameters.
    /// - Parameters:
    ///   - hour: the hour number.
    ///   - minutes: the amount of minutes.
    ///   - am: if time is am/pm or nil for 24 hours format.
    public func set(hour: Int, minutes: Int, am: Bool?) {
        currentTime.twelveHoursFormat.am = am
        self.selectHour(value: hour)
        self.selectMinutes(value: minutes)
        onCurrentTimeChanged()
    }
    
    /// Set the current time selection to the given parameters.
    /// - Parameter time: Time representing the time selection.
    public func set(time: Time) {
        currentTime = time
        onCurrentTimeChanged()
    }
    
    /// Reset the component. Sets time to 00:00 or 12am.
    public func reset() {
        currentTime = .init()
        changeMode(to: .hour) { _ in
            switch self.timeFormat {
            case .twelve:
                self.clockCollection.moveIndicatorToHour(self.time.twelveHoursFormat.hours)
            case .twentyFour:
                self.clockCollection.moveIndicatorToHour(self.time.twentyFourHoursFormat.hours)
            }
        }
        onStyleChanged()
    }
}

internal enum ClockSelectionMode {
    case hour, minutes
}
