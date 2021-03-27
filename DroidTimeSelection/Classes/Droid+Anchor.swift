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
    func embed(in parent: UIView,
               padding: CGFloat) {
        self.anchor(in: parent,
                    padding: UIEdgeInsets(
                        top: padding,
                        left: padding,
                        bottom: padding,
                        right: padding))
    }
    
    func embed(in parent: UIView,
               padding: UIEdgeInsets = .zero) {
        self.anchor(in: parent, padding: padding)
    }
    
    func embedInSafeArea(of parent: UIView,
                         padding: CGFloat = 0) {
        self.anchorInSafeArea(of: parent,
                              padding: UIEdgeInsets(
                                top: padding,
                                left: padding,
                                bottom: padding,
                                right: padding))
    }
    
    func embedInSafeArea(of parent: UIView,
                         padding: UIEdgeInsets = .zero) {
        self.anchorInSafeArea(of: parent, padding: padding)
    }
    
    func height(multiplier: CGFloat,
                relativeTo view: UIView,
                addedOffset: CGFloat = 0,
                priority: UILayoutPriority = .required) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = self.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier, constant: addedOffset)
        constraint.priority = priority
        constraint.isActive = true
    }
    
    func width(multiplier: CGFloat,
               relativeTo view: UIView,
               addedOffset: CGFloat = 0,
               priority: UILayoutPriority = .required) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = self.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier, constant: addedOffset)
        constraint.priority = priority
        constraint.isActive = true
    }
    
    func anchor(edge: AnchorType, to siblingEdge: AnchorType, sibling: UIView, padding: CGFloat = 0, priority: UILayoutPriority = .required)  {
        if let anchor = edge.xLayoutAnchor(for: self),
           let siblingAnchor = siblingEdge.xLayoutAnchor(for: sibling) {
            let constraint = anchor
                .constraint(
                    equalTo: siblingAnchor,
                    constant: padding)
            constraint.priority = min(edge.priority, siblingEdge.priority)
            constraint.isActive = true
        }
        if let anchor = edge.yLayoutAnchor(for: self),
           let siblingAnchor = siblingEdge.yLayoutAnchor(for: sibling) {
            let constraint = anchor
                .constraint(
                    equalTo: siblingAnchor,
                    constant: padding)
            constraint.priority = min(edge.priority, siblingEdge.priority)
            constraint.isActive = true
        }
    }
    
    func anchor(in parent: UIView, to edges: [AnchorType] = [], padding: UIEdgeInsets = .zero) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if edges.isEmpty {
            self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -padding.bottom).isActive = true
            self.topAnchor.constraint(equalTo: parent.topAnchor, constant: padding.top).isActive = true
            self.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: padding.left).isActive = true
            self.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -padding.right).isActive = true
        } else {
            for edge in edges {
                if let xAnchor = edge.xLayoutAnchor(for: self),
                   let parentXAnchor = edge.xLayoutAnchor(for: parent) {
                    let constraint = xAnchor
                        .constraint(
                            equalTo: parentXAnchor,
                            constant: edge.padding(from: padding))
                    constraint.priority = edge.priority
                    constraint.isActive = true
                }
                if let yAnchor = edge.yLayoutAnchor(for: self),
                   let parentYAnchor = edge.yLayoutAnchor(for: parent) {
                    let constraint = yAnchor
                        .constraint(
                            equalTo: parentYAnchor,
                            constant: edge.padding(from: padding))
                    constraint.priority = edge.priority
                    constraint.isActive = true
                }
            }
        }
    }
    
    func anchorInSafeArea(of parent: UIView, to edges: [AnchorType] = [], padding: UIEdgeInsets = .zero) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if edges.isEmpty {
            self.bottomAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.bottomAnchor, constant: -padding.bottom).isActive = true
            self.topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor, constant: padding.top).isActive = true
            self.leadingAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.leadingAnchor, constant: padding.left).isActive = true
            self.trailingAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.trailingAnchor, constant: -padding.right).isActive = true
        } else {
            for edge in edges {
                if let xAnchor = edge.xLayoutAnchor(for: self),
                   let parentXAnchor = edge.xLayoutAnchor(for: parent, safeArea: true) {
                    let constraint = xAnchor
                        .constraint(
                            equalTo: parentXAnchor,
                            constant: edge.padding(from: padding))
                    constraint.priority = edge.priority
                    constraint.isActive = true
                }
                if let yAnchor = edge.yLayoutAnchor(for: self),
                   let parentYAnchor = edge.yLayoutAnchor(for: parent, safeArea: true) {
                    let constraint = yAnchor
                        .constraint(
                            equalTo: parentYAnchor,
                            constant: edge.padding(from: padding))
                    constraint.priority = edge.priority
                    constraint.isActive = true
                }
            }
        }
    }
    
    func centerX(in parent: UIView, priority: UILayoutPriority = .required) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = self.centerXAnchor.constraint(equalTo: parent.centerXAnchor)
        constraint.priority = priority
        constraint.isActive = true
    }
    
    func centerY(in parent: UIView, priority: UILayoutPriority = .required) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = self.centerYAnchor.constraint(equalTo: parent.centerYAnchor)
        constraint.priority = priority
        constraint.isActive = true
    }
    
    func center(in parent: UIView, priority: UILayoutPriority = .required) {
        centerX(in: parent, priority: priority)
        centerY(in: parent, priority: priority)
    }
    
    func anchor(height: CGFloat, priority: UILayoutPriority = .required) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = self.heightAnchor.constraint(equalToConstant: height)
        constraint.priority = priority
        constraint.isActive = true
    }
    
    func anchor(width: CGFloat, priority: UILayoutPriority = .required) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = self.widthAnchor.constraint(equalToConstant: width)
        constraint.priority = priority
        constraint.isActive = true
    }
    
    func aspectRatio(widthMultiplier: CGFloat = 1.0, priority: UILayoutPriority = .required) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = self
            .widthAnchor
            .constraint(equalTo: self.heightAnchor,
                        multiplier: widthMultiplier)
        constraint.priority = priority
        constraint.isActive = true
    }
    
    func anchorYCenteredDynamicHeight(in parent: UIView, padding: UIEdgeInsets = .zero) {
        anchor(in: parent, to: [.left(), .right(), .gtTop(priority: .defaultLow), .gtBottom(priority: .defaultLow)], padding: padding)
        centerY(in: parent)
    }
}

@available(iOS 11.0, *)
internal enum AnchorType: Equatable {
    static func ==(lhs: AnchorType, rhs: AnchorType) -> Bool {
        switch (lhs, rhs) {
        case (.top, .top),
             (.bottom, .bottom),
             (.left, .left),
             (.right, .right),
             (.ltTop, .ltTop),
             (.ltBottom, .ltBottom),
             (.ltLeft, .ltLeft),
             (.ltRight, .ltRight),
             (.gtTop, .gtTop),
             (.gtBottom, .gtBottom),
             (.gtLeft, .gtLeft),
             (.gtRight, .gtRight):
            return true
        default:
            return false
        }
    }
    
    func xLayoutAnchor(for view: UIView, safeArea: Bool = false) -> NSLayoutXAxisAnchor? {
        switch self {
        case .left, .gtLeft, .ltLeft:
            return safeArea ? view.safeAreaLayoutGuide.leadingAnchor : view.leadingAnchor
        case .right, .gtRight, .ltRight:
            return safeArea ? view.safeAreaLayoutGuide.trailingAnchor: view.trailingAnchor
        default: return nil
        }
    }
    
    func yLayoutAnchor(for view: UIView, safeArea: Bool = false) -> NSLayoutYAxisAnchor? {
        switch self {
        case .top, .gtTop, .ltTop:
            return safeArea ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor
        case .bottom, .gtBottom, .ltBottom:
            return safeArea ? view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor
        default: return nil
        }
    }
    
    func padding(from edges: UIEdgeInsets) -> CGFloat {
        switch self {
        case .top, .ltTop, .gtTop: return edges.top
        case .bottom, .ltBottom, .gtBottom: return -edges.bottom
        case .left, .ltLeft, .gtLeft: return edges.left
        case .right, .ltRight, .gtRight:  return -edges.right
        }
    }
    
    var priority: UILayoutPriority {
        switch self {
        case .top(let priority): return priority
        case .bottom(let priority): return priority
        case .left(let priority): return priority
        case .right(let priority): return priority
        case .ltTop(let priority): return priority
        case .ltBottom(let priority): return priority
        case .ltLeft(let priority): return priority
        case .ltRight(let priority): return priority
        case .gtTop(let priority): return priority
        case .gtBottom(let priority): return priority
        case .gtLeft(let priority): return priority
        case .gtRight(let priority): return priority
        }
    }
    
    case top(priority: UILayoutPriority = .required),
         bottom(priority: UILayoutPriority = .required),
         left(priority: UILayoutPriority = .required),
         right(priority: UILayoutPriority = .required),
         ltTop(priority: UILayoutPriority = .required),
         ltBottom(priority: UILayoutPriority = .required),
         ltLeft(priority: UILayoutPriority = .required),
         ltRight(priority: UILayoutPriority = .required),
         gtTop(priority: UILayoutPriority = .required),
         gtBottom(priority: UILayoutPriority = .required),
         gtLeft(priority: UILayoutPriority = .required),
         gtRight(priority: UILayoutPriority = .required)
}

@available(iOS 11.0, *)
internal extension UIEdgeInsets {
    init(constant: CGFloat) {
        self.init(top: constant, left: constant, bottom: constant, right: constant)
    }
    
    init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical,
                  left: horizontal,
                  bottom: vertical,
                  right: horizontal)
    }
}
