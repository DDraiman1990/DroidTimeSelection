//
//  ViewController.swift
//  DroidTimeSelection
//
//  Created by DDraiman1990 on 07/25/2020.
//  Copyright © 2020 Nexxmark Studio. All rights reserved.
//

import UIKit
import DroidTimeSelection

@available(iOS 13.0, *)
class ViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var showSecondsSwitch: UISwitch!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var timeFormatSwitch: UISwitch!
    @IBOutlet private weak var manualTimePickerWrapper: UIView!
    private let picker = DroidUITimePicker()
    
    // MARK: - Configurations
    
    private var timeFormat: DroidTimeFormat = .twelve
    private var time: Time = .init()
    
    // MARK: - Formatters
    
    private let timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad //Depending on AM or PM
        return formatter
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manualTimePickerWrapper.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.topAnchor.constraint(equalTo: manualTimePickerWrapper.topAnchor).isActive = true
        picker.bottomAnchor.constraint(equalTo: manualTimePickerWrapper.bottomAnchor).isActive = true
        picker.leadingAnchor.constraint(equalTo: manualTimePickerWrapper.leadingAnchor).isActive = true
        picker.trailingAnchor.constraint(equalTo: manualTimePickerWrapper.trailingAnchor).isActive = true
        picker.timeFormat = self.timeFormat
        picker.showSeconds = showSecondsSwitch.isOn
        onShowSecondsChanged(self)
    }
    
    // MARK: - Helpers
    
    private func setTime(with time: Time) {
        self.time = time
        timeLabel.text = timeFormatter.string(from: time.timeInterval)
    }
    
    // MARK: - Actions

    @IBAction private func onShowTapped(_ sender: Any) {
        var style = HybridStyle()
        style.picker.titleColor = .white
        style.clock.indicatorColor = .blue
        style.modeButtonTint = .white
        style.cancelButtonContent = .text(title: "CANCEL")
        style.cancelButtonColor = .white
        style.submitButtonColor = .white
        let vc = DroidFactory
            .Hybrid
            .viewController(
                timeFormat: timeFormat,
                showSeconds: self.showSecondsSwitch.isOn,
                style: style)
        vc.selector.set(time: self.time)
        vc.selector.onCancelTapped = {
            vc.dismiss(animated: true, completion: nil)
        }
        
        vc.selector.onOkTapped = {
            vc.dismiss(animated: true, completion: nil)
        }
        
        vc.selector.onSelectionChanged = { [weak self] value in
            print("TimeInterval: \(value.timeInterval)")
            self?.setTime(with: value)
        }
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onFormatValueChanged(_ sender: Any) {
        timeFormat = timeFormatSwitch.isOn ? .twentyFour : .twelve
        picker.timeFormat = timeFormat
    }
    @IBAction func onShowSecondsChanged(_ sender: Any) {
        let showSeconds = showSecondsSwitch.isOn
        picker.showSeconds = showSeconds
        timeFormatter.allowedUnits = showSeconds ?
            [.hour, .minute, .second] :
            [.hour, .minute]
        setTime(with: time)
    }
}

