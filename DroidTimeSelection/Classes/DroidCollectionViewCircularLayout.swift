//
//  DroidCircularCollectionViewLayout.swift
//  DroidTimeSelection
//
//  Created by Dan Draiman on 7/22/20.
//  Copyright © 2020 Nexxmark Studio. All rights reserved.
//

import UIKit

internal class DroidCircularCollectionViewLayout: UICollectionViewLayout {
    private var circleCenter: CGPoint!
    private var circleRadius: CGFloat!
    
    /// Will return the size for a cell at a given index path
    /// - Parameter indexPath: Index path corresponding with the required cell.
    /// - Returns: CGSize representing cell's size.
    internal func sizeForItem(at indexPath: IndexPath) -> CGSize {
        let radiusDecrement = circleRadius * 0.4 * CGFloat(indexPath.section)
        let modifiedRadius = circleRadius - radiusDecrement
        let dimDecrement = 0.4 * 0.9 * CGFloat(indexPath.section)
        let dim = modifiedRadius * 0.4 - dimDecrement
        return CGSize(width: dim, height: dim)
    }
    
    /// Returns the center for a cell in a given index path.
    /// - Parameter indexPath: Index path corresponding with the required cell.
    /// - Returns: CGPoint? representing the cell's center. Nil if failed.
    private func centerForItem(at indexPath: IndexPath) -> CGPoint? {
        guard let numOfItems = collectionView?
            .numberOfItems(inSection: indexPath.section) else {
                return nil
        }
        let angle = 2 * .pi * CGFloat(indexPath.item) / CGFloat(numOfItems) - .pi / 2
        let radiusDecrement = circleRadius * 0.4 * CGFloat(indexPath.section)
        let modifiedRadius = circleRadius - radiusDecrement
        return CGPoint(
            x: circleCenter.x + modifiedRadius * cos(angle),
            y: circleCenter.y + modifiedRadius * sin(angle))
    }
    
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        
        circleCenter = CGPoint(
            x: collectionView.bounds.midX,
            y: collectionView.bounds.midY)
        let shortestAxisLength = min(
            collectionView.bounds.width,
            collectionView.bounds.height)
        circleRadius = shortestAxisLength * 0.4
    }
    
    override var collectionViewContentSize: CGSize {
        return collectionView!.bounds.size
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.center = centerForItem(at: indexPath) ?? .zero
            attributes.size = sizeForItem(at: indexPath)
            
            return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect)
        -> [UICollectionViewLayoutAttributes]? {
            var atts: [UICollectionViewLayoutAttributes] = []
            for section in 0..<collectionView!.numberOfSections {
                for item in 0 ..< collectionView!.numberOfItems(inSection: section) {
                    if let att = self.layoutAttributesForItem(
                        at: IndexPath(
                            item: item,
                            section: section)) {
                        atts.append(att)
                    }
                }
            }
            return atts
    }
    
    // MARK: - Handle insertion and deletion animation
    
    private var inserted: [IndexPath]?
    private var deleted: [IndexPath]?
    
    override func prepare(
        forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        
        inserted = updateItems
            .filter { $0.updateAction == .insert }
            .compactMap { $0.indexPathAfterUpdate }
        deleted = updateItems
            .filter { $0.updateAction == .delete }
            .compactMap { $0.indexPathBeforeUpdate }
    }
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        
        inserted = nil
        deleted = nil
    }
    
    override func initialLayoutAttributesForAppearingItem(
        at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var attributes = super.initialLayoutAttributesForAppearingItem(
            at: itemIndexPath)
        guard let inserted = inserted,
            inserted.contains(itemIndexPath) else { return attributes }
        
        attributes = layoutAttributesForItem(at: itemIndexPath)
        attributes?.center = CGPoint(
            x: collectionView!.bounds.midX,
            y: collectionView!.bounds.midY)
        attributes?.alpha = 0
        return attributes
    }
    
    override func finalLayoutAttributesForDisappearingItem(
        at itemIndexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
            var attributes = super.finalLayoutAttributesForDisappearingItem(
                at: itemIndexPath)
            guard let deleted = deleted, deleted.contains(itemIndexPath) else {
                return attributes
            }
            attributes = layoutAttributesForItem(at: itemIndexPath)
            attributes?.center = CGPoint(x: collectionView!.bounds.midX, y: collectionView!.bounds.midY)
            attributes?.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
            return attributes
    }
}
