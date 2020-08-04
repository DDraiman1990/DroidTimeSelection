//
//  DroidClockSelector.swift
//  DroidTimeSelection
//
//  Created by Dan Draiman on 7/22/20.
//  Copyright © 2020 Nexxmark Studio. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
@IBDesignable
public class DroidClockSelector: UIView {
    
    // MARK: - Storyboard
    
    @IBInspectable
    public var largeSelectionColor: UIColor = .white {
        didSet {
            self.config.largeSelectionColor = self.largeSelectionColor
        }
    }
    @IBInspectable
    public var smallSelectionColor: UIColor = .gray {
        didSet {
            self.config.smallSelectionColor = self.smallSelectionColor
        }
    }
    @IBInspectable
    public var timeColor: UIColor = .gray {
        didSet {
            self.config.timeColor = self.timeColor
        }
    }
    @IBInspectable
    public var highlightedTimeColor: UIColor = .white {
        didSet {
            self.config.highlightedTimeColor = self.highlightedTimeColor
        }
    }
    @IBInspectable
    public var selectionIndicatorColor: UIColor = .systemTeal {
        didSet {
            self.config.selectionIndicatorColor = self.selectionIndicatorColor
        }
    }
    @IBInspectable
    public var selectionBackgroundColor: UIColor = .clear {
        didSet {
            self.config.selectionBackgroundColor = self.selectionBackgroundColor
        }
    }
    @IBInspectable
    public var timeFormat24H: Bool = true {
        didSet {
            self.config.timeFormat = timeFormat24H ? .twentyFour : .twelve
        }
    }
    
    // MARK: - Public Properties
    
    /// The value for this selector.
    public var time: Time {
        return currentTime
    }
    
    /// Will be called for every change in Time value.
    public var onSelectionChanged: ((Time) -> Void)?
    
    /// The configuration for this selector.
    public var config: DroidClockSelectorConfiguration {
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
    
    private enum SelectionMode {
        case hour, minutes
    }
    
    private var currentConfig: DroidClockSelectorConfiguration = .init()

    private var currentTime: Time = .init() {
        didSet {
            onSelectionChanged?(currentTime)
            onCurrentTimeChanged()
        }
    }
    private var currentMode: SelectionMode = .hour

    private let hapticGenerator = UINotificationFeedbackGenerator()
    private var latestSelectionLocation: CGPoint?
    private var cellSelected: DroidClockSelectorCell?
    
    private let outerHours = [12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    private let innerHours = [0, 13, 14, 15, 16, 17, 18, 19, 20 ,21, 22, 23]
    private let minutes = Array(0...59)
    
    // MARK: - Formatters
    
    private let cellTimeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour]
        formatter.zeroFormattingBehavior = .pad //Depending on AM or PM
        return formatter
    }()
    
    private let hourFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour]
        formatter.zeroFormattingBehavior = .default //Depending on AM or PM
        return formatter
    }()
    
    private let minutesFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute]
        formatter.zeroFormattingBehavior = .pad //Depending on AM or PM
        return formatter
    }()
    
    // MARK: - UI Components
    
    private lazy var hoursLabelButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = config.timeFont
        button.setTitleColor(config.timeColor, for: .normal)
        button.addTarget(self, action: #selector(onHoursTapped), for: .touchUpInside)
        button.isAccessibilityElement = true
        button.accessibilityLabel
            = "Button showing the hours value. Tap to change to hour selection."
        return button
    }()
    
    private lazy var minutesLabelButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = config.timeFont
        button.setTitleColor(config.timeColor, for: .normal)
        button.addTarget(self, action: #selector(onMinutesTapped), for: .touchUpInside)
        button.isAccessibilityElement = true
        button.accessibilityLabel
            = "Button showing the minutes value. Tap to change to minute selection."
        return button
    }()
    
    private let timeStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 0
        return stack
    }()
    
    private let timeContentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()
    
    private let amPmStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 4
        return stack
    }()
    
    private lazy var amLabelButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = config.amPmFont
        button.setTitleColor(config.timeColor, for: .normal)
        button.addTarget(self, action: #selector(onAmTapped), for: .touchUpInside)
        button.setTitle("AM", for: .normal)
        button.isAccessibilityElement = true
        button.accessibilityLabel
            = "Button showing the AM value. Tap to change time to AM"
        return button
    }()
    
    private lazy var pmLabelButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = config.amPmFont
        button.setTitleColor(config.timeColor, for: .normal)
        button.addTarget(self, action: #selector(onPmTapped), for: .touchUpInside)
        button.setTitle("PM", for: .normal)
        button.isAccessibilityElement = true
        button.accessibilityLabel
            = "Button showing the PM value. Tap to change time to PM"
        return button
    }()
    
    private lazy var selectionLineLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = config.selectionIndicatorColor.cgColor
        layer.lineWidth = 1.0
        return layer
    }()
    
    private lazy var selectionCircleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = config.selectionIndicatorColor.cgColor
        layer.strokeColor = config.selectionIndicatorColor.cgColor
        layer.lineWidth = 1.0
        return layer
    }()
    
    private let selectionCircleCenterLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.black.cgColor
        layer.strokeColor = UIColor.black.cgColor
        layer.lineWidth = 1.0
        return layer
    }()
    
    private lazy var middleCircleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = config.selectionIndicatorColor.cgColor
        layer.strokeColor = config.selectionIndicatorColor.cgColor
        layer.lineWidth = 1.0
        return layer
    }()
    
    private lazy var topColorView: UIView = {
        let view = UIView()
        view.backgroundColor = config.selectionIndicatorColor
        return view
    }()
    
    private let circularCollectionLayout = DroidCircularCollectionViewLayout()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: circularCollectionLayout)
        collection.register(DroidClockSelectorCell.self, forCellWithReuseIdentifier: DroidClockSelectorCell.cellId)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        return collection
    }()
    
    // MARK: - Gesture Recognizers
    
    private lazy var touchRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTouchView(_:)))
        recognizer.cancelsTouchesInView = false
        recognizer.delegate = self
        return recognizer
    }()
    
    private lazy var panRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanView(_:)))
        recognizer.cancelsTouchesInView = false
        return recognizer
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
        layer.addSublayer(middleCircleLayer)
        layer.addSublayer(selectionLineLayer)
        topColorView.layer.mask = selectionCircleLayer
        topColorView.layer.addSublayer(selectionCircleCenterLayer)
        
        //Time stack must be added last to be on top of topColorView
        addSubview(collectionView)
        insertSubview(topColorView, belowSubview: collectionView)
        addSubview(timeContentStack)

        timeContentStack.anchor(
            in: self,
            to: [.top],
            padding: .init(top: 28, left: 28, bottom: 28, right: 28))
        timeContentStack
            .widthAnchor
            .constraint(lessThanOrEqualTo: widthAnchor,
                        multiplier: 0.8)
            .isActive = true
        timeContentStack.centerX(in: self)
        collectionView
            .topAnchor
            .constraint(equalTo: timeContentStack.bottomAnchor)
            .isActive = true
        collectionView.anchor(
            in: self,
            to: [.bottom, .left, .right],
            padding: .init(top: 12, left: 12, bottom: 12, right: 12))
        collectionView
            .widthAnchor
            .constraint(equalTo: collectionView.heightAnchor,
                        multiplier: 1.0)
            .isActive = true
        topColorView.anchor(in: self)
        
        timeStack.addArrangedSubview(hoursLabelButton)
        timeStack.addArrangedSubview(minutesLabelButton)
        timeContentStack.addArrangedSubview(timeStack)
        timeContentStack.addArrangedSubview(amPmStack)
        
        amPmStack.addArrangedSubview(amLabelButton)
        amPmStack.addArrangedSubview(pmLabelButton)
        
        self.addGestureRecognizer(touchRecognizer)
        self.addGestureRecognizer(panRecognizer)
        self.isUserInteractionEnabled = true
        
        reset()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        middleCircleLayer.path = UIBezierPath(
            arcCenter: collectionView.center,
            radius: collectionView.frame.width / 95,
            startAngle: CGFloat(0),
            endAngle: CGFloat(Double.pi * 2),
            clockwise: true)
            .cgPath
    }
    
    // MARK: - Actions

    @objc private func onHoursTapped() {
        changeMode(to: .hour) { _ in
            switch self.config.timeFormat {
            case .twelve:
                self.moveIndicatorToHour(self.time.twelveHoursFormat.hours)
            case .twentyFour:
                self.moveIndicatorToHour(self.time.twentyFourHoursFormat.hours)
            }
        }
    }
    
    @objc private func onMinutesTapped() {
        changeMode(to: .minutes) { _ in
            switch self.config.timeFormat {
            case .twelve:
                self.moveIndicatorToMinute(self.time.twelveHoursFormat.minutes)
            case .twentyFour:
                self.moveIndicatorToMinute(self.time.twentyFourHoursFormat.minutes)
            }
        }
    }
    
    @objc private func onAmTapped() {
        currentTime.twelveHoursFormat.am = true
        set(hour: time.twelveHoursFormat.hours,
            minutes: time.twelveHoursFormat.minutes,
            am: true)
    }
    
    @objc private func onPmTapped() {
        currentTime.twelveHoursFormat.am = false
        set(hour: time.twelveHoursFormat.hours,
            minutes: time.twelveHoursFormat.minutes,
            am: false)
    }
    
    @objc private func didPanView(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            let location = gesture.location(ofTouch: 0, in: collectionView)
            guard let selection = selectionForGesture(at: location) else {
                return
            }
            let selectionLocation = convert(selection.0.center, from: collectionView)
            cellSelected = selection.0
            latestSelectionLocation = selectionLocation
            moveIndicator(
                to: selectionLocation,
                selectionSize: circularCollectionLayout.sizeForItem(at: selection.1),
                emptyIndicatorCircle: selection.0.isTransparent)
            switch currentMode {
            case .hour:
                selectHour(value: selection.0.value)
            case .minutes:
                selectMinutes(value: selection.0.value)
            }
        case .ended:
            if cellSelected != nil {
                switch currentMode {
                case .hour:
                    changeMode(to: .minutes) { _ in
                        switch self.config.timeFormat {
                        case .twelve:
                            self.moveIndicatorToMinute(self
                                .time
                                .twelveHoursFormat
                                .minutes)
                        case .twentyFour:
                            self.moveIndicatorToMinute(self
                                .time
                                .twentyFourHoursFormat
                                .minutes)
                        }
                    }
                case .minutes: break
                }
            }
        default: break
        }
    }
    
    @objc private func didTouchView(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(ofTouch: 0, in: collectionView)
        guard let selection = selectionForGesture(at: location) else {
            return
        }
        let selectionLocation = convert(selection.0.center, from: collectionView)
        moveIndicator(
            to: selectionLocation,
            selectionSize: circularCollectionLayout.sizeForItem(at: selection.1),
            emptyIndicatorCircle: selection.0.isTransparent)
        switch currentMode {
        case .hour:
            selectHour(value: selection.0.value)
            changeMode(to: .minutes) { _ in
                switch self.config.timeFormat {
                case .twelve:
                    self.moveIndicatorToMinute(self.time.twelveHoursFormat.minutes)
                case .twentyFour:
                    self.moveIndicatorToMinute(self.time.twentyFourHoursFormat.minutes)
                }
            }
        case .minutes:
            selectMinutes(value: selection.0.value)
        }
    }
    
    private func selectionForGesture(at location: CGPoint)
        -> (DroidClockSelectorCell, IndexPath)? {
            guard let indexPath = collectionView.indexPathForItem(at: location),
                let cell = collectionView
                    .cellForItem(at: indexPath) as? DroidClockSelectorCell else {
                        return nil
            }
            let newLocation = convert(cell.center, from: collectionView)
            if let latest = latestSelectionLocation,
                newLocation == latest {
                return nil
            }
            return (cell, indexPath)
    }
    
    // MARK: - Indicator Logic
    
    private func moveIndicatorToHour(_ hour: Int) {
        var index: Array<Int>.Index
        var indexPath: IndexPath
        if config.timeFormat == .twelve {
            let hour = hour == 0 ? 12 : hour
            index = outerHours.firstIndex(of: hour) ?? 0
            indexPath = IndexPath(item: index, section: 0)
        } else {
            if hour == 0 || hour > outerHours.max() ?? 0 {
                index = innerHours.firstIndex(of: hour) ?? 0
                indexPath = IndexPath(item: index, section: 1)
            } else {
                index = outerHours.firstIndex(of: hour) ?? 0
                indexPath = IndexPath(item: index, section: 0)
            }
        }
        guard let cell = collectionView
            .cellForItem(at: indexPath) as? DroidClockSelectorCell else {
            return
        }
        let size = circularCollectionLayout.sizeForItem(at: indexPath)
        moveIndicator(
            to: convert(cell.center, from: collectionView),
            selectionSize: size,
            emptyIndicatorCircle: cell.isTransparent)
    }
    
    private func moveIndicatorToMinute(_ minute: Int) {
        let index = minutes.firstIndex(of: minute) ?? 0
        let indexPath = IndexPath(item: index, section: 0)
        guard let cell = collectionView
            .cellForItem(at: indexPath) as? DroidClockSelectorCell else {
                return
        }
        let size = circularCollectionLayout.sizeForItem(at: indexPath)
        moveIndicator(
            to: convert(cell.center, from: collectionView),
            selectionSize: size,
            emptyIndicatorCircle: cell.isTransparent)
    }
    
    private func moveIndicator(to location: CGPoint,
                               selectionSize: CGSize,
                               emptyIndicatorCircle: Bool = false) {
        let path = UIBezierPath()
        path.move(to: collectionView.center)
        path.addLine(to: location)
        selectionLineLayer.path = path.cgPath
        if emptyIndicatorCircle {
            selectionCircleCenterLayer.path = UIBezierPath(
                arcCenter: location,
                radius: selectionSize.width / 14,
                startAngle: CGFloat(0),
                endAngle: CGFloat(Double.pi * 2),
                clockwise: true)
                .cgPath
        } else {
            selectionCircleCenterLayer.path = nil
        }
        selectionCircleLayer.path = UIBezierPath(
            arcCenter: location,
            radius: selectionSize.width / 2,
            startAngle: CGFloat(0),
            endAngle: CGFloat(Double.pi * 2),
            clockwise: true)
            .cgPath
        hapticGenerator.notificationOccurred(.warning)
    }
    
    private func moveIndicatorToReflectSelection() {
        switch currentMode {
        case .hour:
            switch self.config.timeFormat {
            case .twelve:
                self.moveIndicatorToHour(self.time.twelveHoursFormat.hours)
            case .twentyFour:
                self.moveIndicatorToHour(self.time.twentyFourHoursFormat.hours)
            }
        case .minutes:
            switch self.config.timeFormat {
            case .twelve:
                self.moveIndicatorToMinute(self.time.twelveHoursFormat.minutes)
            case .twentyFour:
                self.moveIndicatorToMinute(self.time.twentyFourHoursFormat.minutes)
            }
        }
    }
    
    // MARK: - Helpers
    
    private func selectHour(value: Int) {
        switch config.timeFormat {
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
        DispatchQueue.main.async {
            UIView.transition(
                with: self.collectionView,
                duration: 0.35,
                options: .transitionCrossDissolve,
                animations: { self.collectionView.reloadData() },
                completion: completion)
        }
        highlight(mode: currentMode)
        moveIndicatorToReflectSelection()
    }
    
    private func onConfigChanged() {
        reloadData()
        highlight(mode: currentMode)
        
        selectionLineLayer.strokeColor = config.selectionIndicatorColor.cgColor
        selectionCircleLayer.fillColor = config.selectionIndicatorColor.cgColor
        selectionCircleLayer.strokeColor = config.selectionIndicatorColor.cgColor
        middleCircleLayer.fillColor = config.selectionIndicatorColor.cgColor
        middleCircleLayer.strokeColor = config.selectionIndicatorColor.cgColor
        topColorView.backgroundColor = config.selectionIndicatorColor
        
        onTimeFormatChanged()
    }
    
    private func highlight(mode: SelectionMode) {
        hoursLabelButton
            .setTitleColor(mode == .hour ?
                config.highlightedTimeColor
                : config.timeColor, for: .normal)
        minutesLabelButton
            .setTitleColor(mode == .minutes ?
                config.highlightedTimeColor
                : config.timeColor, for: .normal)
        if let isAm = time.twelveHoursFormat.am {
            amLabelButton
                .setTitleColor(isAm ?
                    config.highlightedTimeColor
                    : config.timeColor, for: .normal)
            pmLabelButton
                .setTitleColor(!isAm ?
                    config.highlightedTimeColor
                    : config.timeColor, for: .normal)
        }
    }
    
    private func onCurrentTimeChanged() {
        let hours = config.timeFormat == .twelve ?
            time.twelveHoursFormat.hours
            : time.twentyFourHoursFormat.hours
        let minutes = config.timeFormat == .twelve ?
            time.twelveHoursFormat.minutes
            : time.twentyFourHoursFormat.minutes
        let hoursText = hourFormatter
            .string(from: TimeInterval(hours * 3600))
        let minutesText = minutesFormatter
            .string(from: TimeInterval(minutes * 60)) ?? ""
        hoursLabelButton.setTitle(hoursText, for: .normal)
        minutesLabelButton.setTitle(":\(minutesText)", for: .normal)
        
        highlight(mode: currentMode)
    }
        
    private func changeMode(to mode: SelectionMode, completion: ((Bool) -> Void)?) {
        currentMode = mode
        onModeChanged(completion: completion)
    }
    
    private func onTimeFormatChanged() {
        amPmStack.isHidden = config.timeFormat != .twelve
        hourFormatter.zeroFormattingBehavior = config.timeFormat != .twelve
            ? .pad
            : .default
        onCurrentTimeChanged()
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
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
            switch self.config.timeFormat {
            case .twelve:
                self.moveIndicatorToHour(self.time.twelveHoursFormat.hours)
            case .twentyFour:
                self.moveIndicatorToHour(self.time.twentyFourHoursFormat.hours)
            }
        }
        onConfigChanged()
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension DroidClockSelector: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return currentMode == .minutes ?
                minutes.count
                : outerHours.count
        case 1:
            return currentMode == .minutes || config.timeFormat == .twelve ?
                0
                : innerHours.count
        default:
            return 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            guard let cell = collectionView
                .dequeueReusableCell(
                    withReuseIdentifier: DroidClockSelectorCell.cellId,
                    for: indexPath)
                as? DroidClockSelectorCell else {
                    return UICollectionViewCell()
            }
            switch indexPath.section {
            case 0:
                switch currentMode {
                case .hour:
                    guard outerHours.indices ~= indexPath.row else {
                        return UICollectionViewCell()
                    }
                    let selection = outerHours[indexPath.row]
                    cell.setup(
                        label: "\(selection)",
                        value: selection,
                        bgColor: config.selectionBackgroundColor,
                        titleColor: config.largeSelectionColor,
                        titleFont: config.largeSelectionFont)
                case .minutes:
                    guard minutes.indices ~= indexPath.row else {
                        return UICollectionViewCell()
                    }
                    let selection = minutes[indexPath.row]
                    let shouldDisplayCustomization = selection % 5 == 0
                    let label =
                         shouldDisplayCustomization ?
                            cellTimeFormatter.string(
                                from: TimeInterval(selection * 3600)) ?? "N/A"
                            : ""
                    let bgColor: UIColor = shouldDisplayCustomization ? config.selectionBackgroundColor : .clear
                    cell.setup(
                        label: label,
                        value: selection,
                        bgColor: bgColor,
                        titleColor: config.largeSelectionColor,
                        titleFont: config.largeSelectionFont)
                }
            case 1:
                guard config.timeFormat == .twentyFour else {
                    return UICollectionViewCell()
                }
                guard innerHours.indices ~= indexPath.row else {
                    return UICollectionViewCell()
                }
                let selection = innerHours[indexPath.row]
                cell.setup(
                    label: cellTimeFormatter
                        .string(from: TimeInterval(selection * 3600)) ?? "N/A",
                    value: selection,
                    bgColor: config.selectionBackgroundColor,
                    titleColor: config.smallSelectionColor,
                    titleFont: config.smallSelectionFont)
            default: break
            }
            return cell
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
}

extension DroidClockSelector: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer)
        -> Bool {
            return true
    }
}
