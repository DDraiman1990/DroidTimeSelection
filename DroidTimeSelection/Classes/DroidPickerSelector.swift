//
//  DroidPickerSelector.swift
//  DroidTimeSelection
//
//  Created by Dan Draiman on 7/25/20.
//  Copyright © 2020 Nexxmark Studio. All rights reserved.
//

import UIKit

/// A time selector showing a UIPickerView allowing the native pre-iOS 14 picker
/// style selection.
///
/// Set the callback `onSelectionChanged` to get updates from this component.
///
/// - Change `timeFormat` to change the selection mode for the selector.
/// - Change `style` to change the style of the selectors and the menu. See `PickerStyle` for more details about possible styling.
@available(iOS 13.0, *)
@IBDesignable
public class DroidPickerSelector: UIView, PickerTimeSelector {
    
    // MARK: - Storyboard Properties

    @IBInspectable
    var titleColor: UIColor = .white {
        didSet {
            style.titleColor = titleColor
        }
    }
    @IBInspectable
    var titleFont: UIFont = .systemFont(ofSize: 14) {
        didSet {
            style.titleFont = titleFont
        }
    }
    @IBInspectable
    var titleText: String = "Set Time" {
        didSet {
            style.titleText = titleText
        }
    }
    @IBInspectable
    var pickerFont: UIFont = .systemFont(ofSize: 14) {
        didSet {
            style.pickerFont = pickerFont
        }
    }
    @IBInspectable
    var pickerColor: UIColor = .white {
        didSet {
            style.pickerColor = pickerColor
        }
    }
    
    // MARK: - Public Properties
    
    /// The current time value of the selector. See `Time` object for more info.
    public var time: Time {
        return currentTime
    }
    
    /// Styling for selector.
    public var style: PickerStyle = .init() {
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
    
    /// Should seconds be selectable
    public var enableSeconds: Bool = false {
        didSet {
            onTimeFormatChanged()
        }
    }
    
    // Callbacks
    
    /// Will be called whenever the picker selection changes.
    public var onSelectionChanged: ((Time) -> Void)?
    
    // MARK: - Private Properties
    
    private var currentTime: Time = .init() {
        didSet {
            onSelectionChanged?(currentTime)
        }
    }
    
    // MARK: - UI Components
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.isAccessibilityElement = true
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var timeDatePicker: DroidUITimePicker = {
        let picker = DroidUITimePicker()
        picker.onValueChanged = { [weak self] time in
            self?.onPickerSelectionChanged(to: time)
        }
        return picker
    }()
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 12
        return stack
    }()
    
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
        addSubview(contentStack)
        contentStack.anchor(
            in: self,
            padding: .init(top: 26, left: 26, bottom: 26, right: 26))
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(timeDatePicker)
        timeDatePicker.width(multiplier: 1.0, relativeTo: contentStack)
        onStyleChanged()
        reset()
    }
    
    // MARK: - Helpers
    
    private func onTimeFormatChanged() {
        timeDatePicker.timeFormat = timeFormat
        timeDatePicker.enableSeconds = enableSeconds
    }
    
    private func onStyleChanged() {
        titleLabel.font = style.titleFont.withSize(26)
        titleLabel.textColor = style.titleColor
        timeDatePicker.set(textColor: style.pickerColor)
        titleLabel.text = style.titleText
        onTimeFormatChanged()
    }
    
    private func selectHour(value: Int) {
        switch timeFormat {
        case .twelve:
            currentTime.twelveHoursFormat.hours = value
            currentTime.twentyFourHoursFormat.hours
                = value + (time.twelveHoursFormat.am ?? true ? 0 : 12)
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
    
    private func selectSeconds(value: Int) {
        currentTime.twentyFourHoursFormat.seconds = value
        currentTime.twelveHoursFormat.seconds = value
    }
    
    private func onCurrentTimeChanged() {
        timeDatePicker.set(time: self.time)
    }
    
    // MARK: - Actions
    
    private func onPickerSelectionChanged(to value: Time) {
        self.currentTime = value
    }
    
    // MARK: - Public Interface

    public func set(hour: Int, minutes: Int, seconds: Int, am: Bool?) {
        currentTime.twelveHoursFormat.am = am
        self.selectHour(value: hour)
        self.selectMinutes(value: minutes)
        self.selectSeconds(value: seconds)
        onCurrentTimeChanged()
    }
    
    public func set(time: Time) {
        currentTime = time
        onCurrentTimeChanged()
    }
    
    public func reset() {
        set(time: .init())
    }
}
