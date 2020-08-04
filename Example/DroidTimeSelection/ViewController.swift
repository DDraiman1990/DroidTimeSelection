//
//  ViewController.swift
//  DroidTimeSelection
//
//  Created by DDraiman1990 on 07/25/2020.
//  Copyright © 2020 Nexxmark Studio. All rights reserved.
//

import UIKit
import DroidTimeSelection

class ViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var timeFormatSwitch: UISwitch!
    
    // MARK: - Configurations
    
    private var config: DroidTimeSelectionConfiguration = {
        var config = DroidTimeSelectionConfiguration()
        
        //Menu
//        config.okButtonText = "TEST"
//        config.okButtonColor = .green
//        config.cancelButtonColor = .red
//        config.cancelButtonText = "STAP"
//        config.modeButtonColor = .blue
        
        //Clock
//        config.clockConfig.amPmFont = .systemFont(ofSize: 20, weight: .black)
//        config.clockConfig.highlightedTimeColor = .red
//        config.clockConfig.largeSelectionColor = .blue
//        config.clockConfig.largeSelectionFont = .systemFont(ofSize: 10, weight: .regular)
//        config.clockConfig.selectionBackgroundColor = .gray
//        config.clockConfig.selectionIndicatorColor = .magenta
//        config.clockConfig.smallSelectionColor = .magenta
//        config.clockConfig.smallSelectionFont = .systemFont(ofSize: 10, weight: .light)
//        config.clockConfig.timeColor = .cyan
//        config.clockConfig.timeFont = .systemFont(ofSize: 15, weight: .black)
        return config
    }()
    
    private var timeFormat: DroidTimeFormat = .twelve {
        didSet {
            config.timeFormat = timeFormat
        }
    }
    private var time: Time = .init()
    
    // MARK: - Formatters
    
    private let timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.zeroFormattingBehavior = .pad //Depending on AM or PM
        return formatter
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTime(with: time)
    }
    
    // MARK: - Helpers
    
    private func setTime(with time: Time) {
        self.time = time
        timeLabel.text = timeFormatter.string(from: time.totalSeconds)
    }
    
    private func createDroidSelection() -> DroidTimeSelection {
        let droidSelection = DroidTimeSelection()
        droidSelection.config = config
        droidSelection.set(time: time)
        droidSelection.onCancelTapped = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        
        droidSelection.onOkTapped = { [weak self] in
            let value = droidSelection.value
            self?.setTime(with: value)
            self?.dismiss(animated: true, completion: nil)
        }
        return droidSelection
    }
    
    // MARK: - Actions

    @IBAction private func onShowTapped(_ sender: Any) {
        let droidSelection: UIView = createDroidSelection()
        let vc = UIViewController()
        let fakeDimView = UIView()
        fakeDimView.translatesAutoresizingMaskIntoConstraints = false
        fakeDimView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        fakeDimView.alpha = 0.0
        vc.view.backgroundColor = .clear
        vc.view.addSubview(fakeDimView)
        
        fakeDimView
            .leadingAnchor
            .constraint(equalTo: vc.view.leadingAnchor)
            .isActive = true
        fakeDimView
            .trailingAnchor
            .constraint(equalTo: vc.view.trailingAnchor)
            .isActive = true
        fakeDimView
            .topAnchor
            .constraint(equalTo: vc.view.topAnchor)
            .isActive = true
        fakeDimView
            .bottomAnchor
            .constraint(equalTo: vc.view.bottomAnchor)
            .isActive = true
        
        vc.view.addSubview(droidSelection)
        droidSelection
            .translatesAutoresizingMaskIntoConstraints = false
        droidSelection
            .leadingAnchor
            .constraint(
                equalTo: vc.view.safeAreaLayoutGuide.leadingAnchor,
                constant: 26)
            .isActive = true
        droidSelection
            .trailingAnchor
            .constraint(
                equalTo: vc.view.safeAreaLayoutGuide.trailingAnchor,
                constant: -26)
            .isActive = true
        droidSelection
            .centerXAnchor
            .constraint(
                equalTo: vc.view.safeAreaLayoutGuide.centerXAnchor)
            .isActive = true
        droidSelection
            .centerYAnchor
            .constraint(
                equalTo: vc.view.safeAreaLayoutGuide.centerYAnchor)
            .isActive = true
        droidSelection
            .topAnchor
            .constraint(
                greaterThanOrEqualTo: vc.view.safeAreaLayoutGuide.topAnchor)
            .isActive = true
        
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true) {
            UIView.animate(withDuration: 0.3) {
                fakeDimView.alpha = 1.0
            }
        }
    }
    
    @IBAction func onFormatValueChanged(_ sender: Any) {
        timeFormat = timeFormatSwitch.isOn ? .twentyFour : .twelve
    }
    
}

