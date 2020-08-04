//
//  DroidTimeSelection.swift
//  DroidTimeSelection
//
//  Created by Dan Draiman on 7/25/20.
//  Copyright © 2020 Nexxmark Studio. All rights reserved.
//

import UIKit

public class DroidTimeSelection: UIView {
    
    // MARK: - Public Properties
    
    //Callbacks
    public var onOkTapped: (() -> Void)?
    public var onCancelTapped: (() -> Void)?
    public var onSelectionChanged: ((Time) -> Void)?
    
    //Values
    
    public var value: Time {
        return currentTime
    }
    
    //Clock selector customization
    public var clockSelectorConfig: DroidClockSelectorConfiguration {
        get {
            return clockSelector.config
        }
        set {
            clockSelector.config = newValue
        }
    }
    
    //Hour picker customization
    public var hourPickerConfig: DroidPickerSelectorConfiguration {
        get {
            return hourPicker.config
        }
        set {
            hourPicker.config = newValue
        }
    }
    
    //Menu Customization
    public var config: DroidTimeSelectionConfiguration {
        get {
            return currentConfig
        }
        set {
            let shouldRefresh = newValue != currentConfig
            currentConfig = newValue
            if shouldRefresh {
                onConfigChanged()
            }
        }
    }
    
    // MARK: - Private Properties
    private var currentConfig: DroidTimeSelectionConfiguration = .init()
    private let keyboardIcon = UIImage(
        named: "keyboard",
        in: Bundle(for: DroidTimeSelection.self),
        compatibleWith: nil)
    private let clockIcon = UIImage(
        named: "clock",
        in: Bundle(for: DroidTimeSelection.self),
        compatibleWith: nil)
    private var mode: HourSelectionMode = .clock
    private var currentTime: Time = .init()
    
    // MARK: - UI Components
    
    private let clockSelector: DroidClockSelector = {
        let selector = DroidClockSelector()
        return selector
    }()
    
    private let hourPicker: DroidPickerSelector = {
        let picker = DroidPickerSelector()
        return picker
    }()
    
    private lazy var okButton: UIButton = {
        let button = UIButton()
        button.setTitle(self.config.okButtonText, for: .normal)
        button.setTitleColor(self.config.okButtonColor, for: .normal)
        button.addTarget(self, action: #selector(okTapped), for: .touchUpInside)
        button.isAccessibilityElement = true
        button.accessibilityLabel = "Tap to confirm time selection"
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle(self.config.cancelButtonText, for: .normal)
        button.setTitleColor(self.config.cancelButtonColor, for: .normal)
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        button.isAccessibilityElement = true
        button.accessibilityLabel = "Tap to cancel time selection"
        return button
    }()
    
    private lazy var modeButton: UIButton = {
        let button = UIButton()
        button.tintColor = config.modeButtonColor
        button.addTarget(self, action: #selector(changeMode), for: .touchUpInside)
        button.isAccessibilityElement = true
        button.accessibilityLabel = "Tap to change time selection method"
        return button
    }()
    
    private let allButtonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = 8
        return stack
    }()
    
    private let actionButtonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 20
        return stack
    }()
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
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
            padding: .init(top: 18, left: 18, bottom: 18, right: 18))
        contentStack.addArrangedSubview(clockSelector)
        contentStack.addArrangedSubview(hourPicker)
        contentStack.addArrangedSubview(allButtonsStack)
        
        allButtonsStack.addArrangedSubview(modeButton)
        allButtonsStack.addArrangedSubview(actionButtonsStack)
        
        actionButtonsStack.addArrangedSubview(cancelButton)
        actionButtonsStack.addArrangedSubview(okButton)
        hourPicker.set(time: self.value)
        clockSelector.set(time: self.value)
        hourPicker.onSelectionChanged = { [weak self] time in
            self?.currentTime = time
            if let value = self?.clockSelector.time, value != time {
                self?.clockSelector.set(time: time)
            }
            self?.onSelectionChanged?(time)
        }
        
        clockSelector.onSelectionChanged = { [weak self] time in
            self?.currentTime = time
            if let value = self?.hourPicker.time, value != time {
                self?.hourPicker.set(time: time)
            }
            self?.onSelectionChanged?(time)
        }
        
        reset()
    }
    
    // MARK: - Helpers
    
    private func updateButtonIcon() {
        modeButton.setImage(mode == .clock ?
            keyboardIcon
            : clockIcon, for: .normal)
        modeButton.accessibilityValue
            = "\(mode == .clock ? "Clock" : "Picker") selection mode"
    }
    
    private func onConfigChanged() {
        cancelButton.setTitleColor(config.cancelButtonColor, for: .normal)
        okButton.setTitleColor(config.okButtonColor, for: .normal)
        modeButton.tintColor = config.modeButtonColor
        okButton.setTitle(config.okButtonText, for: .normal)
        cancelButton.setTitle(config.cancelButtonText, for: .normal)
        config.clockConfig.timeFormat = config.timeFormat
        config.pickerConfig.timeFormat = config.timeFormat
        clockSelectorConfig = config.clockConfig
        hourPickerConfig = config.pickerConfig
    }
    
    // MARK: - Public Interface
    
    /// Set the current time selection to the given parameters.
    /// - Parameters:
    ///   - hour: the hour number.
    ///   - minutes: the amount of minutes.
    ///   - am: if time is am/pm or nil for 24 hours format.
    public func set(hour: Int, minutes: Int, am: Bool?) {
        clockSelector.set(hour: hour, minutes: minutes, am: am)
        hourPicker.set(hour: hour, minutes: minutes, am: am)
        self.currentTime = clockSelector.time
    }
    
    /// Set the current time selection to the given parameters.
    /// - Parameter time: Time representing the time selection.
    public func set(time: Time) {
        self.currentTime = time
        hourPicker.set(time: time)
        clockSelector.set(time: time)
    }
    
    /// Reset the component. Sets time to 00:00 or 12am.
    public func reset() {
        onModeChanged()
        clockSelector.reset()
        hourPicker.reset()
    }
    // MARK: - Actions
    
    @objc private func changeMode() {
        switch mode {
        case .clock:
            mode = .picker
        case .picker:
            mode = .clock
        }
        onModeChanged()
    }
    
    @objc private func onModeChanged() {
        updateButtonIcon()
        clockSelector.isHidden = mode != .clock
        hourPicker.isHidden = mode != .picker
    }
    
    @objc private func cancelTapped() {
        onCancelTapped?()
    }
    
    @objc private func okTapped() {
        onOkTapped?()
    }
}

private enum HourSelectionMode {
    case picker, clock
}
