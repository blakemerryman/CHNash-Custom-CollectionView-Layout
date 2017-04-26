//
//  GridViewLayout.swift
//  Custom CollectionView Layouts
//
//  Created by Blake Merryman on 4/26/17.
//  Copyright © 2017 Blake Merryman. All rights reserved.
//

import UIKit

// MARK: - GridViewLayoutDelegate

@objc protocol GridViewLayoutDelegate {
  
  @objc optional var separatorHeight: CGFloat { get }
  @objc optional var separatorEdgeInsets: UIEdgeInsets { get }  // Ignores the top and bottom insets.
  @objc optional var separatorBackgroundColor: UIColor { get }
  @objc optional func heightForHeader(in section: Int) -> CGFloat
  @objc optional func heightForFooter(in section: Int) -> CGFloat
  @objc optional func heightForItem(at indexPath: IndexPath) -> CGFloat
}

// MARK: - GridViewLayout

class GridViewLayout: UICollectionViewLayout {

  var delegate: GridViewLayoutDelegate?

  private var contentSize: CGSize = .zero
  private var shouldPage = false

  private(set) var headerLayoutAttributes: [IndexPath : UICollectionViewLayoutAttributes] = [:]
  private(set) var footerLayoutAttributes: [IndexPath : UICollectionViewLayoutAttributes] = [:]
  private(set) var itemLayoutAttributes: [IndexPath : UICollectionViewLayoutAttributes] = [:]
  private(set) var separatorLayoutAttributes: [IndexPath : UICollectionViewLayoutAttributes] = [:]

  override var collectionViewContentSize: CGSize {
    return contentSize
  }

  override func prepare() {
    super.prepare()

    guard let collectionView = self.collectionView, let dataSource = collectionView.dataSource else {
      return
    }

    headerLayoutAttributes.removeAll()
    footerLayoutAttributes.removeAll()
    itemLayoutAttributes.removeAll()
    separatorLayoutAttributes.removeAll()

    let separatorClass = HorizontalSeparatorReusableView.self
    let separatorKind = String(describing: separatorClass)
    register(separatorClass, forDecorationViewOfKind: separatorKind)

    let availableWidth = collectionView.bounds.width

    var xCursor: CGFloat = 0.0
    var yCursor: CGFloat = 0.0

    // Layout sections...

    let sections = dataSource.numberOfSections?(in: collectionView) ?? 0

    for section in 0..<sections {

      // Layout Header
      let headerIndexPath = IndexPath(item: 0, section: section)
      let headerAttributes = supplementaryLayoutAttributes(forKind: UICollectionElementKindSectionHeader,
                                                           startingAt: CGPoint(x: xCursor, y: yCursor),
                                                           width: availableWidth,
                                                           height: delegate?.heightForHeader?(in: section) ?? 0.0,
                                                           at: headerIndexPath)

      headerLayoutAttributes[headerIndexPath] = headerAttributes
      yCursor += headerAttributes.frame.height

      // Layout all items in section (including separators)...
      let itemsInSection = dataSource.collectionView(collectionView, numberOfItemsInSection: section)
      let lastItem = itemsInSection - 1

      for item in 0..<itemsInSection {

        // layout item

        let itemIndexPath = IndexPath(item: item, section: section)
        let itemAttributes = itemLayoutAttributes(startingAt: CGPoint(x: xCursor, y: yCursor),
                                                  width: availableWidth,
                                                  height: delegate?.heightForItem?(at: itemIndexPath) ?? 0.0,
                                                  at: itemIndexPath)

        itemLayoutAttributes[itemIndexPath] = itemAttributes
        yCursor += itemAttributes.frame.height

        // layout separator (if needed)
        if item < lastItem {

          let separatorHeight = delegate?.separatorHeight ?? 0.0
          let separatorAttributes = HorizontalSeparatorReusableViewLayoutAttributes(forDecorationViewOfKind: separatorKind, with: itemIndexPath)

          separatorAttributes.backgroundColor = delegate?.separatorBackgroundColor
          separatorAttributes.edgeInsets = delegate?.separatorEdgeInsets
          separatorAttributes.frame = CGRect(origin: CGPoint(x: xCursor, y: yCursor),
                                             size: CGSize(width: availableWidth, height: separatorHeight))
          separatorLayoutAttributes[itemIndexPath] = separatorAttributes
          yCursor += separatorAttributes.frame.height
        }
      }

      // Layout Footer

      let footerIndexPath = IndexPath(item: 0, section: section)
      let footerAttributes = supplementaryLayoutAttributes(forKind: UICollectionElementKindSectionFooter,
                                                           startingAt: CGPoint(x: xCursor, y: yCursor),
                                                           width: availableWidth,
                                                           height: delegate?.heightForFooter?(in: section) ?? 0.0,
                                                           at: footerIndexPath)

      footerLayoutAttributes[footerIndexPath] = footerAttributes
      yCursor += footerAttributes.frame.height
    }

    // Set xCursor to the furthest expected x coordinate to ensure correct content size.
    xCursor = availableWidth

    contentSize = CGSize(width: xCursor, height: yCursor)
  }

  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }

  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

    var layoutAttributes: [UICollectionViewLayoutAttributes] = []

    headerLayoutAttributes.forEach { (indexPath, attributes) in
      if rect.intersects(attributes.frame) {
        layoutAttributes.append(attributes)
      }
    }

    footerLayoutAttributes.forEach { (indexPath, attributes) in
      if rect.intersects(attributes.frame) {
        layoutAttributes.append(attributes)
      }
    }

    itemLayoutAttributes.forEach { (indexPath, attributes) in
      if rect.intersects(attributes.frame) {
        layoutAttributes.append(attributes)
      }
    }

    separatorLayoutAttributes.forEach { (indexPath, attributes) in
      if rect.intersects(attributes.frame) {
        layoutAttributes.append(attributes)
      }
    }

    return layoutAttributes

  }

  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return itemLayoutAttributes[indexPath]
  }

  override func layoutAttributesForSupplementaryView(ofKind elementKind: String,
                                                     at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    if elementKind == UICollectionElementKindSectionHeader {
      return headerLayoutAttributes[indexPath]
    }
    else if elementKind == UICollectionElementKindSectionFooter {
      return footerLayoutAttributes[indexPath]
    }
    else {
      return nil
    }
  }

  override func layoutAttributesForDecorationView(ofKind elementKind: String,
                                                  at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return separatorLayoutAttributes[indexPath]
  }
  
}

// MARK: - Private Helpers

fileprivate extension GridViewLayout {

  func itemLayoutAttributes(startingAt coordinates: CGPoint,
                            width: CGFloat,
                            height: CGFloat,
                            at indexPath: IndexPath) -> UICollectionViewLayoutAttributes {

    let size = CGSize(width: width, height: height)
    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
    attributes.frame = CGRect(origin: coordinates, size: size)
    return attributes
  }

  func supplementaryLayoutAttributes(forKind kind: String,
                                     startingAt coordinates: CGPoint,
                                     width: CGFloat,
                                     height: CGFloat,
                                     at indexPath: IndexPath) -> UICollectionViewLayoutAttributes {

    let size = CGSize(width: width, height: height)
    let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: indexPath)
    attributes.frame = CGRect(origin: coordinates, size: size)
    return attributes
  }

}