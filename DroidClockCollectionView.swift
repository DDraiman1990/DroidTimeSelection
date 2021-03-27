//
//  DroidClockCollectionView.swift
//  DroidTimeSelection
//
//  Created by Dan Draiman on 3/27/21.
//

import UIKit

final class DroidClockCollectionView: UIView {
    
    var onHourSelectionEnded: ((Int) -> Void)?
    var onMinuteSelectionEnded: ((Int) -> Void)?
    
    var onHourSelected: ((Int) -> Void)?
    var onMinuteSelected: ((Int) -> Void)?
    
    // MARK: - Storyboard
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
    
    private var selectedHour: Int = 0
    private var selectedMinute: Int = 0
    
    internal var currentMode: ClockSelectionMode = .hour {
        didSet {
            reloadData()
        }
    }
    internal var timeFormat: DroidTimeFormat = .twelve {
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
    
    init() {
        super.init(frame: .zero)
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
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            }
        case .ended:
            if cellSelected != nil {
                switch currentMode {
                case .hour:
                    onHourSelectionEnded?(selectedHour)
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
            selectedHour = selection.0.value
            onHourSelected?(selection.0.value)
            onHourSelectionEnded?(selection.0.value)
        case .minutes:
            selectedMinute = selection.0.value
            onMinuteSelected?(selection.0.value)
            onMinuteSelectionEnded?(selection.0.value)
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
    
    // MARK: - Indicator Logic | Public
    
    public func moveIndicatorToHour(_ hour: Int) {
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
    
    // MARK: - Helpers | Public
    
    public func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Indicator Logic | Private
    
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
            return currentMode == .minutes ?
                minutes.count
                : outerHours.count
        case 1:
            return currentMode == .minutes || timeFormat == .twelve ?
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
                        bgColor: outerCircleBackgroundColor,
                        titleColor: outerCircleTextColor,
                        titleFont: numbersFont.withSize(18))
                case .minutes:
                    guard minutes.indices ~= indexPath.row else {
                        return UICollectionViewCell()
                    }
                    let selection = minutes[indexPath.row]
                    let shouldDisplayCustomization = selection % 5 == 0
                    let label =
                         shouldDisplayCustomization ?
                        Formatters.cellTimeFormatter.string(
                                from: TimeInterval(selection * 3600)) ?? "N/A"
                            : ""
                    let bgColor: UIColor = shouldDisplayCustomization ? outerCircleBackgroundColor : .clear
                    cell.setup(
                        label: label,
                        value: selection,
                        bgColor: bgColor,
                        titleColor: outerCircleTextColor,
                        titleFont: numbersFont.withSize(18))
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
