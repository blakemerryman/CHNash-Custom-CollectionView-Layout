//
//  GridViewLayout+AttributeHelpers.swift
//  Custom CollectionView Layouts
//
//  Created by Blake Merryman on 4/26/17.
//  Copyright © 2017 Blake Merryman. All rights reserved.
//

import UIKit

extension GridViewLayout {

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

  func separatorLayoutAttributes(startingAt coordinates: CGPoint,
                                 width: CGFloat,
                                 height: CGFloat,
                                 backgroundColor: UIColor?,
                                 edgeInsets: UIEdgeInsets?,
                                 at indexPath: IndexPath) -> UICollectionViewLayoutAttributes {

    let separatorKind = String(describing: HorizontalSeparatorReusableView.self)
    let size = CGSize(width: width, height: height)
    let attributes = HorizontalSeparatorReusableViewLayoutAttributes(forDecorationViewOfKind: separatorKind, with: indexPath)
    attributes.backgroundColor = backgroundColor
    attributes.edgeInsets = edgeInsets
    attributes.frame = CGRect(origin: coordinates, size: size)
    return attributes
  }
  
  
}
