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

  var separatorHeight: CGFloat { get }
  var separatorEdgeInsets: UIEdgeInsets { get }  // Ignores the top and bottom insets.
  var separatorBackgroundColor: UIColor { get }

  func heightForHeader(in section: Int) -> CGFloat
  func heightForFooter(in section: Int) -> CGFloat
  func heightForItem(at indexPath: IndexPath) -> CGFloat

  func widthForSection(section: Int) -> CGFloat
  
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

    let sections = dataSource.numberOfSections?(in: collectionView) ?? 0

    var xCursor: CGFloat = 0.0
    var yCursor: CGFloat = 0.0

    // Layout sections...

    var previousSectionMinY = yCursor
    var currentSectionMinY = yCursor

    for section in 0..<sections {

      let sectionWidth = delegate?.widthForSection(section: section) ?? 0.0
      let horizontallyExpand = sectionWidth < collectionView.bounds.width

      if horizontallyExpand {
        yCursor = previousSectionMinY
        currentSectionMinY = yCursor
      }

      // Layout Header
      let headerIndexPath = IndexPath(item: 0, section: section)
      let headerAttributes = supplementaryLayoutAttributes(forKind: UICollectionElementKindSectionHeader,
                                                           startingAt: CGPoint(x: xCursor, y: yCursor),
                                                           width: sectionWidth,
                                                           height: delegate?.heightForHeader(in: section) ?? 0.0,
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
                                                  width: sectionWidth,
                                                  height: delegate?.heightForItem(at: itemIndexPath) ?? 0.0,
                                                  at: itemIndexPath)

        itemLayoutAttributes[itemIndexPath] = itemAttributes
        yCursor += itemAttributes.frame.height

        // layout separator (if needed)
        if item < lastItem {
          let separatorAttributes = separatorLayoutAttributes(startingAt: CGPoint(x: xCursor, y: yCursor),
                                                              width: sectionWidth,
                                                              height: delegate?.separatorHeight ?? 0.0,
                                                              backgroundColor: delegate?.separatorBackgroundColor,
                                                              edgeInsets: delegate?.separatorEdgeInsets,
                                                              at: itemIndexPath)

          separatorLayoutAttributes[itemIndexPath] = separatorAttributes
          yCursor += separatorAttributes.frame.height
        }
      }

      // Layout Footer

      let footerIndexPath = IndexPath(item: 0, section: section)
      let footerAttributes = supplementaryLayoutAttributes(forKind: UICollectionElementKindSectionFooter,
                                                           startingAt: CGPoint(x: xCursor, y: yCursor),
                                                           width: sectionWidth,
                                                           height: delegate?.heightForFooter(in: section) ?? 0.0,
                                                           at: footerIndexPath)

      footerLayoutAttributes[footerIndexPath] = footerAttributes
      yCursor += footerAttributes.frame.height

      if horizontallyExpand {
        xCursor += sectionWidth
        previousSectionMinY = currentSectionMinY
      }
    }

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
    else { // Assume it's a footer
      return footerLayoutAttributes[indexPath]
    }
  }

  override func layoutAttributesForDecorationView(ofKind elementKind: String,
                                                  at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return separatorLayoutAttributes[indexPath]
  }
  
}
