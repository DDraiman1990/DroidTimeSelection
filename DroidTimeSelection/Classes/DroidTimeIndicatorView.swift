//
//  DroidTimeIndicatorView.swift
//  DroidTimeSelection
//
//  Created by Dan Draiman on 3/27/21.
//  Copyright © 2020 Nexxmark Studio. All rights reserved.
//

import UIKit

@IBDesignable
final class DroidTimeIndicatorView: UIView {
    
    // MARK: - Storyboard Properties
    
    @IBInspectable
    var amColor: UIColor = .white {
        didSet {
            amLabelButton.setTitleColor(amColor, for: .normal)
        }
    }
    
    @IBInspectable
    var pmColor: UIColor = .white {
        didSet {
            pmLabelButton.setTitleColor(pmColor, for: .normal)
        }
    }
    
    @IBInspectable
    var hoursColor: UIColor = .white {
        didSet {
            hoursLabelButton.setTitleColor(hoursColor, for: .normal)
        }
    }
    
    @IBInspectable
    var minutesColor: UIColor = .white {
        didSet {
            minutesLabelButton.setTitleColor(minutesColor, for: .normal)
        }
    }
    
    @IBInspectable
    var secondsColor: UIColor = .white {
        didSet {
            secondsLabelButton.setTitleColor(secondsColor, for: .normal)
        }
    }
    
    @IBInspectable
    var amPmFont: UIFont = .systemFont(ofSize: 30) {
        didSet {
            refreshFonts()
        }
    }
    
    @IBInspectable
    var timeFont: UIFont = .systemFont(ofSize: 60) {
        didSet {
            refreshFonts()
        }
    }
    
    // MARK: - Callbacks
    
    var onHoursTapped: (() -> Void)?
    var onMinutesTapped: (() -> Void)?
    var onSecondsTapped: (() -> Void)?
    var onAmTapped: (() -> Void)?
    var onPmTapped: (() -> Void)?
    
    // MARK: - Properties
    
    private var timeIndicationFontSize: CGFloat {
        if enableSeconds {
            return timeFormat == .twelve ? 48 : 56
        }
        return 60
    }
    private var amPmIndicatorFontSize: CGFloat {
        return enableSeconds ? 26 : 30
    }
    
    var timeFormat: DroidTimeFormat = .twelve {
        didSet {
            onTimeFormatChanged()
        }
    }
    
    var enableSeconds: Bool = false {
        didSet {
            onEnableSecondsChanged()
        }
    }
    
    var time: Time = .init() {
        didSet {
            onCurrentTimeChanged()
        }
    }
    
    // MARK: - Components
    
    private lazy var hoursLabelButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(hoursTapped), for: .touchUpInside)
        button.isAccessibilityElement = true
        button.accessibilityLabel
            = "Button showing the hours value. Tap to change to hour selection."
        return button
    }()
    
    private lazy var secondsLabelButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(secondsTapped), for: .touchUpInside)
        button.isAccessibilityElement = true
        button.accessibilityLabel
            = "Button showing the seconds value. Tap to change to seconds selection."
        return button
    }()
    
    private lazy var minutesLabelButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(minutesTapped), for: .touchUpInside)
        button.isAccessibilityElement = true
        button.accessibilityLabel
            = "Button showing the minutes value. Tap to change to minute selection."
        return button
    }()
    
    private lazy var timeStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 0
        stack.addArrangedSubview(hoursLabelButton)
        stack.addArrangedSubview(minutesLabelButton)
        stack.addArrangedSubview(secondsLabelButton)
        return stack
    }()
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 8
        stack.addArrangedSubview(timeStack)
        stack.addArrangedSubview(amPmStack)
        return stack
    }()
    
    private lazy var amPmStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 4
        stack.addArrangedSubview(amLabelButton)
        stack.addArrangedSubview(pmLabelButton)
        return stack
    }()
    
    private lazy var amLabelButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(amTapped), for: .touchUpInside)
        button.setTitle("AM", for: .normal)
        button.isAccessibilityElement = true
        button.accessibilityLabel
            = "Button showing the AM value. Tap to change time to AM"
        return button
    }()
    
    private lazy var pmLabelButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(pmTapped), for: .touchUpInside)
        button.setTitle("PM", for: .normal)
        button.isAccessibilityElement = true
        button.accessibilityLabel
            = "Button showing the PM value. Tap to change time to PM"
        return button
    }()
    
    // MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(contentStack)
        contentStack.anchor(in: self)
    }
    
    // MARK: - Actions
    
    @objc private func hoursTapped() {
        onHoursTapped?()
    }
    
    @objc private func secondsTapped() {
        onSecondsTapped?()
    }
    
    @objc private func minutesTapped() {
        onMinutesTapped?()
    }
    
    @objc private func amTapped() {
        onAmTapped?()
    }
    
    @objc private func pmTapped() {
        onPmTapped?()
    }
    
    // MARK: - Helpers
    
    private func refreshFonts() {
        amLabelButton.titleLabel?.font = amPmFont.withSize(amPmIndicatorFontSize)
        pmLabelButton.titleLabel?.font = amPmFont.withSize(amPmIndicatorFontSize)
        hoursLabelButton.titleLabel?.font = timeFont.withSize(timeIndicationFontSize)
        minutesLabelButton.titleLabel?.font = timeFont.withSize(timeIndicationFontSize)
        secondsLabelButton.titleLabel?.font = timeFont.withSize(timeIndicationFontSize)
    }
    
    private func onEnableSecondsChanged() {
        secondsLabelButton.isHidden = !enableSeconds
        refreshFonts()
        onTimeFormatChanged()
    }
    
    private func onTimeFormatChanged() {
        amPmStack.isHidden = timeFormat != .twelve
        secondsLabelButton.isHidden = !enableSeconds
        onCurrentTimeChanged()
    }
    
    private func onCurrentTimeChanged() {
        let hours = timeFormat == .twelve ?
            time.twelveHoursFormat.hours
            : time.twentyFourHoursFormat.hours
        let minutes = timeFormat == .twelve ?
            time.twelveHoursFormat.minutes
            : time.twentyFourHoursFormat.minutes
        let seconds = timeFormat == .twelve ?
            time.twelveHoursFormat.seconds
            : time.twentyFourHoursFormat.seconds
        let hourFormatter = Formatters.hourFormatter
        hourFormatter.zeroFormattingBehavior = timeFormat != .twelve
            ? .pad
            : .default
        let hoursText = hourFormatter
            .string(from: TimeInterval(hours * 3600))
        let minutesText = Formatters.minutesFormatter
            .string(from: TimeInterval(minutes * 60)) ?? ""
        let secondsText = Formatters.secondsFormatter
            .string(from: TimeInterval(seconds)) ?? ""
        hoursLabelButton.setTitle(hoursText, for: .normal)
        minutesLabelButton.setTitle(":\(minutesText)", for: .normal)
        secondsLabelButton.setTitle(":\(secondsText)", for: .normal)
    }
}
