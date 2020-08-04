//
//  DroidClockSelectorCell.swift
//  DroidTimeSelection
//
//  Created by Dan Draiman on 7/22/20.
//  Copyright © 2020 Nexxmark Studio. All rights reserved.
//

import UIKit

internal class DroidClockSelectorCell: UICollectionViewCell {
    internal static let cellId = "DroidClockSelector"
    var value: Int = -1
    var isTransparent: Bool {
        return titleLabel.text?.isEmpty ?? true
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .semibold)
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.textAlignment = .center
        label.isAccessibilityElement = true
        label.minimumScaleFactor = 0.25
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(titleLabel)
        titleLabel.anchor(in: contentView)
    }
    
    internal override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = contentView.frame.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setup(
        label: String,
        value: Int,
        bgColor: UIColor,
        titleColor: UIColor,
        titleFont: UIFont) {
        self.value = value
        self.titleLabel.text = label
        self.titleLabel.textColor = titleColor
        self.titleLabel.font = titleFont
        contentView.backgroundColor = bgColor
    }
}
