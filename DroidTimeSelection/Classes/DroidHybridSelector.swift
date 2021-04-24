//
//  DroidHybridSelector.swift
//  DroidTimeSelection
//
//  Created by Dan Draiman on 3/21/21.
//  Copyright © 2020 Nexxmark Studio. All rights reserved.
//

import UIKit

/// A Hybrid version of the selector.
///
/// Displays both versions of the selector.
/// Default mode is Clock selection.
///
/// Set the callbacks for `onOkTapped`, `onCancelTapped` and `onSelectionChanged`
/// to get updates from this component.
///
/// - Change `timeFormat` to change the selection mode for both selectors.
/// - Change `style` to change the style of the selectors and the menu. See `HybridStyle`, `ClockStyle` and `PickerStyle` for more details about possible styling.
@IBDesignable
public class DroidHybridSelector: UIView, HybridTimeSelector {
    
    // MARK: - Storyboard Properties
    
    @IBInspectable var modeButtonTint: UIColor = .white {
        didSet {
            style.modeButtonTint = modeButtonTint
        }
    }
    @IBInspectable var pickerModeButtonText: String? {
        didSet {
            if let text = pickerModeButtonText {
                style.pickerModeButtonContent = .text(title: text)
            }
        }
    }
    
    @IBInspectable var pickerModeButtonIcon: UIImage? {
        didSet {
            if let icon = pickerModeButtonIcon {
                style.pickerModeButtonContent = .icon(image: icon)
            }
        }
    }
    @IBInspectable var clockModeButtonText: String? {
        didSet {
            if let text = clockModeButtonText {
                style.clockModeButtonContent = .text(title: text)
            }
        }
    }
    
    @IBInspectable var clockModeButtonIcon: UIImage? {
        didSet {
            if let icon = clockModeButtonIcon {
                style.clockModeButtonContent = .icon(image: icon)
            }
        }
    }
    @IBInspectable var cancelButtonText: String? {
        didSet {
            if let text = cancelButtonText {
                style.cancelButtonContent = .text(title: text)
            }
        }
    }
    @IBInspectable var cancelButtonIcon: UIImage? {
        didSet {
            if let icon = cancelButtonIcon {
                style.cancelButtonContent = .icon(image: icon)
            }
        }
    }
    @IBInspectable var submitButtonText: String? {
        didSet {
            if let text = submitButtonText {
                style.submitButtonContent = .text(title: text)
            }
        }
    }
    @IBInspectable var submitButtonIcon: UIImage? {
        didSet {
            if let icon = submitButtonIcon {
                style.submitButtonContent = .icon(image: icon)
            }
        }
    }
    @IBInspectable var cancelButtonColor: UIColor = .white {
        didSet {
            style.cancelButtonColor = cancelButtonColor
        }
    }
    @IBInspectable var submitButtonColor: UIColor = .white {
        didSet {
            style.submitButtonColor = submitButtonColor
        }
    }
    
    // MARK: - Public Properties
    
    /// Time format for all selectors.
    public var timeFormat: DroidTimeFormat = .twelve {
        didSet {
            onTimeFormatChanged()
        }
    }
    
    
    /// Styling for Hybrid menu and for the inner selectors.
    public var style: HybridStyle = .init() {
        didSet {
            if oldValue != style {
                onStyleChanged()
            }
        }
    }
    
    /// The current time value of the selector. See `Time` object for more info.
    public var time: Time {
        return currentTime
    }
    
    /// Should seconds be selectable
    public var enableSeconds: Bool = false {
        didSet {
            onTimeFormatChanged()
        }
    }
    
    //Callbacks
    
    /// Will be called when the submit button, in the hybrid menu, is tapped.
    public var onOkTapped: (() -> Void)?
    /// Will be called when the cancel button, in the hybrid menu, is tapped.
    public var onCancelTapped: (() -> Void)?
    /// Will be called the time value of the current selector is changed.
    public var onSelectionChanged: ((Time) -> Void)?
    
    // MARK: - Private Properties
    
    public var mode: TimeSelectionMode = .clock {
        didSet {
            onModeChanged()
        }
    }
    private var currentTime: Time = .init()
    
    // MARK: - UI Components
    
    private let clockSelector: ClockTimeSelector = {
        let selector = DroidClockSelector()
        return selector
    }()
    
    private let hourPicker: PickerTimeSelector = {
        let picker = DroidPickerSelector()
        return picker
    }()
    
    private lazy var okButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(okTapped), for: .touchUpInside)
        button.isAccessibilityElement = true
        button.accessibilityLabel = "Tap to confirm time selection"
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        button.isAccessibilityElement = true
        button.accessibilityLabel = "Tap to cancel time selection"
        return button
    }()
    
    private lazy var modeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(toggleMode), for: .touchUpInside)
        button.isAccessibilityElement = true
        button.accessibilityLabel = "Tap to change time selection method"
        return button
    }()
    
    private lazy var allButtonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = 8
        stack.addArrangedSubview(modeButton)
        stack.addArrangedSubview(actionButtonsStack)
        return stack
    }()
    
    private lazy var actionButtonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 20
        stack.addArrangedSubview(cancelButton)
        stack.addArrangedSubview(okButton)
        return stack
    }()
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        stack.addArrangedSubview(clockSelector)
        stack.addArrangedSubview(hourPicker)
        stack.addArrangedSubview(allButtonsStack)
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
        backgroundColor = .black
        addSubview(contentStack)
        contentStack.anchor(
            in: self,
            padding: .init(constant: 18))
        
        hourPicker.set(time: time)
        clockSelector.set(time: time)
        hourPicker.onSelectionChanged = { [weak self] time in
            self?.currentTime = time
//            if let value = self?.clockSelector.time, value != time {
//                self?.clockSelector.set(time: time)
//            }
            self?.onSelectionChanged?(time)
        }
        
        clockSelector.onSelectionChanged = { [weak self] time in
            self?.currentTime = time
//            if let value = self?.hourPicker.time, value != time {
//                self?.hourPicker.set(time: time)
//            }
            self?.onSelectionChanged?(time)
        }
        
        onStyleChanged()
        reset()
    }
    
    // MARK: - Helpers | Private
    
    private func styleButton(_ button: UIButton, with style: ButtonStyle) {
        switch style {
        case .icon(let image):
            button.setTitle("", for: .normal)
            button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        case .text(let title):
            button.setTitle(title, for: .normal)
            button.setImage(nil, for: .normal)
        }
    }
    
    private func refreshModeButton() {
        switch mode {
        case .clock:
            styleButton(modeButton, with: style.pickerModeButtonContent)
            modeButton.accessibilityValue = "Clock selection mode"
        case .picker:
            styleButton(modeButton, with: style.clockModeButtonContent)
            modeButton.accessibilityValue = "Picker selection mode"
        }
        modeButton.isHidden = !style.showToggleButton
    }
    
    private func onTimeFormatChanged() {
        clockSelector.enableSeconds = enableSeconds
        clockSelector.timeFormat = timeFormat
        hourPicker.timeFormat = timeFormat
        hourPicker.enableSeconds = enableSeconds
    }
    
    private func onStyleChanged() {
        clockSelector.style = style.clock
        hourPicker.style = style.picker
        
        modeButton.tintColor = style.modeButtonTint
        modeButton.setTitleColor(style.modeButtonTint, for: .normal)
        refreshModeButton()
        
        okButton.tintColor = style.submitButtonColor
        okButton.setTitleColor(style.submitButtonColor, for: .normal)
        styleButton(okButton, with: style.submitButtonContent)
        
        cancelButton.tintColor = style.cancelButtonColor
        cancelButton.setTitleColor(style.cancelButtonColor, for: .normal)
        styleButton(cancelButton, with: style.cancelButtonContent)
    }
    
    // MARK: - Public Interface
    
    public func set(hour: Int, minutes: Int, seconds: Int, am: Bool?) {
        clockSelector.set(hour: hour, minutes: minutes, seconds: seconds, am: am)
        hourPicker.set(hour: hour, minutes: minutes, seconds: seconds, am: am)
        self.currentTime = clockSelector.time
    }
    
    public func set(time: Time) {
        self.currentTime = time
        hourPicker.set(time: time)
        clockSelector.set(time: time)
    }
    
    public func reset() {
        onModeChanged()
        clockSelector.reset()
        hourPicker.reset()
    }
    // MARK: - Actions | Private
    
    @objc private func toggleMode() {
        mode.toggle()
    }
    
    @objc private func onModeChanged() {
        refreshModeButton()
        clockSelector.isHidden = mode != .clock
        hourPicker.isHidden = mode != .picker
        clockSelector.set(time: time)
        hourPicker.set(time: time)
    }
    
    @objc private func cancelTapped() {
        onCancelTapped?()
    }
    
    @objc private func okTapped() {
        onOkTapped?()
    }
}
