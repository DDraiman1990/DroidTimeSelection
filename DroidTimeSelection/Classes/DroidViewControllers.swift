//
//  HybridDroidViewController.swift
//  DroidTimeSelection
//
//  Created by Dan Draiman on 3/21/21.
//  Copyright © 2020 Nexxmark Studio. All rights reserved.
//

import UIKit

/// A base view controller allowing a an inner subview and a dimmed background.
public class DimmedViewController: UIViewController {
    private let dimView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.alpha = 0.0
        return view
    }()
        
    public init(subview: UIView) {
        super.init(nibName: nil, bundle: nil)
        setup(subview: subview)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    internal func setup(subview: UIView) {
        view.backgroundColor = .clear
        view.addSubview(dimView)
        dimView.anchor(in: view)
        view.addSubview(subview)
        subview
            .translatesAutoresizingMaskIntoConstraints = false
        subview.anchorYCenteredDynamicHeight(
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

///A simple ViewController presenting the Hybrid version of the selector with
///a dimmed background
///
/// Displays both versions of the selector.
/// Default mode is Clock selection.
///
/// Set the callbacks for `selector.onOkTapped`, `selector.onCancelTapped` and `selector.onSelectionChanged`
/// to get updates from this component.
///
/// - Change `selector.timeFormat` to change the selection mode for both selectors.
/// - Change `selector.style` to change the style of the selectors and the menu. See `HybridStyle`, `ClockStyle` and `PickerStyle` for more details about possible styling.
public final class HybridDroidViewController: DimmedViewController {
    @IBOutlet public var selector: DroidHybridSelector!
    
    public init(selector: DroidHybridSelector) {
        self.selector = selector
        super.init(subview: selector)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup(subview: selector)
        commonInit()
    }
    
    private func commonInit() {
        selector.onCancelTapped = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
}
