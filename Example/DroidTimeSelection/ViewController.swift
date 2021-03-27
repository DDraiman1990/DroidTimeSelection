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
    
    private var timeFormat: DroidTimeFormat = .twelve
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
    
    // MARK: - Actions

    @IBAction private func onShowTapped(_ sender: Any) {
        let vc = DroidFactory.Hybrid.viewController(timeFormat: timeFormat, style: .init())
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onFormatValueChanged(_ sender: Any) {
        timeFormat = timeFormatSwitch.isOn ? .twentyFour : .twelve
    }
}

