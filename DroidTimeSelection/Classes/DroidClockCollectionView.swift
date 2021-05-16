//
//  DroidClockCollectionView.swift
//  DroidTimeSelection
//
//  Created by Dan Draiman on 3/27/21.
//  Copyright © 2020 Nexxmark Studio. All rights reserved.
//

import UIKit

@IBDesignable
final class DroidClockCollectionView: UIView {
    
    // MARK: - Callbacks
    
    var onHourSelectionEnded: ((Int) -> Void)?
    var onMinuteSelectionEnded: ((Int) -> Void)?
    var onSecondSelectionEnded: ((Int) -> Void)?
    
    var onHourSelected: ((Int) -> Void)?
    var onMinuteSelected: ((Int) -> Void)?
    var onSecondSelected: ((Int) -> Void)?
    
    // MARK: - Storyboard Properties
    
    @IBInspectable
    public var indicatorColor: UIColor = .blue {
        didSet {
            selectionLineLayer.strokeColor = indicatorColor.cgColor
            selectionCircleLayer.fillColor = indicatorColor.cgColor
            selectionCircleLayer.strokeColor = indicatorColor.cgColor
            middleCircleLayer.fillColor = indicatorColor.cgColor
            middleCircleLayer.strokeColor = indicatorColor.cgColor
            topColorView.backgroundColor = indicatorColor
        }
    }
    
    @IBInspectable
    var outerCircleTextColor: UIColor = .white {
        didSet {
            self.reloadData()
        }
    }
    @IBInspectable
    var outerCircleBackgroundColor: UIColor = .clear {
        didSet {
            self.reloadData()
        }
    }
    @IBInspectable
    var innerCircleTextColor: UIColor = .gray {
        didSet {
            self.reloadData()
        }
    }
    @IBInspectable
    var innerCircleBackgroundColor: UIColor = .clear {
        didSet {
            self.reloadData()
        }
    }
    @IBInspectable
    var numbersFont: UIFont = .systemFont(ofSize: 18) {
        didSet {
            self.reloadData()
        }
    }
        
    // MARK: - Properties
    
    private let hapticGenerator = UINotificationFeedbackGenerator()
    private var latestSelectionLocation: CGPoint?
    private var cellSelected: DroidClockSelectorCell?
    private let outerHours = [12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    private let innerHours = [0, 13, 14, 15, 16, 17, 18, 19, 20 ,21, 22, 23]
    private let minutes = Array(0...59)
    private let seconds = Array(0...59)
    
    private var selectedHour: Int = 0
    private var selectedMinute: Int = 0
    private var selectedSecond: Int = 0
    
    public var currentMode: ClockSelectionMode = .hour {
        didSet {
            reloadData()
        }
    }
    public var timeFormat: DroidTimeFormat = .twelve {
        didSet {
            reloadData()
        }
    }
    
    public var enableSeconds: Bool = false {
        didSet {
            reloadData()
        }
    }
    
    // MARK: - Components
    
    private lazy var selectionLineLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 1.0
        return layer
    }()
    
    private lazy var selectionCircleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
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
        layer.lineWidth = 1.0
        return layer
    }()
    
    private lazy var topColorView: UIView = {
        let view = UIView()
        view.layer.mask = selectionCircleLayer
        view.layer.addSublayer(selectionCircleCenterLayer)
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
    
    init() {
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
        
        //Time stack must be added last to be on top of topColorView
        addSubview(collectionView)
        insertSubview(topColorView, belowSubview: collectionView)
        collectionView.anchor(in: self)
        topColorView.anchor(in: self)
        
        self.addGestureRecognizer(touchRecognizer)
        self.addGestureRecognizer(panRecognizer)
        self.isUserInteractionEnabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.moveIndicatorToHour(self.selectedHour)
            self.moveIndicatorToMinute(self.selectedMinute)
            self.moveIndicatorToSecond(self.selectedSecond)
        }
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
                selectedHour = selection.0.value
                onHourSelected?(selection.0.value)
            case .minutes:
                selectedMinute = selection.0.value
                onMinuteSelected?(selection.0.value)
            case .seconds:
                selectedSecond = selection.0.value
                onSecondSelected?(selection.0.value)
            }
        case .ended:
            if cellSelected != nil {
                switch currentMode {
                case .hour:
                    onHourSelectionEnded?(selectedHour)
                case .minutes:
                    if enableSeconds {
                        onMinuteSelectionEnded?(selectedMinute)
                    }
                default:
                    break
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
            selectedHour = selection.0.value
            onHourSelected?(selection.0.value)
            onHourSelectionEnded?(selection.0.value)
        case .minutes:
            selectedMinute = selection.0.value
            onMinuteSelected?(selection.0.value)
            onMinuteSelectionEnded?(selection.0.value)
        case .seconds:
            selectedSecond = selection.0.value
            onSecondSelected?(selection.0.value)
            onSecondSelectionEnded?(selection.0.value)
        }
    }
    
    // MARK: - Indicator Logic | Public
    
    public func moveIndicator(toTime time: Time) {
        switch currentMode {
        case .hour:
            let hour = timeFormat == .twelve ?
                time.twelveHoursFormat.hours :
                time.twentyFourHoursFormat.hours
            moveIndicatorToHour(hour)
        case .minutes:
            let minutes = timeFormat == .twelve ?
                time.twelveHoursFormat.minutes :
                time.twentyFourHoursFormat.minutes
            moveIndicatorToMinute(minutes)
        case .seconds:
            let seconds = timeFormat == .twelve ?
                time.twelveHoursFormat.seconds :
                time.twentyFourHoursFormat.seconds
            moveIndicatorToSecond(seconds)
        }
    }
    
    public func moveIndicatorToHour(_ hour: Int) {
        guard currentMode == .hour else {
            return
        }
        var index: Array<Int>.Index
        var indexPath: IndexPath
        if timeFormat == .twelve {
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
    
    public func moveIndicatorToMinute(_ minute: Int) {
        guard currentMode == .minutes else {
            return
        }
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
    
    public func moveIndicatorToSecond(_ second: Int) {
        guard currentMode == .seconds else {
            return
        }
        let index = seconds.firstIndex(of: second) ?? 0
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
    
    // MARK: - Helpers | Public
    
    public func set(time: Time) {
        switch timeFormat {
        case .twelve:
            selectedHour = time.twelveHoursFormat.hours
            selectedMinute = time.twelveHoursFormat.minutes
            selectedSecond = time.twelveHoursFormat.seconds
        case .twentyFour:
            selectedHour = time.twentyFourHoursFormat.hours
            selectedMinute = time.twentyFourHoursFormat.minutes
            selectedSecond = time.twentyFourHoursFormat.seconds
        }
    }
    
    public func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Indicator Logic | Private
    
    private func selectionForGesture(at location: CGPoint)
    -> (DroidClockSelectorCell, IndexPath)? {
        let cells = collectionView
            .visibleCells
            .filter({ $0.frame.contains(location) })
            .compactMap({$0 as? DroidClockSelectorCell})
            .sorted { lhs, rhs in
                lhs.center.distance(to: location) < rhs.center.distance(to: location)
            }
        guard let cell = cells.first,
              let indexPath = collectionView.indexPath(for: cell) else {
            return nil
        }
        let newLocation = convert(cell.center, from: collectionView)
        if let latest = latestSelectionLocation,
           newLocation == latest {
            return nil
        }
        return (cell, indexPath)
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
}

extension DroidClockCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            switch currentMode {
            case .hour:
                return outerHours.count
            case .minutes:
                return minutes.count
            case .seconds:
                return seconds.count
            }
        case 1:
            switch currentMode {
            case .hour:
                return timeFormat == .twelve ? 0 : innerHours.count
            case .minutes, .seconds:
                return 0
            }
        default:
            return 0
        }
    }
    
    enum CellPresentConfig {
        case showAll, showEvery(amount: Int)
    }
    
    private func config(cell: DroidClockSelectorCell,
                        index: Int,
                        values: [Int],
                        fontSize: Int,
                        presentation: CellPresentConfig = .showAll) -> Bool {
        guard values.indices ~= index else {
            return false
        }
        let selection = values[index]
        var bgColor: UIColor = outerCircleBackgroundColor
        var label: String = Formatters.cellTimeFormatter.string(
            from: TimeInterval(selection * 3600)) ?? ""
        switch presentation {
        case .showAll:
            break
        case .showEvery(let amount):
            let shouldDisplayCustomization = selection % amount == 0
            if !shouldDisplayCustomization {
                label = ""
                bgColor = .clear
            }
        }
        cell.setup(
            label: label,
            value: selection,
            bgColor: bgColor,
            titleColor: outerCircleTextColor,
            titleFont: numbersFont.withSize(18))
        return true
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
                    guard config(cell: cell,
                           index: indexPath.row,
                           values: outerHours,
                           fontSize: 18,
                           presentation: .showAll) else {
                        return UICollectionViewCell()
                    }
                case .minutes:
                    guard config(cell: cell,
                           index: indexPath.row,
                           values: minutes,
                           fontSize: 14,
                           presentation: .showEvery(amount: 5)) else {
                        return UICollectionViewCell()
                    }
                case .seconds:
                    guard config(cell: cell,
                           index: indexPath.row,
                           values: seconds,
                           fontSize: 14,
                           presentation: .showEvery(amount: 5)) else {
                        return UICollectionViewCell()
                    }
                }
            case 1:
                guard timeFormat == .twentyFour else {
                    return UICollectionViewCell()
                }
                guard innerHours.indices ~= indexPath.row else {
                    return UICollectionViewCell()
                }
                let selection = innerHours[indexPath.row]
                cell.setup(
                    label: Formatters.cellTimeFormatter
                        .string(from: TimeInterval(selection * 3600)) ?? "N/A",
                    value: selection,
                    bgColor: innerCircleBackgroundColor,
                    titleColor: innerCircleTextColor,
                    titleFont: numbersFont.withSize(14))
            default: break
            }
            return cell
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
}

extension DroidClockCollectionView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer)
        -> Bool {
            return true
    }
}

private extension CGPoint {
    func distanceSquared(to: CGPoint) -> CGFloat {
        return (self.x - to.x) * (self.x - to.x) + (self.y - to.y) * (self.y - to.y)
    }

    func distance(to: CGPoint) -> CGFloat {
        return sqrt(self.distanceSquared(to: to))
    }
}
