//
//  HybridDroidViewController.swift
//  DroidTimeSelection
//
//  Created by Dan Draiman on 3/21/21.
//

import UIKit

public class DroidViewController: UIViewController {
    private let dimView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.alpha = 0.0
        return view
    }()
    
    private let droidSelectionContainer = UIView()
    
    public init(droidSelection: UIView) {
        super.init(nibName: nil, bundle: nil)
        setup(droidSelection: droidSelection)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    internal func setup(droidSelection: UIView) {
        droidSelectionContainer.addSubview(droidSelection)
        droidSelection.anchor(in: droidSelectionContainer)
        view.backgroundColor = .clear
        view.addSubview(dimView)
        dimView.anchor(in: view)
        view.addSubview(droidSelection)
        droidSelection
            .translatesAutoresizingMaskIntoConstraints = false
        droidSelection.anchorYCenteredDynamicHeight(
            in: view,
            padding: .init(constant: 26))
        
        modalPresentationStyle = .overFullScreen
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.dimView.alpha = 1.0
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.3) {
            self.dimView.alpha = 0.0
        }
    }
}

public final class HybridDroidViewController: DroidViewController {
    @IBOutlet public var selector: DroidHybridSelector!
    
    init(selector: DroidHybridSelector) {
        self.selector = selector
        super.init(droidSelection: selector)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup(droidSelection: selector)
        commonInit()
    }
    
    private func commonInit() {
        selector.onCancelTapped = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
}

public final class ClockDroidViewController: DroidViewController {
    @IBOutlet public var selector: DroidClockSelector!
    
    init(selector: DroidClockSelector) {
        self.selector = selector
        super.init(droidSelection: selector)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup(droidSelection: selector)
    }
}

public final class PickerDroidViewController: DroidViewController {
    @IBOutlet public var selector: DroidPickerSelector!
    
    init(selector: DroidPickerSelector) {
        self.selector = selector
        super.init(droidSelection: selector)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup(droidSelection: selector)
    }
}
