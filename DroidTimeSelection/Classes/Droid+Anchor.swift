//
//  Droid+Anchor.swift
//  DroidTimeSelection
//
//  Created by Dan Draiman on 7/25/20.
//  Copyright © 2020 Nexxmark Studio. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
internal extension UIView {
    func height(multiplier: CGFloat, relativeTo view: UIView, addedOffset: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier, constant: addedOffset).isActive = true
    }
    
    func width(multiplier: CGFloat, relativeTo view: UIView, addedOffset: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier, constant: addedOffset).isActive = true
    }
    
    func anchor(in parent: UIView, to edges: [AnchorType] = [], padding: UIEdgeInsets = .zero) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if edges.contains(.bottom) || edges.isEmpty {
            self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -padding.bottom).isActive = true
        }
        if edges.contains(.top) || edges.isEmpty {
            self.topAnchor.constraint(equalTo: parent.topAnchor, constant: padding.top).isActive = true
        }
        if edges.contains(.left) || edges.isEmpty {
            self.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: padding.left).isActive = true
        }
        if edges.contains(.right) || edges.isEmpty {
            self.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -padding.right).isActive = true
        }
        
        if edges.contains(.ltBottom) || edges.isEmpty {
            self.bottomAnchor.constraint(lessThanOrEqualTo: parent.bottomAnchor, constant: -padding.bottom).isActive = true
        }
        if edges.contains(.ltTop) || edges.isEmpty {
            self.topAnchor.constraint(lessThanOrEqualTo: parent.topAnchor, constant: padding.top).isActive = true
        }
        if edges.contains(.ltLeft) || edges.isEmpty {
            self.leadingAnchor.constraint(lessThanOrEqualTo: parent.leadingAnchor, constant: padding.left).isActive = true
        }
        if edges.contains(.ltRight) || edges.isEmpty {
            self.trailingAnchor.constraint(lessThanOrEqualTo: parent.trailingAnchor, constant: -padding.right).isActive = true
        }
        
        if edges.contains(.gtBottom) || edges.isEmpty {
            self.bottomAnchor.constraint(greaterThanOrEqualTo: parent.bottomAnchor, constant: -padding.bottom).isActive = true
        }
        if edges.contains(.gtTop) || edges.isEmpty {
            self.topAnchor.constraint(greaterThanOrEqualTo: parent.topAnchor, constant: padding.top).isActive = true
        }
        if edges.contains(.gtLeft) || edges.isEmpty {
            self.leadingAnchor.constraint(greaterThanOrEqualTo: parent.leadingAnchor, constant: padding.left).isActive = true
        }
        if edges.contains(.gtRight) || edges.isEmpty {
            self.trailingAnchor.constraint(greaterThanOrEqualTo: parent.trailingAnchor, constant: -padding.right).isActive = true
        }
    }
    
    func anchorInContent(of parent: UIScrollView, to edges: [AnchorType] = [], padding: UIEdgeInsets = .zero) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if edges.contains(.bottom) || edges.isEmpty {
            self.bottomAnchor.constraint(equalTo: parent.contentLayoutGuide.bottomAnchor, constant: -padding.bottom).isActive = true
        }
        if edges.contains(.top) || edges.isEmpty {
            self.topAnchor.constraint(equalTo: parent.contentLayoutGuide.topAnchor, constant: padding.top).isActive = true
        }
        if edges.contains(.left) || edges.isEmpty {
            self.leadingAnchor.constraint(equalTo: parent.contentLayoutGuide.leadingAnchor, constant: padding.left).isActive = true
        }
        if edges.contains(.right) || edges.isEmpty {
            self.trailingAnchor.constraint(equalTo: parent.contentLayoutGuide.trailingAnchor, constant: -padding.right).isActive = true
        }
        
        if edges.contains(.ltBottom) || edges.isEmpty {
            self.bottomAnchor.constraint(lessThanOrEqualTo: parent.contentLayoutGuide.bottomAnchor, constant: -padding.bottom).isActive = true
        }
        if edges.contains(.ltTop) || edges.isEmpty {
            self.topAnchor.constraint(lessThanOrEqualTo: parent.contentLayoutGuide.topAnchor, constant: padding.top).isActive = true
        }
        if edges.contains(.ltLeft) || edges.isEmpty {
            self.leadingAnchor.constraint(lessThanOrEqualTo: parent.contentLayoutGuide.leadingAnchor, constant: padding.left).isActive = true
        }
        if edges.contains(.ltRight) || edges.isEmpty {
            self.trailingAnchor.constraint(lessThanOrEqualTo: parent.contentLayoutGuide.trailingAnchor, constant: -padding.right).isActive = true
        }
        
        if edges.contains(.gtBottom) || edges.isEmpty {
            self.bottomAnchor.constraint(greaterThanOrEqualTo: parent.contentLayoutGuide.bottomAnchor, constant: -padding.bottom).isActive = true
        }
        if edges.contains(.gtTop) || edges.isEmpty {
            self.topAnchor.constraint(greaterThanOrEqualTo: parent.contentLayoutGuide.topAnchor, constant: padding.top).isActive = true
        }
        if edges.contains(.gtLeft) || edges.isEmpty {
            self.leadingAnchor.constraint(greaterThanOrEqualTo: parent.contentLayoutGuide.leadingAnchor, constant: padding.left).isActive = true
        }
        if edges.contains(.gtRight) || edges.isEmpty {
            self.trailingAnchor.constraint(greaterThanOrEqualTo: parent.contentLayoutGuide.trailingAnchor, constant: -padding.right).isActive = true
        }
    }
    
    func anchorInSafeArea(of parent: UIView, to edges: [AnchorType] = [], padding: UIEdgeInsets = .zero) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if edges.contains(.bottom) || edges.isEmpty {
            self.bottomAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.bottomAnchor, constant: -padding.bottom).isActive = true
        }
        if edges.contains(.top) || edges.isEmpty {
            self.topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor, constant: padding.top).isActive = true
        }
        if edges.contains(.left) || edges.isEmpty {
            self.leadingAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.leadingAnchor, constant: padding.left).isActive = true
        }
        if edges.contains(.right) || edges.isEmpty {
            self.trailingAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.trailingAnchor, constant: -padding.right).isActive = true
        }
        
        if edges.contains(.ltBottom) || edges.isEmpty {
            self.bottomAnchor.constraint(lessThanOrEqualTo: parent.safeAreaLayoutGuide.bottomAnchor, constant: -padding.bottom).isActive = true
        }
        if edges.contains(.ltTop) || edges.isEmpty {
            self.topAnchor.constraint(lessThanOrEqualTo: parent.safeAreaLayoutGuide.topAnchor, constant: padding.top).isActive = true
        }
        if edges.contains(.ltLeft) || edges.isEmpty {
            self.leadingAnchor.constraint(lessThanOrEqualTo: parent.safeAreaLayoutGuide.leadingAnchor, constant: padding.left).isActive = true
        }
        if edges.contains(.ltRight) || edges.isEmpty {
            self.trailingAnchor.constraint(lessThanOrEqualTo: parent.safeAreaLayoutGuide.trailingAnchor, constant: -padding.right).isActive = true
        }
        
        if edges.contains(.gtBottom) || edges.isEmpty {
            self.bottomAnchor.constraint(greaterThanOrEqualTo: parent.safeAreaLayoutGuide.bottomAnchor, constant: -padding.bottom).isActive = true
        }
        if edges.contains(.gtTop) || edges.isEmpty {
            self.topAnchor.constraint(greaterThanOrEqualTo: parent.safeAreaLayoutGuide.topAnchor, constant: padding.top).isActive = true
        }
        if edges.contains(.gtLeft) || edges.isEmpty {
            self.leadingAnchor.constraint(greaterThanOrEqualTo: parent.safeAreaLayoutGuide.leadingAnchor, constant: padding.left).isActive = true
        }
        if edges.contains(.gtRight) || edges.isEmpty {
            self.trailingAnchor.constraint(greaterThanOrEqualTo: parent.safeAreaLayoutGuide.trailingAnchor, constant: -padding.right).isActive = true
        }
    }
    
    func centerX(in parent: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
    }
    
    func centerY(in parent: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
    }
    
    func center(in parent: UIView) {
        centerX(in: parent)
        centerY(in: parent)
    }
    
    func anchor(height: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func anchor(width: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
}

internal enum AnchorType {
    case top, bottom, left, right, ltTop, ltBottom, ltLeft, ltRight, gtTop, gtBottom, gtLeft, gtRight
}
